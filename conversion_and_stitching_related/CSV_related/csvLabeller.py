#!/usr/bin/env python3

import os
import subprocess
import sys
import pandas as pd

def csvLabeller(path):
	if (os.path.isdir(path) == False):
		if path.endswith(".csv"):
			df = pd.read_csv(path, header=None)
			df.rename(columns={0: 'frame', 1: 'time', 2: 'Peak Level', 3: 'RMS Peak', 4: 'Flat Factor', 5: 'Peak Count', 6: 'Dynamic Range'
}, inplace=True)
			for i in range(len(df)):
				df.at[i , "frame"]= str(i)
			df.to_csv(path[:-4]+"updated.csv", index=False)
						
	else:
		for filename in os.listdir(path):
			csvLabeller(path + "/" + filename)
csvLabeller("/Users/nehachintamaneni/Downloads/2019-02-19-TRec3Combined_decreasedSampleRate.csv")