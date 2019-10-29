Authors: 
Jiachen (Amy) Liu
Neha Chintamaneni


stitchFiles.py 
- Given (the path to) a folder of wav files, combines files with endings *PATTERN_ONE and *PATTERN_TWO into *Combined.wav.
- PATTERN_ONE and PATTERN_TWO are currently set as "-Group1of2_incVol.wav" and "*-Group2of2_incVol.wav"
Usage:
$ python stitchWAVs.py [path/to/folder/of/wav/files]


csvGenerator.py
- Given a folder of .wav files, generates a labelled .csv file for each .wav file in the folder, containing numeric data of:
- 0: 'frame', 1: 'time', 2: 'Peak Level', 3: 'RMS Peak', 4: 'Flat Factor', 5: 'Peak Count', 6: 'Dynamic Range'
Usage: 
Install ffmpeg and download the pandas package
$ python csvGenerator.py [path/to/folder/of/wav/files]

barcode.R
Usage: In Rstudio terminal (or command line if RStudio.exe is added to path), type command 
$ Rscript barcode.R [path/to/folder/of/csv/files]

Description: 
This Rscript will plot a shaded barcode graphs given a folder of csv files.
The length / max x value is determined by the longest csv in the folder. Files shorter than the longest
will have trailing white spaces that's indictive of how much shorter it is than the longest. 
This is a *shaded* barcode graph because it will assign different shade of gray depending on 
what category the dB falls into.
Currently, the categories for this rscript is: -infty ~ -50 ~ -30 ~ -20 ~ + infty 

Notes:
This Rscript assumes there exists a $time column, provided in seconds (s), and a $Peak.Level column in the input csv files. 
Ideally, the input folder of csvs is the result of running csvGenerator.py
