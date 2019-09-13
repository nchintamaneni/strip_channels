#!/usr/bin/env python3

import os
import subprocess
import sys

def csvGenerator(path):
	if (os.path.isdir(path) == False):
		if path.endswith(".wav"):
			stringCommand="ffprobe -f lavfi -i amovie="+path+",astats=metadata=1:reset=1 -show_entries frame=pkt_pts_time:frame_tags=lavfi.astats.Overall.Min_difference,lavfi.astats.Overall.Max_difference,lavfi.astats.Overall.Peak_level,lavfi.astats.Overall.RMS_peak,lavfi.astats.Overall.RMS_trough,lavfi.astats.Overall.Crest_factor,lavfi.astats.Overall.Flat_factor,lavfi.astats.Overall.Peak_count, -of csv=p=0 -print_format csv>"+path[:-4]+".csv"
			subprocess.call(stringCommand, shell=True)
	else:
		for filename in os.listdir(path):
			csvGenerator(path + "/" + filename)

csvGenerator(sys.argv[1])

# wavFileSourceDirectory="/Users/nehachintamaneni/Documents/Eberly_Center_Data/wavFiles"


