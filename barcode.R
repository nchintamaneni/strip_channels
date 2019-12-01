# Usage: In Rstudio terminal (or command line if RStudio.exe is added to path), type command 
# $ Rscript barcode.R [path/to/folder/of/csv/files]

# Description: 
# This Rscript will plot a shaded barcode graphs given a folder of csv files.
# The length / max x value is determined by the longest csv in the folder. Files shorter than the longest
# will have trailing white spaces that's indictive of how much shorter it is than the longest. 
# This is a *shaded* barcode graph because it will assign different shade of gray depending on 
#  what category the dB falls into.
# Currently, the categories for this rscript is: -infty ~ -50 ~ -30 ~ -20 ~ + infty 

# Notes:
# This Rscript assumes there exists a $time column, provided in seconds (s), and a $Peak.Level column in the input csv files. 
# Ideally, the input folder of csvs is the result of running csvGenerator.py

# Author: Jiachen (Amy) Liu


# libraries for plotting
library(ggplot2, reshape)
library("cowplot")

theme_set(theme_cowplot())

args = commandArgs(trailingOnly=TRUE)

findMaxDuration <- function(fileList, verbose=FALSE, showWarnings=TRUE) {
  max <- 0
  
  # For-loop to find the file with the longest duration. 
  # Ignores any null/broken/corrupted files
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
  
  # Categorize each data point into the 4 category. value = 1 if it's in that category. 
  # value = 0 otherwise. 
  for (i in 1:(length(peaks))){
    silence[[i]] = if (peaks[[i]] < -50) 1 else 0
    noise[[i]] = if ((peaks[[i]] >= -50) && (peaks[[i]] < -30)) 1 else 0
    low[[i]] = if (peaks[[i]] >= -30 && peaks[[i]] < -20) 1 else 0
    high[[i]] = if (peaks[[i]] >= -20) 1 else 0
  }
  
  timeStampTemp = fullTable$time

  # make data frame
  temp = data.frame(timeStamp = timeStampTemp, Silence=silence, Noise=noise, LowEnergy=low, HighEnergy=high)
  dat <- temp
  dat.m <- reshape2::melt(dat, id.vars=c("timeStamp"))
  

  # Set up file title & duration-indicating string 
  fileTitle = tail(strsplit(fileName,split="/")[[1]],1)
  fileName = substr(fileName, 0, (nchar(fileName)-4))
  dur = timeStampTemp[length(timeStampTemp)]
  min = trunc(dur/60)
  sec = trunc(dur - min*60)
  durationString = paste(min, "min", sec, "sec")

  # plot the graph with appropriate titles and aesthetic customization
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

barcode <- function(fileName, maxDurBar, verbose=FALSE, showWarnings=TRUE){
  barcode <- plotRMS(fileName, maxDurBar)
  perfect = plot_grid(barcode, nrow = 1, align = 'v', axis = 'l') # alignment

  # outputs the plot ggplot into a jpg. 
  # Change the `base_height` and `base_width` to change proportions of the graph.  
  save_plot(paste(fileName, "_barcode_graph.jpg", sep = ""), perfect, base_height=3, base_width=10)
}

# Collect csvFiles
files <- list.files(path=args[1], pattern="*.csv", full.names=TRUE, recursive=TRUE, include.dirs = TRUE)

# Find maximum duration to set a standard width across all graphs
maxDurBar <- findMaxDuration(files)

# draw the barcode graph
lapply(files, barcode, maxDurBar)
