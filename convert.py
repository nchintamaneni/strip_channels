#!/usr/bin/env python3

import os
import subprocess

#replace path in sourceDirectory and wavFileDirectory variables to start

sourceDirectory = "/Users/nehachintamaneni/Documents/Eberly_Center_Data"
wavFileSourceDirectory= "/Users/nehachintamaneni/Documents/Eberly_Center_Data/wav_files"

#runs through every file in specified directory and converts .mov files into .wav files and strips the unnecessary channels (now 1 channel rather than 16 channels)


for file in os.listdir(sourceDirectory): 
    fileName = file[:file.rfind(".")]
    subprocess.call(["ffmpeg", "-i", sourceDirectory+"/"+fileName+".mov", "-filter_complex","channelsplit=channel_layout=hexadecagonal:channels=FL[FL]", "-map","[FL]",wavFileSourceDirectory+"/"+fileName+"FL.wav"])

#runs through every file in specified directory that wav files were saved and amplifies the sound in each file by 20dB and saves as a new file

for file in os.listdir(wavFileSourceDirectory): 
    wavFileName = file[:file.rfind(".")]
    subprocess.call(["ffmpeg", "-i", wavFileSourceDirectory+"/"+wavFileName+".wav", "-filter:a","volume=20dB", wavFileSourceDirectory+"/"+wavFileName+"_incVol.wav"])