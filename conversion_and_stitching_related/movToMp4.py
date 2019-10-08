#!/usr/bin/env python3

import os
import subprocess
import sys

def movToMp4(path):
	if (os.path.isdir(path) == False):
		if path.endswith(".mov"): # selects .mov files only
			# easy names
			mp4file_silent = "silentMP4.mp4"
			wavfile_temp = "tempwavfile.wav"
			wavfile = "wavfile.wav"

			# convert to silent mp4
			subprocess.call(["ffmpeg", "-i", path , "-c", "copy", "-an", mp4file_silent])

			# convert to temp wav (FL channel)
			subprocess.call(["ffmpeg", "-i", path , "-filter_complex","channelsplit=channel_layout=hexadecagonal:channels=FL[FL]", "-map","[FL]", wavfile_temp])

			# remap temp wav file (FL --> FC channel for mono)
			subprocess.call(["ffmpeg", "-i", wavfile_temp, "-filter_complex", "channelmap=map=FL-FC:channel_layout=mono", wavfile])

			# merge silent mp4 and wav file
			subprocess.call(["ffmpeg", "-i", mp4file_silent, "-i", wavfile, "-c:v", "copy", "-c:a", "aac", "-strict", "experimental", "-map", "0:v:0", "-map", "1:a:0", path[:-4]+".mp4"])

			# clean up files
			os.remove(mp4file_silent)
			os.remove(wavfile_temp)
			os.remove(wavfile)
	else:
		for filename in os.listdir(path):
			movToMp4(path + "/" + filename)

movToMp4(sys.argv[1])