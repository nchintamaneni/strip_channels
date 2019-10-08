library("ggplot2")

args = commandArgs(trailingOnly=TRUE)

# data <-read.csv("/Users/nehachintamaneni/Downloads/2019-02-19-TRec3Combinedupdated.csv")

plotRMS <- function (fileName, verbose=FALSE, showWarnings=TRUE) { 
  data <-read.csv(fileName)
  
  filePath = substr(fileName, 0, (nchar(fileName)-4))
  jpeg(paste(filePath, "_RMSDoesNotLookPretty.jpg", sep = ""))
  
  ggplot(data, aes(unlist(data$time))) + 
    geom_line(aes(y = unlist(data$Peak.Level), colour = "Peak Level")) + 
    geom_line(aes(y = unlist(data$RMS.Peak), colour = "RMS Peak"))
  
  dev.off()
}

files <- list.files(path=args[1], pattern="*.csv", full.names=TRUE, recursive=TRUE, include.dirs = TRUE)
lapply(files, plotRMS)