#!/usr/bin/env python3

import os
import subprocess

wavFileSourceDirectory="/Users/nehachintamaneni/Documents/Eberly_Center_Data/wavFiles"


for file in os.listdir(wavFileSourceDirectory):
	stringCommand="ffprobe -f lavfi -i amovie="+wavFileSourceDirectory+file+",astats=metadata=1:reset=1 -show_entries frame=pkt_pts_time:frame_tags=lavfi.astats.Overall.RMS_level,lavfi.astats.Overall.DC_offset,lavfi.astats.Overall.Min_level,lavfi.astats.Overall.Max_level,lavfi.astats.Overall.Min_difference,lavfi.astats.Overall.Max_difference,lavfi.astats.Overall.Peak_level,lavfi.astats.Overall.RMS_peak,lavfi.astats.Overall.RMS_trough,lavfi.astats.Overall.Crest_factor,lavfi.astats.Overall.Flat_factor,lavfi.astats.Overall.Peak_count, -of csv=p=0 -print_format csv>"+wavFileSourceDirectory+file[:-4]+".csv"
	subprocess.call(stringCommand, shell=True)





