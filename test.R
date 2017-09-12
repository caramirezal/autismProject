## test

library(beadarraySNP)

datadir <- system.file("testdata", package="beadarraySNP")
datasheet <- paste(datadir,"4samples_opa4.csv",sep="/")

## snp tutorial data
SNPData.t <- read.SnpSetIllumina(datasheet,datadir) 
SNPData.t

slotNames(SNPData.t)

head(assayData(SNPData.t)$call)
