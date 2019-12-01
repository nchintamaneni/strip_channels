# Usage: 
# In Rstudio terminal (or command line if RStudio.exe is added to path), type command 
# `$ Rscript [path/to]quietOrLoud.R "[path/to/folder/of/wav/files]"`

# Description:
# This was a prototype of the `barcode.R` script where instead of the gray-shaded barcodes, this script is unshaded - either black or white line indicating "quiet" or "loud", defined arbitrarily. 

library("ggplot2")

args = commandArgs(trailingOnly=TRUE)

plotRMS <- function (fileName, verbose=FALSE, showWarnings=TRUE) { 

  # read in data 
  fullTable <-read.csv(fileName)
  peaks <-fullTable$Peak.Level
  normalizedData <-read.csv(fileName)$Peak.Level

  # define demarcation of loud (black line) vs quiet (white line) 
  # note how this is not shaded
  quarts <- quantile(peaks, c(0.25)) # cut off. Above 25 percentile = loud
  twentyFive <- quarts[[1]]
  
  # Go through and classify each data point
  for (i in 1:(length(peaks))){
    normalizedData[[i]] = if (peaks[[i]] < twentyFive) 0 else 1
  }

  # create dataframe to plot 
  df <- data.frame(time = fullTable$time, normPeak=normalizedData)

  # set up file name for saving the jpg 
  fileTitle = tail(strsplit(fileName,split="/")[[1]],1)
  fileName = substr(fileName, 0, (nchar(fileName)-4))

  # plot and save 
  jpeg(paste(fileName, "_quietOrLoud.jpg", sep = ""))
  ggplot(data=df, aes(x=time, y=normPeak)) + ggtitle(paste("Source: ", fileTitle)) + labs(x = "Time (ms)", y = "Indicator") + geom_bar(stat="identity")
}

lapply(args[1], plotRMS)
