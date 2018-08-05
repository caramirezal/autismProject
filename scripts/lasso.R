library(dplyr)
library(caret)
library(glmnet)

## extractting alleles data using plink. Change local paths
## plink --file <dataPath> --recodeAD --out <outputFile>
## change your local paths
#extractAlleles <- "plink --file /media/carlos/SoMobileOTB/Arrays/PsychArray\ AT\ 5p/U15_118_Placa5/PLINK/PLINK_060117_0128/PLINK --chr 2 --from-kb 1000 --to-kb 1100  --recodeAD --out data/extractedSNPsPlink"
#system(extractaAlleles)

## pre reading
alleles <- readLines("~/data/extractedSNPsPlink.raw",n=2)
alleles <- read.table("~/data/extractedSNPsPlink.raw",sep = " ",nrows = 2,header = TRUE)

## loading data
alleles <- read.table("~/data/extractedSNPsPlink.raw",header = TRUE)
dim(alleles)
head(alleles)

## preprocessing 
## dropping some unwanted & constant variables
dropVars <- c("IID","FID","PAT","MAT","SEX","PHENOTYPE")
alleles.p <- select(alleles,-dropVars)
alleles.p <- select(alleles.p,-nearZeroVar(alleles.p))
alleles.p <- alleles.p[complete.cases(alleles.p),]
dim(alleles.p)
head(alleles.p)

## somulation of an output values as
## output = Allele + noise 
output <- alleles.p$rs6717701_G + rnorm(nrow(alleles.p),sd=0.35)
output <- (output - min(output))/(max(output)-min(output))

## performing logistic regression 
logReg <- glm(rs11675840_HET~.,data = alleles.p,family = binomial(link = "logit"))
summary(logReg)

## performing lasso
lasso <- cv.glmnet(y = output,x = as.matrix(alleles.p),nfolds = 10)