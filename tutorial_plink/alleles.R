library(dplyr)
library(ggplot2)

## make bed files from ped genomic data
makeBed <- 'plink1 --file hapmap1/hapmap1 --make-bed --out alleles'
system(makeBed)
## execute association analysis
association <- 'plink1 --bfile alleles --assoc --out alleles'
system(association)

## reading data
alleles <- read.table("alleles.assoc",
                   header = TRUE,
                   stringsAsFactors = FALSE)

## selecting non NA data about chromosomes, base pairs
## and chi-sqaure test
alleles <- alleles[!is.na(alleles$CHISQ),]
alleles <- select(alleles,SNP,CHR, BP,CHISQ)
#alleles <- filter(alleles, CHR %in% 1:5)


## plotting result
g <- ggplot(data = alleles, aes(BP,CHISQ,colour=as.factor(CHR) ) ) 
g <- g + geom_point()
plot(g)
