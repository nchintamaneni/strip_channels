# Usage: 
# In Rstudio terminal (or command line if RStudio.exe is added to path), type command 
# `$ Rscript [path/to]spectrogram.R "[path/to/folder/of/wav/files]"`

# Description:
# This script will plot a spectrogram based on the frequency and amplitude per wav file, given a folder of .wav files. 
# The axis of the graphs are determined per wav file. 
# Example image can be found in the `~/plot_related/amplitudeFrequencySpectrogram/exampleImages/` folder.

# Author:
# spectrogram code referenced from: https://hansenjohnson.org/post/spectrograms-in-r/ 
# applying it to multiple files code from: https://stackoverflow.com/questions/14958516/looping-through-all-files-in-directory-in-r-applying-multiple-commands

args = commandArgs(trailingOnly=TRUE)

## SPECTROGRAM
library(signal, warn.conflicts = F, quietly = T) # signal processing functions
library(oce, warn.conflicts = F, quietly = T) # image plotting functions and nice color maps
library(tuneR, warn.conflicts = F, quietly = T) # nice functions for reading and manipulating .wav files

spectrogramPlotAll <- function(fileName, verbose=FALSE, showWarnings=TRUE) { 
        # define path to audio file
        fin = fileName
        
        # read in audio file
        data = readWave(fin)
        
        # extract signal
        snd = data@left
        
        # determine duration
        dur = length(snd)/data@samp.rate
        dur # seconds
        ## [1] 3.588
        
        # determine sample rate
        fs = data@samp.rate
        fs # Hz
        ## [1] 2000
        # number of points to use for the fft
        nfft=1024
        
        # window size (in points)
        window=256
        
        # overlap (in points)
        overlap=128
        
        # create spectrogram
        spec = specgram(x = snd,
                        n = nfft,
                        Fs = fs,
                        window = window,
                        overlap = overlap
        )
        
        # discard phase information
        P = abs(spec$S)
        
        # normalize
        P = P/max(P)
        
        # convert to dB
        P = 10*log10(P)
        
        # config time axis
        t = spec$t
        
        jpeg(paste(substr(fileName, 0, (nchar(fileName)-4)), "_Spetrogram.jpg", sep = ""))
        # plot spectrogram
        imagep(x = t,
               y = spec$f,
               z = t(P),
               col = oce.colorsViridis,
               ylab = 'Frequency [Hz]',
               xlab = 'Time [s]',
               drawPalette = T,
               decimate = F
        )
        dev.off()
}


files <- list.files(path=args[1], pattern="*.wav", full.names=TRUE, recursive=TRUE, include.dirs = TRUE)
lapply(files, spectrogramPlotAll)
