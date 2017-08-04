#######################################################################
#
# import-beadstudio.R
# Stephen Turner, December 2014
#
# Ask the core to export text file data with the info below.
# Assumes control probe file has for each sample:
# ProbeID, AVG_Signal, BEAD_STDERR, Avg_NBEADS, Detection Pval.
# Assumes sample probe file has for each sample:
# ProbeID, Symbol, AVG_Signal, BEAD_STDERR, Avg_NBEADS, Detection Pval
# And other annotation columns:
# SEARCH_KEY, ILMN_GENE, CHROMOSOME, DEFINITION, SYNONYMS
#######################################################################

# Load libraries
library(beadarray)
library(limma)
## Pick one.
library(illuminaHumanv4.db)
library(illuminaMousev2.db)

# Load data
## location of your probe and qc files
dataFile <- "data/SampleProbeProfile.txt"
qcFile <-   "data/ControlProbeProfile.txt"
## create an expressionset
eset <- readBeadSummaryData(dataFile=dataFile, qcFile=qcFile,
                         ProbeID="PROBE_ID", controlID="ProbeID",
                         skip=0, qc.skip=0,
                         annoCols=c("SYMBOL", "DEFINITION", "SYNONYMS", "CHROMOSOME", "ILMN_GENE", "SEARCH_KEY"))

# Optional: Annotate the samples (example)
## Manually (bad)
pData(eset)$condition <- factor(rep(c("ctl", "trt"), each=3))
## Better / more reproducible to do this by importing a csv/table than doing it manually. You've been warned.
pData <- read.csv("data/metadata.csv", header=TRUE, row.names=1)

# Optional: I use Illumina's annotation. You can annotate the probes yourself if you want. 
# See http://www.bioconductor.org/help/workflows/annotation/annotation/

# Optional: Remove probes that aren't annotated with a gene
annotated <- !is.na((fData(eset)$SYMBOL))
table(annotated)
eset <- eset[annotated,]
rm(annotated)

# Normalize, transform
eset <- normaliseIllumina(eset, method="quantile", transform= "log2")

# Some of limma's stuff downstream doesn't work with whatever kind
# of object that you get out of normaliseIllumina().
# I coerce it to an "ExpressionSet" and everything seems to work fine.
class(eset) <- "ExpressionSet"

# Analyze with limma
## Make a design matrix
## Make a contrast matrix
## analyze the normal way: lmFit(), contrasts.fit(), eBayes(), topTable()
