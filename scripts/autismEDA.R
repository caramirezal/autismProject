library(beadarraySNP)

reportFile <- "~/scripts/autismProject/autism_FinalReport.txt"
ssheet <- "~/scripts/autismProject/SampleSheet.csv"
opa <- "~/dataBases/GoldenGate_U15_025 AT/GenomeStudio/GS0014416-OPA.opa"

SNPData <- read.SnpSetIllumina(reportfile = reportFile,
                               samplesheet = ssheet)

SNPnrm<-normalizeBetweenAlleles.SNP(SNPData)

SNPnrm<-normalizeWithinArrays.SNP(SNPnrm,callscore=0.8,relative=TRUE,fixed=FALSE,quantilepersample=T)

SNPnrm<-normalizeLoci.SNP(SNPnrm,normalizeTo=2)

SNPnrm<-SNPnrm[featureData(SNPnrm)$CHR %in% c("4","16","17","18","19","20"),]

reportSamplesSmoothCopyNumber(SNPnrm,normalizedTo=2,smooth.lambda=4)

qc <- calculateQCarray(SNPData)

head(pData(SNPData))
