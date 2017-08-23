SNPData <- read.SnpSetIllumina(reportfile = "autism_FinalReport.txt",
                               samplesheet = "SampleSheet.csv",
                               manifestpath = "GoldenGate_U15_025 AT/GenomeStudio/GS0014416-OPA.opa")

SNPnrm<-normalizeBetweenAlleles.SNP(SNPData)

SNPnrm<-normalizeWithinArrays.SNP(SNPnrm,callscore=0.8,relative=TRUE,fixed=FALSE,quantilepersample=T)

SNPnrm<-normalizeLoci.SNP(SNPnrm,normalizeTo=2)

SNPnrm<-SNPnrm[featureData(SNPnrm)$CHR %in% c("4","16","17","18","19","20"),]

reportSamplesSmoothCopyNumber(SNPnrm,normalizedTo=2,smooth.lambda=4)

qc <- calculateQCarray(SNPData)

head(pData(SNPData))
