
## idat file loading
#library(illuminaio)
#setwd("dataBases/GoldenGate_U15_025 AT/Resultados/101035450001/")
#files.names <- list.files()
#idat.files <- grep(".idat",files.names,value = TRUE)
#idat <- readIDAT(idat.files[1])

## local directory
pathReport <- "~/dataBases/GoldenGate_U15_025 AT/FinalReport/U15_025_ID_FinalReport.txt"
pathOpa <- "~/dataBases/GoldenGate_U15_025 AT/GenomeStudio/GS0014416-OPA.opa"
pathSampleSheet <- "~/dataBases/GoldenGate_U15_025 AT/GenomeStudio/SampleSheet_ID.csv"



freport <- read.csv(file = pathReport,
            sep = "\t",
            header = TRUE,
            skip = 9,
            stringsAsFactors = FALSE,
            colClasses = "character")

opa <- read.csv(file = pathOpa,
                skip = 12,
                header = TRUE)

sample <- read.csv(file = pathSampleSheet,
         skip = 8,
         header = TRUE)

## display files composition
lapply(list(freport,opa,sample), names)


## keeping only SNP data
for (i in 2:ncol(freport)) {
        freport[,i] <- gsub("\\|.*","",freport[i,2:ncol(freport)])
}

## recording existing SNPs
bag <- c()
for (j in 2:ncol(freport)) {
        for (i in 1:nrow(freport)) {
                if ( ! ( freport[i,j] %in% bag ) ) {
                        bag <- c(bag,freport[i,j])
                }
        }
}
bag <- sort(bag)

## matrix of frequencies definition
frequencies <- matrix(data = 0,
                      nrow = nrow(freport),
                      ncol = length(bag))
colnames(frequencies) <- bag
rownames(frequencies) <- freport[,"X"]
head(frequencies)


## getting frequencies from haplotypes
for (i in 1:nrow(freport)) {
        res <- table(gsub("\\|.*","",freport[i,2:ncol(freport)]))
        frequencies[i,names(res)] <- res
}

frequencies.df <- as.data.frame(frequencies)

chrPosition <- opa[,c("Name","CHR")]
names(chrPosition) <- c("X","CHR")
frequencies.df <- merge(frequencies.df,chrPosition,by="X",all = FALSE)
head(frequencies.df)

library(ggplot2)
library(reshape2)

chrNumber <- 20
n <- as.character(chrNumber)
frequencies.m <- melt(frequencies.df[frequencies.df$CHR==n,])
g <- ggplot(data = frequencies.m, aes(x = X,y = value,fill=variable))
g <- g + scale_color_manual(values=variable)
g <- g + geom_bar(stat="identity",width = 1)
g <- g + theme(axis.line=element_blank(),
               axis.text.x=element_blank(),
               axis.title.x=element_blank(),
               panel.background=element_blank(),
               panel.border=element_blank(),
               panel.grid.major=element_blank(),
               panel.grid.minor=element_blank(),
               plot.background=element_blank())
plot(g)
