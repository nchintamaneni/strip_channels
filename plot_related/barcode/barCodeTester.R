# Code from: http://samcarcagno.altervista.org/blog/basic-sound-processing-r/?doing_wp_cron=1567537792.2555119991302490234375
# and: https://hansenjohnson.org/post/spectrograms-in-r/ 

args = commandArgs(trailingOnly=TRUE)

# signal processing, image plotting, and manipulate .wav files functions
library(tuneR, warn.conflicts = F, quietly = T) 
library(ggplot2, reshape)
library("cowplot")
library("magick")
theme_set(theme_cowplot())


findMaxDurationBarcode <- function(fileList, verbose=FALSE, showWarnings=TRUE) {
  max <- 0
  for (file in fileList){
    durationList = read.csv(file, header=TRUE)$time
    duration = durationList[length(durationList)]
    print(length(durationList))
    
    if(duration > max){
      max <- duration
    }
  }
  return(max)
}

plotRMS <- function (fileName, maxDur, verbose=FALSE, showWarnings=TRUE) { 
  fileTitle = tail(strsplit(fileName,split="/")[[1]],1)
  fullTable <-read.csv(fileName)
  #timeStamp <-read.csv(fileName)$time
  peaks <-fullTable$Peak.Level
  
  firstQ <-read.csv(fileName)$Peak.Level
  secondQ <-read.csv(fileName)$Peak.Level
  thirdQ <-read.csv(fileName)$Peak.Level
  fourthQ <-read.csv(fileName)$Peak.Level
  
  twentyFive <- -50
  fifty <- -30
  seventyFive <- -20
  print(peaks)
  for (i in 1:(length(peaks))){
    firstQ[[i]] = if (peaks[[i]] < twentyFive) 1 else 0
    secondQ[[i]] = if ((peaks[[i]] >= twentyFive) && (peaks[[i]] < fifty)) 1 else 0
    thirdQ[[i]] = if (peaks[[i]] >= fifty && peaks[[i]] < seventyFive) 1 else 0
    fourthQ[[i]] = if (peaks[[i]] >= seventyFive) 1 else 0
  }
  print(firstQ)
  print(secondQ)
  print(thirdQ)
  print(fourthQ)
  
  timeStampTemp = fullTable$time
  #timeStampTemp = timeStampTemp / 1000
  temp = data.frame(timeStamp = timeStampTemp, firstQuartile=firstQ, secondQuartile=secondQ, thirdQuartile=thirdQ, fourthQuartile=fourthQ)
  dat <- temp
  dat.m <- reshape2::melt(dat, id.vars=c("timeStamp"))
  
  fileTitle = tail(strsplit(fileName,split="/")[[1]],1)
  fileName = substr(fileName, 0, (nchar(fileName)-4))
  #jpeg(paste(fileName, "_quietOrLoud_Shaded.jpg", sep = ""), width=1000, height=300)
  myplot <- ggplot(dat.m, aes(x=timeStamp, y=value, fill=variable)) + 
    geom_bar(stat = "identity") + 
    labs(x = "Time (ms)", y = "Indicator") +
    scale_fill_manual(values = c("#ffffff", "#c0c0c0", "#696969","#0d0d0d")) +
    ggtitle(paste("Source:", substr(fileTitle, 0, (nchar(fileTitle)-4)))) + 
    labs(fill = "Quartile shadings: ") +
    theme_classic() +
    xlim(0, maxDur) +
    theme(plot.title = element_text(size = 15)) +
    theme(legend.position="top")
  ggsave(paste(fileName, "_quietOrLoud_Shaded.jpg", sep = ""),plot=myplot)
  #dev.off();

}



# Collect csvFiles

csvFiles <- files <- list.files(path="/Volumes/ICData/Mara_2019-01/stitchedFiles/incVol_stitched", pattern="*.csv", full.names=TRUE, recursive=TRUE, include.dirs = TRUE)
length(csvFiles)
# Find maxes
maxDurBar <- findMaxDurationBarcode(csvFiles)
print(maxDurBar)
# Make the combined jpegs!
lapply(csvFiles, plotRMS, maxDurBar)



