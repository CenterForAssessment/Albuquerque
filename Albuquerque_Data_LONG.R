######################################################################
###
### Script to produce Albuquerque long data file
###
######################################################################

### Load SGP package

require(SGP)


### Load base data file

Albuquerque_Data_LONG <- read.table("Data/Base_Files/Albuquerque_Data_LONG_BASE_FILE.txt", sep="|", header=TRUE, comment.char="", quote="")


### Tidy up data


### Identify VALID_CASES and INVALID_CASES

Albuquerque_Data_LONG[["VALID_CASE"]] <- factor(1, levels=1:2, labels=c("VALID_CASE", "INVALID_CASE"))

Albuquerque_Data_LONG <- as.data.table(Albuquerque_Data_LONG)
setkeyv(Albuquerque_Data_LONG, c("VALID_CASE", "CONTENT_AREA", "YEAR", "ID", "GRADE", "SCALE_SCORE"))
setkeyv(Albuquerque_Data_LONG, c("VALID_CASE", "CONTENT_AREA", "YEAR", "ID"))
Albuquerque_Data_LONG[["VALID_CASE"]][which(duplicated(Albuquerque_Data_LONG))-1] <- "INVALID_CASE"



### Convert back to data.frame and Save output

Albuquerque_Data_LONG <- as.data.frame(Albuquerque_Data_LONG)
save(Albuquerque_Data_LONG, file="Data/Albuquerque_Data_LONG.Rdata")
