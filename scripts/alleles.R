library(dplyr)
library(ggplot2)

## make bed files from ped genomic data
#makeBed <- 'plink1 --file PLINK --make-bed --out alleles'
#system(makeBed)
## execute association analysis
#association <- 'plink1 --bfile alleles --assoc --out alleles'
#system(association)

alleles <- read.table("alleles.assoc",
                   header = TRUE,
                   stringsAsFactors = FALSE)


select <- select(alleles,CHR,BP,CHISQ)
alleles <- filter(alleles,!is.na(CHISQ))
alleles <- filter(alleles, CHR %in% 1:5)

g <- ggplot(alleles,aes(BP,CHISQ))
g <- g + geom_point(aes(colour=factor(CHR)))
g <- g + theme_classic()
plot(g)
