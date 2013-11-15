######################################################################
###
### Script to produce Albuquerque long data file
###
######################################################################

### Load SGP package

require(SGP)
require(data.table)


### Load base data file

Albuquerque_Data_LONG <- read.csv("Data/Base_Files/Albuquerque_Data_LONG.csv", header=TRUE, comment.char="", quote="")


###

Albuquerque_Data_LONG$Valid.Case <- "VALID_CASE"

### Tidy up data

Albuquerque_Data_LONG$ID <- as.character(Albuquerque_Data_LONG$ID)

levels(Albuquerque_Data_LONG$School.Enrollment.Status) <- "Enrolled School: Yes"
levels(Albuquerque_Data_LONG$District.Enrollment.Status) <- c("Enrolled District: Yes", "Enrolled District: Yes")
levels(Albuquerque_Data_LONG$State.Enrollment.Status) <- "Enrolled State: Yes"

levels(Albuquerque_Data_LONG$District.Name)[2] <- "Albuquerque Public Schools"

### Cleanup school names

##Albuquerque_Data_LONG <- as.data.table(Albuquerque_Data_LONG)
##Albuquerque_Data_LONG$TMP_LENGTH <- nchar(as.character(Albuquerque_Data_LONG$School.Name))
##setkey(Albuquerque_Data_LONG, School.Number, Year, TMP_LENGTH)

##levels(Albuquerque_Data_LONG$School.Name)[1] <- " "
##levels(Albuquerque_Data_LONG$School.Name) <- sapply(levels(Albuquerque_Data_LONG$School.Name), capwords)

Albuquerque_Data_LONG$Year <- as.character(Albuquerque_Data_LONG$Year)


Albuquerque_Data_LONG$GRADE_ORIGINAL <- Albuquerque_Data_LONG$Grade

Albuquerque_Data_LONG$Grade <- NULL
Albuquerque_Data_LONG$Grade[Albuquerque_Data_LONG$Scale.Score >= 300 & Albuquerque_Data_LONG$Scale.Score < 400] <- "3"
Albuquerque_Data_LONG$Grade[Albuquerque_Data_LONG$Scale.Score >= 400 & Albuquerque_Data_LONG$Scale.Score < 500] <- "4"
Albuquerque_Data_LONG$Grade[Albuquerque_Data_LONG$Scale.Score >= 500 & Albuquerque_Data_LONG$Scale.Score < 600] <- "5"
Albuquerque_Data_LONG$Grade[Albuquerque_Data_LONG$Scale.Score >= 600 & Albuquerque_Data_LONG$Scale.Score < 700] <- "6"
Albuquerque_Data_LONG$Grade[Albuquerque_Data_LONG$Scale.Score >= 700 & Albuquerque_Data_LONG$Scale.Score < 800] <- "7"
Albuquerque_Data_LONG$Grade[Albuquerque_Data_LONG$Scale.Score >= 800 & Albuquerque_Data_LONG$Scale.Score < 900] <- "8"
Albuquerque_Data_LONG$Grade[Albuquerque_Data_LONG$Scale.Score >= 1100 & Albuquerque_Data_LONG$Scale.Score < 1200] <- "HS"
Albuquerque_Data_LONG$Valid.Case[Albuquerque_Data_LONG$Scale.Score < 300 | Albuquerque_Data_LONG$Scale.Score >= 1200] <- "INVALID CASE"
Albuquerque_Data_LONG$Valid.Case[Albuquerque_Data_LONG$Grade=="HS"] <- "INVALID CASE"

levels(Albuquerque_Data_LONG$Last_Name) <- sapply(levels(Albuquerque_Data_LONG$Last_Name), capwords)
levels(Albuquerque_Data_LONG$First_Name) <- sapply(levels(Albuquerque_Data_LONG$First_Name), capwords)

Albuquerque_Data_LONG$Gender[Albuquerque_Data_LONG$Gender==""] <- NA
Albuquerque_Data_LONG$Gender <- factor(Albuquerque_Data_LONG$Gender)
levels(Albuquerque_Data_LONG$Gender) <- c("Female", "Male")


Albuquerque_Data_LONG$Ethnicity[Albuquerque_Data_LONG$Ethnicity %in% c("", "NULL")] <- NA
Albuquerque_Data_LONG$Ethnicity <- factor(Albuquerque_Data_LONG$Ethnicity)
levels(Albuquerque_Data_LONG$Ethnicity)[6] <- "Native American"

Albuquerque_Data_LONG$Content.Area [Albuquerque_Data_LONG$Content.Area=="0"] <- "Math"
Albuquerque_Data_LONG$Content.Area <- factor(Albuquerque_Data_LONG$Content.Area)
levels(Albuquerque_Data_LONG$Content.Area) <- c("MATHEMATICS", "READING")
Albuquerque_Data_LONG$Content.Area <- as.character(Albuquerque_Data_LONG$Content.Area)

Albuquerque_Data_LONG$Valid.Case[Albuquerque_Data_LONG$Achievement.Level==5] <- "INVALID CASE"
Albuquerque_Data_LONG$Achievement.Level[Albuquerque_Data_LONG$Achievement.Level==5] <- NA
Albuquerque_Data_LONG$Achievement.Level <- factor(Albuquerque_Data_LONG$Achievement.Level, 
	labels=c("Beginning Step", "Nearing Proficient", "Proficient", "Advanced"), ordered=TRUE)

Albuquerque_Data_LONG$High.Need.Status[Albuquerque_Data_LONG$High.Need.Status==""] <- NA
Albuquerque_Data_LONG$High.Need.Status <- factor(Albuquerque_Data_LONG$High.Need.Status)


### Upcase to name

names(Albuquerque_Data_LONG) <- toupper(names(Albuquerque_Data_LONG))

names(Albuquerque_Data_LONG) <- gsub("[.]", "_", names(Albuquerque_Data_LONG))


### Identify VALID_CASES and INVALID_CASES

Albuquerque_Data_LONG <- as.data.table(Albuquerque_Data_LONG)
setkeyv(Albuquerque_Data_LONG, c("VALID_CASE", "CONTENT_AREA", "YEAR", "ID"))
tmp.dups <- Albuquerque_Data_LONG[duplicated(Albuquerque_Data_LONG)][,c("VALID_CASE", "CONTENT_AREA", "YEAR", "ID"), with=FALSE]
tmp.dups <- unique(tmp.dups)
Albuquerque_Data_LONG[tmp.dups, VALID_CASE:="INVALID CASE"]


### Convert back to data.frame and Save output

Albuquerque_Data_LONG <- as.data.frame(Albuquerque_Data_LONG)
save(Albuquerque_Data_LONG, file="Data/Albuquerque_Data_LONG.Rdata")
