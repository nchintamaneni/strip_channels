library("ggplot2")

args = commandArgs(trailingOnly=TRUE)


# data <-read.csv("/Users/nehachintamaneni/Downloads/2019-02-19-TRec3Combinedupdated.csv")


plotRMS <- function (fileName, verbose=FALSE, showWarnings=TRUE) { 
  
  fullTable <-read.csv(fileName)
  peaks <-fullTable$Peak.Level
  normalizedData <-read.csv(fileName)$Peak.Level
  
  quarts <- quantile(peaks, c(0.25)) # cut off. Above 25 percentile = loud
  twentyFive <- quarts[[1]]
  
  for (i in 1:(length(peaks))){
    normalizedData[[i]] = if (peaks[[i]] < twentyFive) 0 else 1
  }
  
  df <- data.frame(time = fullTable$time, normPeak=normalizedData)
  
  fileName = substr(fileName, 0, (nchar(fileName)-4))
  jpeg(paste(fileName, "_quietOrLoud.jpg", sep = ""))
  ggplot(data=df, aes(x=time, y=normPeak)) + geom_bar(stat="identity")
}

lapply(args[1], plotRMS)
