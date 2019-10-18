library(ggplot2, reshape)

args = commandArgs(trailingOnly=TRUE)

library("cowplot")
theme_set(theme_cowplot())


findMaxDuration <- function(fileList, verbose=FALSE, showWarnings=TRUE) {
  max <- 0
  for (file in fileList){
    durationList = read.csv(file, header=TRUE)$time
    duration = durationList[length(durationList)-1]
    if(!is.null(duration)){
      if(duration > max){
        max <- duration
      }
    }
  }
  return(max)
}

plotRMS <- function (fileName, maxDur, verbose=FALSE, showWarnings=TRUE) { 
  fullTable <-read.csv(fileName)
  peaks <-fullTable$Peak.Level
  
  silence <-read.csv(fileName)$Peak.Level
  noise <-read.csv(fileName)$Peak.Level
  low <-read.csv(fileName)$Peak.Level
  high <-read.csv(fileName)$Peak.Level
  
  for (i in 1:(length(peaks))){
    silence[[i]] = if (peaks[[i]] < -50) 1 else 0
    noise[[i]] = if ((peaks[[i]] >= -50) && (peaks[[i]] < -30)) 1 else 0
    low[[i]] = if (peaks[[i]] >= -30 && peaks[[i]] < -20) 1 else 0
    high[[i]] = if (peaks[[i]] >= -20) 1 else 0
  }
  
  timeStampTemp = fullTable$time
  temp = data.frame(timeStamp = timeStampTemp, Silence=silence, Noise=noise, LowEnergy=low, HighEnergy=high)
  dat <- temp
  
  dat.m <- reshape2::melt(dat, id.vars=c("timeStamp"))
  
  
  fileTitle = tail(strsplit(fileName,split="/")[[1]],1)
  fileName = substr(fileName, 0, (nchar(fileName)-4))
  
  dur = timeStampTemp[length(timeStampTemp)]
  min = trunc(dur/60)
  sec = trunc(dur - min*60)
  
  durationString = paste(min, "min", sec, "sec")

  myplot <- ggplot(dat.m, aes(x=timeStamp, y=value, fill=variable)) + 
    geom_bar(stat = "identity") + 
    ggtitle(paste("Source:", fileTitle, "//", durationString)) + 
    labs(x = "Time (s)", y = "Indicator") +
    scale_fill_manual(values = c("#ffffff", "#DCDCDC", "#888888","#0d0d0d")) +
    theme_classic() +
    labs(fill = "Category: ") +
    xlim(0, maxDur) +
    theme(legend.position="top")
  
  return(myplot)
}


combinePlots <- function(fileName, maxDurBar, verbose=FALSE, showWarnings=TRUE){
  barcode <- plotRMS(fileName, maxDurBar)
  perfect = plot_grid(barcode, nrow = 1, align = 'v', axis = 'l')
  
  save_plot(paste(fileName, "_quietOrLoud_Shaded.jpg", sep = ""), perfect, base_height=3, base_width=10)
}


# Collect csvFiles
files <- list.files(path=args[1], pattern="*.csv", full.names=TRUE, recursive=TRUE, include.dirs = TRUE)

maxDurBar <- findMaxDuration(files)

lapply(files, combinePlots, maxDurBar)
