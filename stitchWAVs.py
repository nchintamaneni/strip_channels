#!/usr/bin/env python3

# Description:
# Given (the path to) a folder of wav files, combines files with endings *PATTERN_ONE and *PATTERN_TWO into *Combined.wav.
# PATTERN_ONE and PATTERN_TWO are currently set as "-Group1of2_incVol.wav" and "*-Group2of2_incVol.wav"
# The script assumes that if a *PATTERN_TWO* appears, *PATTERN_ONE* must also appear (similar to how if there is a group 2 of 2, then there must be a group 1 of 2). 

# Usage:
# $ python stitchWAVs.py [path/to/folder/of/wav/files]

# Author: Neha Chintamaneni

import os
import subprocess
import sys

# Customizable 
PATTERN_ONE = "-Group1of2_incVol.wav"
PATTERN_TWO = "-Group1of2_incVol.wav"

def stichWAVs(inputFile1, inputFile2):
	if inputFile1.endswith(PATTERN_ONE):
		subprocess.call(["ffmpeg", "-i", inputFile1 , "-i", inputFile2, "-filter_complex","[0:0][1:0]concat=n=2:v=0:a=1[out]", "-map","[out]", inputFile1[:-21]+"Combined.wav"])

def findMatchingGroupFiles(wavFileSourceDirectory):
	for file in os.listdir(wavFileSourceDirectory):
		if file.endswith(PATTERN_TWO):
			filePrefix=file[:-21]
			file2=filePrefix+PATTERN_TWO
			if file2 in os.listdir(wavFileSourceDirectory):
				stichWAVs(wavFileSourceDirectory+"/"+file, wavFileSourceDirectory+"/"+file2)

findMatchingGroupFiles(sys.argv[1])
