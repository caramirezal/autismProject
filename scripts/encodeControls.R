## getting data from encode 

## getting snps evaluated using illumina psycharray
pathReport <- "~/dataBases/GoldenGate_U15_025 AT/FinalReport/U15_025_ID_FinalReport.txt"

## loading into R
freport <- read.csv(file = pathReport,
                    sep = "\t",
                    header = TRUE,
                    skip = 9,
                    stringsAsFactors = FALSE,
                    colClasses = "character")

## extracting snps and writting to file
dataLocalPath <- "~/scripts/autismProject/data/snpsPsycharray.txt"
connexion <-file(dataLocalPath)
writeLines(freport$X,connexion)
close(connexion)
## checking the output
readLines(dataLocalPath,n=5)

## uploading snps to the snp batch query
## provided by NCBI  here:
## https://www.ncbi.nlm.nih.gov/projects/SNP/dbSNP.cgi?list=rsfile
