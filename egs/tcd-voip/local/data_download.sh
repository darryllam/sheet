#!/usr/bin/env bash
set -e

# Copyright 2025 Wen-Chin Huang
#  MIT License (https://opensource.org/licenses/MIT)

db=$1

# download dataset
cwd=`pwd`
if [ ! -e ${db}/tcdvoip.done ]; then
    mkdir -p ${db}
    cd ${db}
    gdown 1rHJN34vP-W8SJtjpNUnx5RIks3o5L5he
    unzip TCD-VOIP.zip
    rm TCD-VOIP.zip
    mv TCD-VOIP/* .
    rm -r TCD-VOIP
    cd $cwd
    echo "Successfully finished download."
    touch ${db}/tcdvoip.done
else
    echo "Already exists. Skip download."
fi
