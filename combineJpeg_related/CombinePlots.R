# Code from: http://samcarcagno.altervista.org/blog/basic-sound-processing-r/?doing_wp_cron=1567537792.2555119991302490234375
# and: https://hansenjohnson.org/post/spectrograms-in-r/ 

args = commandArgs(trailingOnly=TRUE)

# signal processing, image plotting, and manipulate .wav files functions
library(tuneR, warn.conflicts = F, quietly = T) 
library(ggplot2, reshape)
library("cowplot")
library("magick")
theme_set(theme_cowplot())


findMaxDurationAmplitude <- function(fileList, verbose=FALSE, showWarnings=TRUE) {
  max <- 0
  for (file in fileList){
    sound = readWave(file)
    duration = round(length(sound@left) / sound@samp.rate, 2)
    if(duration > max){
      max <- duration
    }
  }
  return(max)
  
}

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
  
  df = data.frame(time = timeArray, sound=snd)
  
  #jpeg(paste(filePath, "_Amplitude.jpg", sep = ""), width=1000, height=300)
  
  sec = trunc(dur)
  min = trunc(dur/60)
  durationString = paste(min, "min", sec, "sec")
  
  myPlot <- ggplot(df, aes(x=time, y=sound)) + 
    geom_line(stat = "identity") + 
    ggtitle(paste("Source:", fileTitle, "//", durationString)) + 
    labs(x = "Time (s)", y = "Amplitude") +
    theme_classic() +
    theme(plot.title = element_text(size = 20)) +
    xlim(0, maxDur) +
    ylim(-40000,40000)
  
  # plot(timeArray, snd, type='l', col='black', main=paste(fileTitle, "- Amplitude Graph"), xlab='Time (s)', ylab='Amplitude', xlim = c(0, maxDur), ylim=c(-40000,40000)) 
  return(myPlot)
}

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
  
  fullTable <-read.csv(fileName)
  #timeStamp <-read.csv(fileName)$time
  peaks <-fullTable$Peak.Level
  
  firstQ <-read.csv(fileName)$Peak.Level
  secondQ <-read.csv(fileName)$Peak.Level
  thirdQ <-read.csv(fileName)$Peak.Level
  fourthQ <-read.csv(fileName)$Peak.Level
  
  quarts <- quantile(peaks) 
  twentyFive <- quarts[[2]]
  fifty <- quarts[[3]]
  seventyFive <- quarts[[4]]
  oneHundred <- quarts[[5]]
  
  for (i in 1:(length(peaks))){
    firstQ[[i]] = if (peaks[[i]] < twentyFive) 1 else 0
    secondQ[[i]] = if ((peaks[[i]] >= twentyFive) && (peaks[[i]] < fifty)) 1 else 0
    thirdQ[[i]] = if (peaks[[i]] >= fifty && peaks[[i]] < seventyFive) 1 else 0
    fourthQ[[i]] = if (peaks[[i]] >= seventyFive) 1 else 0
  }
  
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
    scale_fill_manual(values = c("#ffffff", "#858585", "#4f4f4f","#0d0d0d")) +
    labs(fill = "Quartile shadings: ") +
    theme_classic() +
    xlim(0, maxDur) +
    theme(legend.position="top")
  
  return(myplot)
  #print(myplot)
  #dev.off();
  
  #return(paste(fileName, "_quietOrLoud_Shaded.jpg", sep = ""))
}

combinePlots <- function(fileName, maxDurAmp, maxDurBar, verbose=FALSE, showWarnings=TRUE){
  fileName <- substr(fileName, 0, (nchar(fileName)-4))
  amplitude <- amplitudePlotAll(paste(fileName, ".wav", sep=""), maxDurAmp)
  barcode <- plotRMS(paste(fileName, ".csv", sep=""), maxDurBar)
  
  #p1 <- ggdraw() + draw_image(amplitude, scale = 0.9)
  #p2 <- ggdraw() + draw_image(barcode, scale=0.9)
  perfect = plot_grid(amplitude, barcode,
                      nrow = 2, align = 'v', axis = 'l')
  
  save_plot(paste(fileName, "_combined.jpg", sep = ""), perfect, base_height=6)
}

# Collect audioFiles
audioFiles <- files <- list.files(path=args[1], pattern="*.wav", full.names=TRUE, recursive=TRUE, include.dirs = TRUE)

# Collect csvFiles
csvFiles <- files <- list.files(path=args[1], pattern="*.csv", full.names=TRUE, recursive=TRUE, include.dirs = TRUE)

# Find maxes
maxDurAmp <- findMaxDurationAmplitude(audioFiles)
maxDurBar <- findMaxDurationBarcode(csvFiles)

# Make the combined jpegs!
lapply(audioFiles, combinePlots, maxDurAmp, maxDurBar)


