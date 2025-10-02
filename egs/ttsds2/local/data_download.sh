#!/usr/bin/env bash
set -e

# Copyright 2025 Wen-Chin Huang
#  MIT License (https://opensource.org/licenses/MIT)

db=$1

# download dataset
cwd=`pwd`
if [ ! -e ${db}/ttsds2.done ]; then
    mkdir -p ${db}
    cd ${db}
    wget https://huggingface.co/datasets/urgent-challenge/urgent26_track2_sqa/resolve/main/ttsds2.zip
    unzip ttsds2.zip
    rm -f ttsds2.zip
    cd $cwd
    echo "Successfully finished download."
    touch ${db}/ttsds2.done
else
    echo "Already exists. Skip download."
fi
