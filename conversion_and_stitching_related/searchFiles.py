#!/usr/bin/env python3

import os
import subprocess

def listFiles(path):
	if (os.path.isdir(path) == False):
		if path.endswith("-Group1of2.mov") or path.endswith("-Group2of2.mov") or path.endswith("-Group.mov") or path.endswith("-1of2.mov") or path.endswith("-2of2.mov") or path.endswith("-group2of2.mov"):
			mainPathLength=len("/Volumes/S19 Disk 1/Mara")
			subprocess.call(["ffmpeg", "-i", path , "-filter_complex","channelsplit=channel_layout=hexadecagonal:channels=FL[FL]", "-map","[FL]", path[0:mainPathLength+1] + path[mainPathLength+1:mainPathLength+11] + "-"+ path[mainPathLength+18:-4]+".wav"])

	else:
		for filename in os.listdir(path):
			listFiles(path + "/" + filename)

listFiles("/Volumes/S19 Disk 1/Mara")

#wavFileSourceDirectory="/Volumes/S19 Disk 1/Mara/wavFiles"
#for file in os.listdir(wavFileSourceDirectory): 
#	wavFileName = file[:file.rfind(".")]
#	subprocess.call(["ffmpeg", "-i", wavFileSourceDirectory+"/"+wavFileName+".wav", "-#filter:a","volume=20dB", wavFileSourceDirectory+"/"+wavFileName+"_incVol.wav"])

#look through every folder and subfolder and create a list of paths that include "Group..." And end with ".mov" 
#for every file in the list rename each file by subfolder

