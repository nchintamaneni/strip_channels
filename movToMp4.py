#!/usr/bin/env python3

import os
import subprocess
import sys

def movToMp4(path):
	if (os.path.isdir(path) == False):
		if path.endswith(".mov"): # selects .mov files only

			mp4file = path[0:-4] + ".mp4"
			wavfile = path[0:-4] + ".wav"

			# convert to mp4
			subprocess.call(["ffmpeg", "-i", path , "-vcodec", "copy", "-acodec", "copy", path[0:-4]+".mp4"])

			# convert to wav
			subprocess.call(["ffmpeg", "-i", path , "-filter_complex","channelsplit=channel_layout=hexadecagonal:channels=FL[FL]", "-map","[FL]", path[0:-4]+".wav"])


			# merge mp4 and wav
			subprocess.call(["ffmpeg", "-i", mp4file, "-i", wavfile, "-vcodec", "copy", "output.mp4"])

			os.remove(mp4file)
			os.remove(wavfile)
			os.rename("output.mp4", mp4file)

	else:
		for filename in os.listdir(path):
			movToMp4(path + "/" + filename)

movToMp4(sys.argv[1])