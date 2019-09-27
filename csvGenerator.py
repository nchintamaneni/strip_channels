#!/usr/bin/env python3

import os
import subprocess
import sys
import pandas as pd

def csvGenerator(path):
	if (os.path.isdir(path) == False):
		if path.endswith(".wav"):
			stringCommand="ffprobe -f lavfi -i amovie="+path+",astats=metadata=1:reset=1 -show_entries frame=pkt_pts_time:frame_tags=lavfi.astats.Overall.Peak_level,lavfi.astats.Overall.RMS_peak,lavfi.astats.Overall.Flat_factor,lavfi.astats.Overall.Peak_count,lavfi.astats.Overall.Dynamic_range,lavfi.astats.Overall.RMS_level-of csv=p=0 -print_format csv>"+path[:-4]+".csv"
			subprocess.call(stringCommand, shell=True)

			# Label the csv (from csvLabeller.py)
			df = pd.read_csv(path[:-4]+".csv", header=None)
			df.rename(columns={0: 'frame', 1: 'time', 2: 'Peak Level', 3: 'RMS Peak', 4: 'Flat Factor', 5: 'Peak Count', 6: 'Dynamic Range', 7:'RMS Level'}, inplace=True)
			for i in range(len(df)):
				df.at[i , "frame"]= str(i)
			df.to_csv(path[:-4]+".csv", index=False)
	else:
		for filename in os.listdir(path):
			csvGenerator(path + "/" + filename)

csvGenerator(sys.argv[1])