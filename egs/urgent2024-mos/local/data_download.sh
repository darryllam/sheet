#!/usr/bin/env bash
set -e

# Copyright 2025 Wen-Chin Huang
#  MIT License (https://opensource.org/licenses/MIT)

db=$1

# download dataset
cwd=`pwd`
if [ ! -e ${db}/urgent2024-mos.done ]; then
    mkdir -p ${db}
    cd ${db}
    ../local/data_download.py
    cd $cwd
    echo "Successfully finished download."
    touch ${db}/urgent2024-mos.done
else
    echo "Already exists. Skip download."
fi
