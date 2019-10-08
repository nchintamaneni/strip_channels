#!/usr/bin/env python3

import os
import subprocess
import sys

def changeSampleRate(path,factor):
	sampleRate=48000/factor
	stringCommand="ffmpeg -i "+path+" -ar "+str(sampleRate)+" "+path[:-4]+"_decreasedSampleRate.wav"
	subprocess.call(stringCommand,shell=True)
def csvGenerator(path):
	if (os.path.isdir(path) == False):
		if path.endswith(".wav"):
			stringCommand="ffprobe -f lavfi -i amovie="+path+",astats=metadata=1:reset=1 -show_entries frame=pkt_pts_time:frame_tags=lavfi.astats.Overall.Peak_level,lavfi.astats.Overall.RMS_peak,lavfi.astats.Overall.Flat_factor,lavfi.astats.Overall.Peak_count,lavfi.astats.Overall.Dynamic_range, -of csv=p=0 -print_format csv>"+path[:-4]+".csv"
			subprocess.call(stringCommand, shell=True)
	else:
		for filename in os.listdir(path):
			csvGenerator(path + "/" + filename)
changeSampleRate("/Users/nehachintamaneni/Downloads/2019-02-19-TRec3Combined.wav",100)
csvGenerator("/Users/nehachintamaneni/Downloads/2019-02-19-TRec3Combined_decreasedSampleRate.wav")







