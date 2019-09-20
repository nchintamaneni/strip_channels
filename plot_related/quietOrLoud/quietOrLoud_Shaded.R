library(ggplot2, reshape)

args = commandArgs(trailingOnly=TRUE)


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

}

lapply(args[1], plotRMS)