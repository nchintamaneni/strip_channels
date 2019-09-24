# Code from: http://samcarcagno.altervista.org/blog/basic-sound-processing-r/?doing_wp_cron=1567537792.2555119991302490234375
# and: https://hansenjohnson.org/post/spectrograms-in-r/ 

args = commandArgs(trailingOnly=TRUE)

# signal processing, image plotting, and manipulate .wav files functions
library(tuneR, warn.conflicts = F, quietly = T) 
library(ggplot2, reshape)
library("cowplot")
library("magick")
theme_set(theme_cowplot())

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
  plot(timeArray, snd, type='l', col='black', main=paste(fileTitle, "- Amplitude Graph"), xlab='Time (s)', ylab='Amplitude', ylim=c(-4000,4000)) 
  dev.off()
  return(paste(filePath, "_Amplitude.jpg", sep = ""))
}



# data <-read.csv("/Users/nehachintamaneni/Downloads/2019-02-19-TRec3Combinedupdated.csv")


plotRMS <- function (fileName, verbose=FALSE, showWarnings=TRUE) { 
  
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
  
  
  #df <- data.frame(time = fullTable$time, 
  #                firstQ=firstQ, secondQ=secondQ, thirdQ=thirdQ, fourthQ=fourthQ)
  
  
  ##normalizedData <- structure(list(Time = fullTable$time, First=firstQ, Second=secondQ, Third=thirdQ, Fourth=fourthQ, .Name=c("Time", "First Quartile", "Second Quartile", "ThirdQuartile", "FourthQuartile"), class="data.frame"))
  
  ##df <- reshape2::melt(normalizedData[,c("Time", "First Quartile", "Second Quartile", "ThirdQuartile", "FourthQuartile")], id.vars = 1)
  # df$value <- as.double(gsub(",","",as.character(df$value)))
  
  timeStampTemp = fullTable$time
  temp = data.frame(timeStamp = timeStampTemp, firstQuartile=firstQ, secondQuartile=secondQ, thirdQuartile=thirdQ, fourthQuartile=fourthQ)
  dat <- temp
  
  
  dat.m <- reshape2::melt(dat, id.vars=c("timeStamp"))
  
  
  fileTitle = tail(strsplit(fileName,split="/")[[1]],1)
  fileName = substr(fileName, 0, (nchar(fileName)-4))
  jpeg(paste(fileName, "_quietOrLoud_Shaded.jpg", sep = ""), width=400, height=500)
  
  ggplot(dat.m, aes(x=timeStamp, y=value, fill=variable)) + 
    geom_bar(stat = "identity") + 
    ggtitle(paste("Source:", fileTitle)) + 
    labs(x = "Time (ms)", y = "Indicator") +
    scale_fill_manual(values = c("#ffffff", "#858585", "#4f4f4f","#0d0d0d")) +
    theme_classic();
  return(paste(fileName, "_quietOrLoud_Shaded.jpg", sep = ""))
}

combinePlots <- function (filePath, fileName, verbose=FALSE, showWarnings=TRUE) { 
  print("hi1")
  amplitudePlotAll(filePath)
  dev.off()
  plotRMS(fileName)
  dev.off()
  p1 <- ggdraw() + draw_image(amplitudePlotAll(filePath), scale = 0.9)
  p2 <- ggdraw() + draw_image(plotRMS(fileName), scale=0.9)
  perfect = plot_grid(p1, p2, ncol = 2, rel_widths = c(3, 1))
  save_plot(paste(filePath, ".combined.jpg", sep = ""), perfect, base_height=6)
}

#audioFiles <- list.files(path="/Users/nehachintamaneni/Documents/Eberly_Center_Data/wavFiles", pattern="*.wav", full.names=TRUE, recursive=TRUE, include.dirs = TRUE)
#csvFiles <- list.files(path="/Users/nehachintamaneni/Documents/Eberly_Center_Data/wavFiles", pattern="*updated.csv", full.names=TRUE, recursive=TRUE, include.dirs = TRUE)
#lapply(audioFiles, combinePlots, csvFiles)
combinePlots("/Users/nehachintamaneni/Documents/Eberly_Center_Data/wavFiles/2019-02-12-TRec5Combined.wav", "/Users/nehachintamaneni/Documents/Eberly_Center_Data/wavFiles/2019-02-12-TRec5Combinedupdated.csv")


