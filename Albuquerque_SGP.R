###########################################################
###
### Albuquerque SGP Analysis
###
###########################################################

### Load SGP Package

require(SGP)


### Load data

load("Data/Albuquerque_Data_LONG.Rdata")


### Calculate SGPs

Albuquerque_SGP <- abcSGP(
                        sgp_object=Albuquerque_Data_LONG,
                        sgp.percentiles=TRUE,
                        sgp.projections=TRUE,
                        sgp.projections.lagged=TRUE,
                        sgp.percentiles.baseline=FALSE,
                        sgp.projections.baseline=FALSE,
                        sgp.projections.lagged.baseline=FALSE,
                        save.intermediate.results=TRUE,
                        sgPlot.demo.report=TRUE,
                        sgp.minimum.default.panel.years=2)


### Save results

save(Albuquerque_SGP, file="Data/Albuquerque_SGP.Rdata")
