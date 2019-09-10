# Code from: http://samcarcagno.altervista.org/blog/basic-sound-processing-r/?doing_wp_cron=1567537792.2555119991302490234375
# and: https://hansenjohnson.org/post/spectrograms-in-r/ 

args = commandArgs(trailingOnly=TRUE)

# signal processing, image plotting, and manipulate .wav files functions
library(tuneR, warn.conflicts = F, quietly = T) 

amplitudePlotAll <- function (fileName, verbose=FALSE, showWarnings=TRUE) { 
  # define path to audio file
  fin = fileName
  
  # read in audio file
  data = readWave(fin)
  
  # extract signal
  snd = data@left
  
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