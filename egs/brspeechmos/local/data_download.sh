#!/usr/bin/env bash
set -e

# Copyright 2025 Wen-Chin Huang
#  MIT License (https://opensource.org/licenses/MIT)

db=$1

# download dataset
cwd=`pwd`
if [ ! -e ${db}/brspeechmos.done ]; then
    mkdir -p ${db}
    cd ${db}
    gdown 1_nSqIzFzvDdmIaJB6uxjhJ20pnZJA7ru
    tar -xjvf BRSPEECH_MOS_DATASET_v2.tar.bz
    rm BRSPEECH_MOS_DATASET_v2.tar.bz
    mv BRSPEECH_MOS_DATASET_v2/* .
    rm -r BRSPEECH_MOS_DATASET_v2/
    cd $cwd
    echo "Successfully finished download."
    touch ${db}/brspeechmos.done
else
    echo "Already exists. Skip download."
fi
