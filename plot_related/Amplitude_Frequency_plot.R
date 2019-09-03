# Code from: http://samcarcagno.altervista.org/blog/basic-sound-processing-r/?doing_wp_cron=1567537792.2555119991302490234375
# and: https://hansenjohnson.org/post/spectrograms-in-r/ 

library(tuneR, warn.conflicts = F, quietly = T) # nice functions for reading and manipulating .wav files
library(signal, warn.conflicts = F, quietly = T) # signal processing functions
library(oce, warn.conflicts = F, quietly = T) # image plotting functions and nice color maps

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
# define path to audio file
fin = 'test.wav'

# read in audio file
data = readWave(fin)

# extract signal
snd = data@left

# construct timeArray
timeArray <- ((0:(length(data)-1))) / data@samp.rate
timeArray <- timeArray * 1000 #scale to milliseconds

jpeg('amplitude_plot.jpg')
# plot by time (ms) by amplitude
plot(timeArray, snd, type='l', col='black', xlab='Time (ms)', ylab='Amplitude') 
dev.off()

## Ploting the frequency
n <- length(snd)
p <- fft(snd) # number of points of the signal n

nUniquePts <- ceiling((n+1)/2)
p <- p[1:nUniquePts] #select just the first half since the second half 
# is a mirror image of the first
p <- abs(p)  #take the absolute value, or the magnitude

p <- p / n #scale by the number of points so that
# the magnitude does not depend on the length 
# of the signal or on its sampling frequency  
p <- p^2  # square it to get the power 

# multiply by two (see technical document for details)
# odd nfft excludes Nyquist point
if (n %% 2 > 0){
  p[2:length(p)] <- p[2:length(p)]*2 # we've got odd number of points fft
} else {
  p[2: (length(p) -1)] <- p[2: (length(p) -1)]*2 # we've got even number of points fft
}

freqArray <- (0:(nUniquePts-1)) * (data@samp.rate / n) #  create the frequency array 

jpeg("frequency_plot.jpg")
plot(freqArray/1000, 10*log10(p), type='l', col='black', xlab='Frequency (kHz)', ylab='Power (dB)')
dev.off()
