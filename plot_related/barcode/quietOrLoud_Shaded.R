# Usage: In Rstudio terminal (or command line if RStudio.exe is added to path), type command 
# $ Rscript [path/to]quietOrLoud_Shaded.R "[path/to/folder/of/csv/files]"

# Description: 
# This Rscript will plot shaded barcode graphs given a folder of csv files.
# The length / max x value is determined by the longest csv in the folder.
# This is a *shaded* barcode graph because it will assign different shade of gray depending on 
#  what category the dB falls into.
# Currently, the categories for this rscript is: INDIVUDAL FILE'S QUARTILES

# Notes:
# This Rscript assumes there exists a $time column, provided in seconds (s),
# and a $Peak.Level column in the input csv files.

# Author: Jiachen (Amy) Liu

library(ggplot2, reshape)
args = commandArgs(trailingOnly=TRUE)


# This function finds the longest duration given a list of (csv) files derived from .wav files.
findMaxDuration <- function(fileList, verbose=FALSE, showWarnings=TRUE) {
  
  # read the last row code by: 
  # https://stackoverflow.com/questions/18526267/how-to-import-last-100-rows-using-read-csv-in-r
  
  max <- 0
  for (file in fileList){
    durationList = read.csv(file, header=TRUE)$time
    duration = durationList[length(durationList)]
    
    if(duration > max){ max <- duration }  }
  
  return(max)
  
}

# This function plots a barcode given a (csv) file. It's x-axis's maximum value is determined by maxDur.
plotRMS <- function (fileName, maxDur, verbose=FALSE, showWarnings=TRUE) { 
  
  fullTable <-read.csv(fileName)
  
  # set up the vectors that will hold indicators indicating which category a dB belongs to
  peaks <-fullTable$Peak.Level
  firstQ <-read.csv(fileName)$Peak.Level
  secondQ <-read.csv(fileName)$Peak.Level
  thirdQ <-read.csv(fileName)$Peak.Level
  fourthQ <-read.csv(fileName)$Peak.Level
  
  # find categories
  quarts <- quantile(peaks) 
  twentyFive <- quarts[[2]]
  fifty <- quarts[[3]]
  seventyFive <- quarts[[4]]
  oneHundred <- quarts[[5]]
  
  # make and update indicator values
  for (i in 1:(length(peaks))){
    firstQ[[i]] = if (peaks[[i]] < twentyFive) 1 else 0
    secondQ[[i]] = if ((peaks[[i]] >= twentyFive) && (peaks[[i]] < fifty)) 1 else 0
    thirdQ[[i]] = if (peaks[[i]] >= fifty && peaks[[i]] < seventyFive) 1 else 0
    fourthQ[[i]] = if (peaks[[i]] >= seventyFive) 1 else 0 }

  # make data frame for ggplot
  timeStampTemp = fullTable$time
  temp = data.frame(timeStamp = timeStampTemp, firstQuartile=firstQ, secondQuartile=secondQ, thirdQuartile=thirdQ, fourthQuartile=fourthQ)
  dat <- temp
  dat.m <- reshape2::melt(dat, id.vars=c("timeStamp"))
  
  # set up the jpeg to save the plot in
  fileTitle = tail(strsplit(fileName,split="/")[[1]],1)
  fileName = substr(fileName, 0, (nchar(fileName)-4))
  jpeg(paste(fileName, "_quietOrLoud_Shaded.jpg", sep = ""), width=1000, height=300)
  
  # plot barcode
  myplot <- ggplot(dat.m, aes(x=timeStamp, y=value, fill=variable)) + 
    geom_bar(stat = "identity") + 
    ggtitle(paste("Source:", fileTitle)) + 
    labs(x = "Time (s)", y = "Indicator") +
    scale_fill_manual(values = c("#ffffff", "#858585", "#4f4f4f","#0d0d0d")) +
    theme_classic() +
    xlim(0, maxDur)
  
  print(myplot)
  dev.off();

}

# Find all csv files within given folder
files <- list.files(path=args[1], pattern="*.csv", full.names=TRUE, recursive=TRUE, include.dirs = TRUE)

maxDur <- as.integer(findMaxDuration(files)+0.5)
lapply(files, plotRMS, maxDur)