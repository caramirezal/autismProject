
## make bed files from ped genomic data
makeBed <- 'plink1 --file PLINK --make-bed --out alleles'
system(makeBed)
## execute association analysis
association <- 'plink1 --bfile alleles --assoc --out alleles'
system(association)

alleles <- read.table("alleles.assoc",
                   header = TRUE,
                   stringsAsFactors = FALSE)

alleles <- alleles[!is.na(alleles$CHISQ),]
tail(alleles)
plot(seq_along(alleles$SNP),alleles$CHISQ)
