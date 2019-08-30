#!/usr/bin/env python3

import os
import subprocess

def justSound(path):
	if (os.path.isdir(path) == False):
		if path.endswith(".mov"):
			subprocess.call(["ffmpeg", "-i", path , "-filter_complex","channelsplit=channel_layout=hexadecagonal:channels=FL[FL]", "-map","[FL]", path[-4]+ "convertedVideo.wav"])
	else:
		for filename in os.listdir(path):
			justSound(path + "/" + filename)

justSound("/Users/nehachintamaneni/Documents/Eberly_Center_Data")

def movToMp4(path):
	if (os.path.isdir(path) == False):
		if path.endswith(".mov"):
			subprocess.call(["ffmpeg", "-i", path , path[-4]+ "convertedVideo.wav"])
	else:
		for filename in os.listdir(path):
			movToMp4(path + "/" + filename)

movToMp4("/Users/nehachintamaneni/Documents/Eberly_Center_Data")

def combineAudioAndVideo(path):
	if (os.path.isdir(path) == False):
		if path.endswith(".mov"):
			subprocess.call(["ffmpeg", "-i", path , "-i", path[:-4]+"convertedVideo.wav", "-c:v", "copy", "-c:a" "acc", "-strict", "experimental", "-map", "0:v:0", "-map", "1:a:0",path[:-4]+"compressed.mp4"])
	else:
		for filename in os.listdir(path):
			combineAudioAndVideo(path + "/" + filename)

combineAudioAndVideo("/Users/nehachintamaneni/Documents/Eberly_Center_Data")

