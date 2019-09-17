#!/usr/bin/env python3

import os
import subprocess
import sys


ffprobe -v 0 -of csv=p=0 -select_streams v:0 -show_entries stream=r_frame_rate infile

def csvGenerator(path):
	if (os.path.isdir(path) == False):
		if path.endswith(".wav"):
			stringCommand="ffprobe -f lavfi -i amovie="+path+",astats=metadata=1:reset=100 -show_entries frame=pkt_pts_time:frame_tags=lavfi.astats.Overall.max_level, -of csv=p=0 -print_format csv>"+path[:-4]+".csv"
			subprocess.call(stringCommand, shell=True)
	else:
		for filename in os.listdir(path):
			csvGenerator(path + "/" + filename)

csvGenerator(sys.argv[1])