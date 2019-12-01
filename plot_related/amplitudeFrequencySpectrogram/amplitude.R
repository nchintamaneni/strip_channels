# Usage: In Rstudio terminal, type command 
# $ Rscript [path/to]amplitude.R "[path/to/folder/of/csv/files]"

# Description:
# This Rscript will plot an amplitude graph given a folder of .wav files.
# The length (ie. the max x value) is determined by the longest .wav in the folder.
# Example image can be found in the `~/plot_related/amplitudeFrequencySpectrogram/exampleImages/` folder.

# Author: Neha chintamaneni and Jiachen (Amy) Liu

# Referenced code from:
# http://samcarcagno.altervista.org/blog/basic-sound-processing-r/?doing_wp_cron=1567537792.2555119991302490234375
# and https://hansenjohnson.org/post/spectrograms-in-r/ 

args = commandArgs(trailingOnly=TRUE)

# signal processing, image plotting, and manipulate .wav files functions
library(tuneR, ggplot2, warn.conflicts = F, quietly = T) 

# This function finds the longest duration given a list of (wav) files.
findMaxDuration <- function(fileList, verbose=FALSE, showWarnings=TRUE) {
  max <- 0
  for (file in fileList){
    sound = readWave(file)
    duration = round(length(sound@left) / sound@samp.rate, 2)
    if(duration > max){ max <- duration }  }
  
  return(max)
}

# This function plots an amplitude graph given a (wav) file. 
# It's x-axis's maximum value is determined by maxDur.
amplitudePlotAll <- function (fileName, maxDur, verbose=FALSE, showWarnings=TRUE) { 
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
  
  # create data frame
  df = data.frame(time = timeArray, sound=snd)
  
  # set up jpeg to save plot in
  jpeg(paste(filePath, "_Amplitude.jpg", sep = ""), width=1000, height=300)
  
  # plot amplitude graph
  myPlot <- ggplot(df, aes(x=time, y=sound)) + 
    geom_line(stat = "identity") + 
    ggtitle(paste("Source:", fileTitle, ".wav")) + 
    labs(x = "Time (s)", y = "Amplitude") +
    theme_classic() +
    xlim(0, maxDur) +
    ylim(-40000,40000)

  print(myPlot)
  dev.off()
}

# Recursively go through a directory's files to find .wav files to plot the amplitude graph on
files <- list.files(path=args[1], pattern="*.wav", full.names=TRUE, recursive=TRUE, include.dirs = TRUE)
maxDur <- as.integer(findMaxDuration(files)+0.5)
lapply(files, amplitudePlotAll, maxDur)