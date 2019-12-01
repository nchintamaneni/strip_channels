# Useful scripts
## stitchFiles.py 
### Description:
- Given (the path to) a folder of wav files, combines files with endings \*PATTERN_ONE and \*PATTERN_TWO into \*Combined.wav.
- *PATTERN_ONE* and *PATTERN_TWO* are currently set as "-Group1of2_incVol.wav" and "-Group2of2_incVol.wav" respectively.
- The script assumes that if a *PATTERN_TWO* appears, *PATTERN_ONE* must also appear (similar to how if there is a group 2 of 2, then there must be a group 1 of 2). 
### Usage:
`$ python stitchWAVs.py [path/to/folder/of/wav/files]`


## csvGenerator.py
### Description:
- Given a folder of .wav files, generates a labelled .csv file for each .wav file in the folder, containing numeric data of:
0. frame
1. time
2. Peak Level
3. RMS Peak
4. Flat Factor
5. Peak Count
6. Dynamic Range
### Usage: 
1. Install ffmpeg and download the pandas package
2. `$ python csvGenerator.py [path/to/folder/of/wav/files]`

## barcode.R
### Description: 
This Rscript will plot a shaded barcode graphs given a folder of csv files.
The length / max x value is determined by the longest csv in the folder. Files shorter than the longest
will have trailing white spaces that's indictive of how much shorter it is than the longest. 
This is a **shaded** barcode graph because it will assign different shade of gray depending on 
what category the dB falls into.
Currently, the categories for this rscript is: -infty ~ -50 ~ -30 ~ -20 ~ + infty 

Example images of the barcode graph can be found in `~/plot_related/barcode/exampleImages`. There are different "styles" of graphs, which is achieved by simply adjusting the width and height of the graph at the `save_plot` command (around line 98). 

There is an older version of this script, a version of which it is unshaded. Please refer to the "Other, less-useful old/partial script" section's for the `quietOrLoud.R` script. 

### Usage: 
In Rstudio terminal (or command line if RStudio.exe is added to path), type command 
`$ Rscript barcode.R [path/to/folder/of/csv/files]`

### Extra Notes/Assumptions:
This Rscript assumes there exists a *$time* column, provided in seconds (s), and a *$Peak.Level* column in the input csv files. 
Ideally, the input folder of csvs is the result of running `csvGenerator.py`

# Useful Old / partial scripts
## CombinePlots.R
Can be found in `~/combinePlot_related/`

### Description:
This script will take in a folder of .wav and .csv files and directly out an amplitude-barcode stitched graph per .wav/.csv file. It's essentially combining `amplitude.R` and `barcode.R` together and outputs the amplitude graph and bar code graph side by side for easy comparison. Note that this script assumes that the corresponding .csv files have already been generated (the user should use the `csvGenerator.py` script, see above.) 

An example output of the amplitude-barcode stitched graph can be found in the same folder, titled `combinePlots_result.jpg`

### Usage:
(For usage of `csvGenerator.py`, see above)
In Rstudio terminal (or command line if RStudio.exe is added to path), type command 
`$ Rscript CombinePlots.R [path/to/folder/of/csvANDwav/files]`

## amplitude.R
Can be found in `~/plot_related/amplitudeFrequencySpectrogram/`. 

### Description:
This Rscript will plot an amplitude graph given a folder of .wav files.
The length (ie. the max x value) is determined by the longest .wav in the folder.
Example image can be found in the `~/plot_related/amplitudeFrequencySpectrogram/exampleImages/` folder.

### Usage: 
In Rstudio terminal (or command line if RStudio.exe is added to path), type command 
`$ Rscript [path/to]amplitude.R "[path/to/folder/of/wav/files]"`

## Amplitude_Frequency_plot.R
Can be found in `~/plot_related/amplitudeFrequencySpectrogram/`. 

### Description:
This Rscript will plot both the amplitude and the frequency plot of a wav (as 2 separate jpgs) graph given a folder of .wav files. This is essentially `amplitude.R` but with an added bonus of also getting a frequency plot. 
The axis of the graphs are determined per wav file. 
Example image can be found in the `~/plot_related/amplitudeFrequencySpectrogram/exampleImages/` folder.

### Usage: 
In Rstudio terminal (or command line if RStudio.exe is added to path), type command 
`$ Rscript [path/to]Amplitude_Frequency_plot.R "[path/to/folder/of/wav/files]"`

## spectrogram.R
Can be found in `~/plot_related/amplitudeFrequencySpectrogram/`. 

### Description:
This script will plot a spectrogram based on the frequency and amplitude per wav file, given a folder of .wav files. 
The axis of the graphs are determined per wav file. 
Example image can be found in the `~/plot_related/amplitudeFrequencySpectrogram/exampleImages/` folder.

### Usage: 
In Rstudio terminal (or command line if RStudio.exe is added to path), type command 
`$ Rscript [path/to]spectrogram.R "[path/to/folder/of/wav/files]"`

# Other, less-useful old/partial scripts

## Unshaded barcode generator: `quietOrLoud.R`
Can be found under `~/plot_related/barcode/`. 

### Description:
This was a prototype of the `barcode.R` script where instead of the gray-shaded barcodes, this script is unshaded - either black or white line indicating "quiet" or "loud", defined arbitrarily. 

### Usage: 
In Rstudio terminal (or command line if RStudio.exe is added to path), type command 
`$ Rscript [path/to]quietOrLoud.R "[path/to/folder/of/wav/files]"`

## Python scripts within the `converstion_and_stitching` related foler
### `CSV_related` folder
Contains 2 scripts that essentially makes up the `csvGenerator.py`script. The `csvGeneratorWithoutLabels_DEPRACATED` script tries to reduce the sample rate (no longer necessary) and generates a csv of a bunch of astats without labels. The `csvLabeller.py` then takes the unlabelled stats and adds a label column at the top. 

### All other scripts
All other python scripts within this folder is authored by Neha.

# Test files
There is a 12-sec Youtube video of the beach available in 4 formats in the `~/test_files/` folder.
1. test.wav (the standard .wav file)
2. test.mov (.mov video format)
3. test.mp4 (.mp4 video format)
4. test.csv (.csv file as the result of running `csvGenerator.py` on the .wav file)

# Common problems
1. If ffmpeg says it doesn't recognize the input file, referencing something `amovie` related, make sure your path to your wav file doesn't start with a `.` and that the path is consisted of `/` (instead of `\`).

## Authors
* Jiachen (Amy) Liu
* Neha Chintamaneni

