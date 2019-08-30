#!/usr/bin/env python3

import os
import subprocess

def stitchFiles(inputFile1, inputFile2):
	if inputFile1.endswith("-Group1of2.wav"):
		subprocess.call(["ffmpeg", "-i", inputFile1 , "-i", inputFile2, "-filter_complex","[0:0][1:0]concat=n=2:v=0:a=1[out]", "-map","[out]", inputFile1[:-14]+"Combined.wav"])



#Test for stitchFiles function
#wavFile1="/Users/nehachintamaneni/Documents/Eberly_Center_Data/wavFiles/2019-02-12-TRec5-Group1of2_incVol.wav"
#wavFile2="/Users/nehachintamaneni/Documents/Eberly_Center_Data/wavFiles/2019-02-12-TRec5-Group2of2_incVol.wav"
#stitchFiles(wavFile1, wavFile2)



def findMatchingGroupFiles(wavFileSourceDirectory):
	for file in os.listdir(wavFileSourceDirectory):
		if file.endswith("-Group1of2.wav"):
			filePrefix=file[:-14]
			file2=filePrefix+"-Group2of2.wav"
			if file2 in os.listdir(wavFileSourceDirectory):
				stitchFiles(wavFileSourceDirectory+"/"+file, wavFileSourceDirectory+"/"+file2)


wavDirectory="/Volumes/ICData/Mara_2019-01/wavFiles"
findMatchingGroupFiles(wavDirectory)






