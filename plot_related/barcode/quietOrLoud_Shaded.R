library(ggplot2, reshape)

args = commandArgs(trailingOnly=TRUE)


# data <-read.csv("/Users/nehachintamaneni/Downloads/2019-02-19-TRec3Combinedupdated.csv")

findMaxDuration <- function(fileList, verbose=FALSE, showWarnings=TRUE) {
  
  # read the last row code by: https://stackoverflow.com/questions/18526267/how-to-import-last-100-rows-using-read-csv-in-r
  
  max <- 0
  for (file in fileList){
    #l2keep <- 1
    #nL <- system.time(nrow(data.table::fread(file, select = 1L)))
    #df <- read.csv(file, header=FALSE, skip=nL-l2keep)
    
    durationList = read.csv(file, header=TRUE)$time
    duration = durationList[length(durationList)]
    
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
  temp = data.frame(timeStamp = timeStampTemp, firstQuartile=firstQ, secondQuartile=secondQ, thirdQuartile=thirdQ, fourthQuartile=fourthQ)
  dat <- temp
  
  
  dat.m <- reshape2::melt(dat, id.vars=c("timeStamp"))
  
  
  fileTitle = tail(strsplit(fileName,split="/")[[1]],1)
  fileName = substr(fileName, 0, (nchar(fileName)-4))
  jpeg(paste(fileName, "_quietOrLoud_Shaded.jpg", sep = ""), width=1000, height=300)
  myplot <- ggplot(dat.m, aes(x=timeStamp, y=value, fill=variable)) + 
    geom_bar(stat = "identity") + 
    ggtitle(paste("Source:", fileTitle)) + 
    labs(x = "Time (ms)", y = "Indicator") +
    scale_fill_manual(values = c("#ffffff", "#858585", "#4f4f4f","#0d0d0d")) +
    theme_classic() +
    xlim(0, maxDur)
  
  print(myplot)
  dev.off();

}

files <- list.files(path=args[1], pattern="*.csv", full.names=TRUE, recursive=TRUE, include.dirs = TRUE)
maxDur <- as.integer(findMaxDuration(files)+0.5)
print(maxDur)

lapply(files, plotRMS, maxDur)