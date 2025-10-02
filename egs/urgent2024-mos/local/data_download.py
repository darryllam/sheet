#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Copyright 2025 Wen-Chin Huang
#  MIT License (https://opensource.org/licenses/MIT)

from datasets import load_dataset
import soundfile as sf
import os
from tqdm import tqdm
import csv

dataset = load_dataset("urgent-challenge/urgent2024_mos")
metadata = []

os.makedirs("wavs", exist_ok=True)

for line in tqdm(dataset["test"]):
    wav_path = os.path.join("wavs", line["id"] + ".wav")
    if not os.path.exists(wav_path):
        if len(line["audio"]["array"].shape) > 1:
            print(line["audio"]["array"].shape)
            exit()
        sf.write(
            wav_path, line["audio"]["array"], line["audio"]["sampling_rate"]
        )

    sample_id = line["id"]
    system_id = sample_id
    score = float(line["mos"])
    raw_ratings = line["raw_ratings"]
    fs = line["audio"]["sampling_rate"]


    assert os.path.isfile(wav_path), f"{wav_path} does not exist."

    item = {
        "wav_path": wav_path,
        "score": score,
        "raw_ratings" : raw_ratings,
        "system_id": system_id,
        "sample_id": sample_id,
        "sampling_rate": fs,
    }

    metadata.append(item)

# write csv
print("Writing output csv file.")
fieldnames = [
    "wav_path",
    "system_id",
    "sample_id",
    "sampling_rate",
    "score",
    "raw_ratings",
]
with open("metadata.csv", "w", newline="") as csvfile:
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
    writer.writeheader()
    for line in metadata:
        writer.writerow(line)
