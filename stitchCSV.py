#!/usr/bin/env python3

import os
import subprocess
import sys
import pandas as pd

def stitchCSVs(path):
	if (os.path.isdir(path) == False):
        
	    if path.endswith("-Group1of2.csv"):
            file1 = path
            file2 = path[:-14] +"-Group2of2.csv"
            
            # Code from: https://www.freecodecamp.org/news/how-to-combine-multiple-csv-files-with-8-lines-of-code-265183e0854/
            combined_csv = pd.concat([pd.read_csv(file1), pd.read_csv(file2)])
            #export to csv
            combined_csv.to_csv(path[:-14] + ".csv", index=False, encoding='utf-8-sig')

        if path.endswith("Group1of1.csv"):
            os.rename(path, path[:-14])
	else:
		for filename in os.listdir(path):
			stitchCSVs(path + "/" + filename)

stitchCSVs(sys.argv[1])