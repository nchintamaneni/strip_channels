library("ggplot2")

args = commandArgs(trailingOnly=TRUE)


data <-read.csv("/Users/nehachintamaneni/Downloads/2019-02-19-TRec3Combinedupdated.csv")
ggplot(data, aes(unlist(data$time))) + 
  geom_line(aes(y = unlist(data$Peak.Level), colour = "Peak Level")) + 
  geom_line(aes(y = unlist(data$RMS.Peak), colour = "RMS Peak"))

plotRMS <- function (fileName, verbose=FALSE, showWarnings=TRUE) { 
  data <-read.csv(fileName)
  ggplot(data, aes(time)) + 
    geom_line(aes(y = Peak.level, colour = "var0")) + 
    geom_line(aes(y = RMS.Peak, colour = "var1"))
  
  # determine duration
  dur = length(snd)/data@samp.rate
  
  # determine sample rate
  fs = data@samp.rate
  
  # construct timeArray
  timeArray <- ((0:(length(data)-1))) / data@samp.rate
  # timeArray <- timeArray * 1000 #scale to milliseconds
  
  # plot and store the frequency (by time (ms) and by amplitude)
  filePath = substr(fileName, 0, (nchar(fileName)-4))
  fileTitle = tail(strsplit(filePath,split="/")[[1]],1)
  
  jpeg(paste(filePath, "_Amplitude.jpg", sep = ""))
  plot(timeArray, snd, type='l', col='black', main=paste(fileTitle, "- Amplitude Graph"), xlab='Time (s)', ylab='Amplitude') 
  dev.off()
}

files <- list.files(path=args[1], pattern="*.wav", full.names=TRUE, recursive=TRUE, include.dirs = TRUE)
lapply(files, amplitudePlotAll)