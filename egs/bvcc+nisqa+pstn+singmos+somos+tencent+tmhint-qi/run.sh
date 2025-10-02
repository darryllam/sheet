#!/usr/bin/env bash

# Copyright 2024 Wen-Chin Huang (Nagoya University)
#  MIT License (https://opensource.org/licenses/MIT)

. ./path.sh || exit 1;
. ./cmd.sh || exit 1;

# basic settings
stage=-1       # stage to start
stop_stage=100 # stage to stop
verbose=1      # verbosity level (lower is less info)
n_gpus=1       # number of gpus in training
n_jobs=16      # number of parallel jobs in feature extraction
seed=1337

conf=conf/ssl-mos-wav2vec2.yaml

# dataset configuration
bvcc_db_root=/data/group1/z44476r/Corpora/BVCC/main/DATA
nisqa_db_root=/data/group1/z44476r/Corpora/nisqa/NISQA_Corpus
pstn_db_root=/data/group1/z44476r/Corpora/pstn/pstn_train
db_root=/data/group1/z44476r/Corpora/SingMOS/DATA
somos_db_root=/data/group1/z44476r/Corpora/somos
db_root=/data/group1/z44476r/Corpora/tencent/TencentCorups
tmhintqi_db_root=/data/group1/z44476r/Corpora/tmhint-qi     # change the above 7 directories to your own paths
target_sampling_rate=16000

# training related setting
tag=""     # tag for directory to save model
resume=""  # checkpoint path to resume training
           # (e.g. <path>/<to>/checkpoint-10000steps.pkl)

# pretrained_model_checkpoint=/data/group1/z44476r/Experiments/sheet/egs/nisqa/exp/ssl-mos-wav2vec2-1337/checkpoint-11100steps.pkl  # with MDF
pretrained_model_checkpoint=
datastore_path=

# decoding related setting
test_sets="dev test"
checkpoint=""               # checkpoint path to be used for decoding
                            # if not provided, the latest one will be used
                            # (e.g. <path>/<to>/checkpoint-400000steps.pkl)
model_averaging="False"
use_stacking="False"
meta_model_checkpoint=""
                                       
# shellcheck disable=SC1091
. utils/parse_options.sh || exit 1;

set -euo pipefail

mkdir -p "data"
if [ ${stage} -le 0 ] && [ ${stop_stage} -ge 0 ]; then
    echo "stage 0: Data preparation"

    # parse original csv file to an unified format
    local/data_prep.py \
        --out "data/train.csv" \
        --original-paths \
        "../bvcc/data/bvcc_train.csv" \
        "../nisqa/data/nisqa_train.csv" \
        "../pstn/data/pstn_train.csv" \
        "../singmos/data/singmos_train.csv" \
        "../somos/data/train.csv" \
        "../tencent/data/tencent_train.csv" \
        "../tmhint-qi/data/tmhintqi_train.csv"
    local/data_prep.py \
        --out "data/dev.csv" \
        --original-paths \
        "../bvcc/data/bvcc_dev.csv" \
        "../nisqa/data/nisqa_dev.csv" \
        "../pstn/data/pstn_dev.csv" \
        "../singmos/data/singmos_dev.csv" \
        "../somos/data/dev.csv" \
        "../tencent/data/tencent_dev.csv" \
        "../tmhint-qi/data/tmhintqi_dev.csv"
fi

if [ ${stage} -le 1 ] && [ ${stop_stage} -ge 1 ]; then
    echo "stage 1: Pre-trained model download"

    # SSL-MOS + MDF
    utils/hf_download.py --repo_id "unilight/sheet-models" --outdir "exp/pt_ssl-mos-wav2vec2-mdf-2337" --filename "bvcc+nisqa+pstn+singmos+somos+tencent+tmhint-qi/sslmos+mdf/2337/checkpoint-51000steps.pkl"
    utils/hf_download.py --repo_id "unilight/sheet-models" --outdir "exp/pt_ssl-mos-wav2vec2-mdf-2337" --filename "bvcc+nisqa+pstn+singmos+somos+tencent+tmhint-qi/sslmos+mdf/2337/config.yml"
    mv "exp/pt_ssl-mos-wav2vec2-mdf-2337/bvcc+nisqa+pstn+singmos+somos+tencent+tmhint-qi/sslmos+mdf/2337/checkpoint-51000steps.pkl" "exp/pt_ssl-mos-wav2vec2-mdf-2337/checkpoint-51000steps.pkl"
    mv "exp/pt_ssl-mos-wav2vec2-mdf-2337/bvcc+nisqa+pstn+singmos+somos+tencent+tmhint-qi/sslmos+mdf/2337/config.yml" "exp/pt_ssl-mos-wav2vec2-mdf-2337/config.yml"
    rm -rf "exp/pt_ssl-mos-wav2vec2-mdf-2337/bvcc+nisqa+pstn+singmos+somos+tencent+tmhint-qi"

    utils/hf_download.py --repo_id "unilight/sheet-models" --outdir "exp/pt_ssl-mos-wav2vec2-mdf-3337" --filename "bvcc+nisqa+pstn+singmos+somos+tencent+tmhint-qi/sslmos+mdf/3337/checkpoint-51000steps.pkl"
    utils/hf_download.py --repo_id "unilight/sheet-models" --outdir "exp/pt_ssl-mos-wav2vec2-mdf-3337" --filename "bvcc+nisqa+pstn+singmos+somos+tencent+tmhint-qi/sslmos+mdf/3337/config.yml"
    mv "exp/pt_ssl-mos-wav2vec2-mdf-3337/bvcc+nisqa+pstn+singmos+somos+tencent+tmhint-qi/sslmos+mdf/3337/checkpoint-51000steps.pkl" "exp/pt_ssl-mos-wav2vec2-mdf-3337/checkpoint-51000steps.pkl"
    mv "exp/pt_ssl-mos-wav2vec2-mdf-3337/bvcc+nisqa+pstn+singmos+somos+tencent+tmhint-qi/sslmos+mdf/3337/config.yml" "exp/pt_ssl-mos-wav2vec2-mdf-3337/config.yml"
    rm -rf "exp/pt_ssl-mos-wav2vec2-mdf-3337/bvcc+nisqa+pstn+singmos+somos+tencent+tmhint-qi"

    utils/hf_download.py --repo_id "unilight/sheet-models" --outdir "exp/pt_ssl-mos-wav2vec2-mdf-4337" --filename "bvcc+nisqa+pstn+singmos+somos+tencent+tmhint-qi/sslmos+mdf/4337/checkpoint-51000steps.pkl"
    utils/hf_download.py --repo_id "unilight/sheet-models" --outdir "exp/pt_ssl-mos-wav2vec2-mdf-4337" --filename "bvcc+nisqa+pstn+singmos+somos+tencent+tmhint-qi/sslmos+mdf/4337/config.yml"
    mv "exp/pt_ssl-mos-wav2vec2-mdf-4337/bvcc+nisqa+pstn+singmos+somos+tencent+tmhint-qi/sslmos+mdf/4337/checkpoint-51000steps.pkl" "exp/pt_ssl-mos-wav2vec2-mdf-4337/checkpoint-51000steps.pkl"
    mv "exp/pt_ssl-mos-wav2vec2-mdf-4337/bvcc+nisqa+pstn+singmos+somos+tencent+tmhint-qi/sslmos+mdf/4337/config.yml" "exp/pt_ssl-mos-wav2vec2-mdf-4337/config.yml"
    rm -rf "exp/pt_ssl-mos-wav2vec2-mdf-4337/bvcc+nisqa+pstn+singmos+somos+tencent+tmhint-qi"

    # Modified AlignNet
    utils/hf_download.py --repo_id "unilight/sheet-models" --outdir "exp/pt_alignnet-wav2vec2-2337" --filename "bvcc+nisqa+pstn+singmos+somos+tencent+tmhint-qi/alignnet/2337/checkpoint-86000steps.pkl"
    utils/hf_download.py --repo_id "unilight/sheet-models" --outdir "exp/pt_alignnet-wav2vec2-2337" --filename "bvcc+nisqa+pstn+singmos+somos+tencent+tmhint-qi/alignnet/2337/config.yml"
    utils/hf_download.py --repo_id "unilight/sheet-models" --outdir "exp/pt_alignnet-wav2vec2-2337" --filename "bvcc+nisqa+pstn+singmos+somos+tencent+tmhint-qi/alignnet/2337/datastore/checkpoint-86000steps/datastore.h5"
    mv "exp/pt_alignnet-wav2vec2-2337/bvcc+nisqa+pstn+singmos+somos+tencent+tmhint-qi/alignnet/2337/checkpoint-86000steps.pkl" "exp/pt_alignnet-wav2vec2-2337/checkpoint-86000steps.pkl"
    mv "exp/pt_alignnet-wav2vec2-2337/bvcc+nisqa+pstn+singmos+somos+tencent+tmhint-qi/alignnet/2337/config.yml" "exp/pt_alignnet-wav2vec2-2337/config.yml"
    mv "exp/pt_alignnet-wav2vec2-2337/bvcc+nisqa+pstn+singmos+somos+tencent+tmhint-qi/alignnet/2337/datastore" "exp/pt_alignnet-wav2vec2-2337"

    utils/hf_download.py --repo_id "unilight/sheet-models" --outdir "exp/pt_alignnet-wav2vec2-3337" --filename "bvcc+nisqa+pstn+singmos+somos+tencent+tmhint-qi/alignnet/3337/checkpoint-93000steps.pkl"
    utils/hf_download.py --repo_id "unilight/sheet-models" --outdir "exp/pt_alignnet-wav2vec2-3337" --filename "bvcc+nisqa+pstn+singmos+somos+tencent+tmhint-qi/alignnet/3337/config.yml"
    utils/hf_download.py --repo_id "unilight/sheet-models" --outdir "exp/pt_alignnet-wav2vec2-3337" --filename "bvcc+nisqa+pstn+singmos+somos+tencent+tmhint-qi/alignnet/3337/datastore/checkpoint-93000steps/datastore.h5"
    mv "exp/pt_alignnet-wav2vec2-3337/bvcc+nisqa+pstn+singmos+somos+tencent+tmhint-qi/alignnet/3337/checkpoint-93000steps.pkl" "exp/pt_alignnet-wav2vec2-3337/checkpoint-93000steps.pkl"
    mv "exp/pt_alignnet-wav2vec2-3337/bvcc+nisqa+pstn+singmos+somos+tencent+tmhint-qi/alignnet/3337/config.yml" "exp/pt_alignnet-wav2vec2-3337/config.yml"
    mv "exp/pt_alignnet-wav2vec2-3337/bvcc+nisqa+pstn+singmos+somos+tencent+tmhint-qi/alignnet/3337/datastore" "exp/pt_alignnet-wav2vec2-3337"

    utils/hf_download.py --repo_id "unilight/sheet-models" --outdir "exp/pt_alignnet-wav2vec2-4337" --filename "bvcc+nisqa+pstn+singmos+somos+tencent+tmhint-qi/alignnet/4337/checkpoint-91000steps.pkl"
    utils/hf_download.py --repo_id "unilight/sheet-models" --outdir "exp/pt_alignnet-wav2vec2-4337" --filename "bvcc+nisqa+pstn+singmos+somos+tencent+tmhint-qi/alignnet/4337/config.yml"
    utils/hf_download.py --repo_id "unilight/sheet-models" --outdir "exp/pt_alignnet-wav2vec2-4337" --filename "bvcc+nisqa+pstn+singmos+somos+tencent+tmhint-qi/alignnet/4337/datastore/checkpoint-91000steps/datastore.h5"
    mv "exp/pt_alignnet-wav2vec2-4337/bvcc+nisqa+pstn+singmos+somos+tencent+tmhint-qi/alignnet/4337/checkpoint-91000steps.pkl" "exp/pt_alignnet-wav2vec2-4337/checkpoint-91000steps.pkl"
    mv "exp/pt_alignnet-wav2vec2-4337/bvcc+nisqa+pstn+singmos+somos+tencent+tmhint-qi/alignnet/4337/config.yml" "exp/pt_alignnet-wav2vec2-4337/config.yml"
    mv "exp/pt_alignnet-wav2vec2-4337/bvcc+nisqa+pstn+singmos+somos+tencent+tmhint-qi/alignnet/4337/datastore" "exp/pt_alignnet-wav2vec2-4337"
fi

if [ -z ${tag} ]; then
    expname="$(basename ${conf%.*})-${seed}"
else
    expname="${tag}-${seed}"
fi
expdir=exp/${expname}
if [ "${stage}" -le 2 ] && [ "${stop_stage}" -ge 2 ]; then
    echo "Stage 2: Network training"
    [ ! -e "${expdir}" ] && mkdir -p "${expdir}"
    if [ "${n_gpus}" -gt 1 ]; then
        echo "Not Implemented yet."
        # train="python -m seq2seq_vc.distributed.launch --nproc_per_node ${n_gpus} -c parallel-wavegan-train"
    else
        train="train.py"
    fi
    echo "Training start. See the progress via ${expdir}/train.log."

    if [ ! -z ${pretrained_model_checkpoint} ]; then
        pretrained_model_dir="$(dirname ${pretrained_model_checkpoint})"
        pretrained_model_checkpoint_name=$(basename ${pretrained_model_checkpoint%.*})
        cp -u "${pretrained_model_dir}/config.yml" "${expdir}/original_config.yml"
        cp -u "${pretrained_model_checkpoint}" "${expdir}/original_${pretrained_model_checkpoint_name}.pkl"

        ${cuda_cmd} --gpu "${n_gpus}" "${expdir}/train.log" \
            ${train} \
                --config "${expdir}/original_config.yml" \
                --additional-config "${conf}" \
                --train-csv-path "data/train.csv" \
                --dev-csv-path "data/dev.csv" \
                --init-checkpoint "${expdir}/original_${pretrained_model_checkpoint_name}.pkl" \
                --outdir "${expdir}" \
                --resume "${resume}" \
                --verbose "${verbose}" \
                --seed "${seed}"

    else
        ${cuda_cmd} --gpu "${n_gpus}" "${expdir}/train.log" \
            ${train} \
                --config "${conf}" \
                --train-csv-path "data/train.csv" \
                --dev-csv-path "data/dev.csv" \
                --outdir "${expdir}" \
                --resume "${resume}" \
                --verbose "${verbose}" \
                --seed "${seed}"
    fi
    echo "Successfully finished training."
fi

if [ "${stage}" -le 3 ] && [ "${stop_stage}" -ge 3 ]; then
    echo "Stage 3: Construct datastore"
    # shellcheck disable=SC2012

    if [ -z ${tag} ]; then
        expname="$(basename ${conf%.*})-${seed}"
    else
        expname="${tag}-${seed}"
    fi
    expdir=exp/${expname}

    [ -z "${checkpoint}" ] && checkpoint="${expdir}/checkpoint-best.pkl"
    outdir="${expdir}/datastore/$(basename "${checkpoint}" .pkl)"
    [ ! -e "${outdir}" ] && mkdir -p "${outdir}"
    [ "${n_gpus}" -gt 1 ] && n_gpus=1

    echo "Construction start. See the progress via ${outdir}/construct_datastore.log"
    ${cuda_cmd} --gpu "${n_gpus}" "${outdir}/construct_datastore.log" \
        construct_datastore.py \
            --config "${expdir}/config.yml" \
            --csv-path "data/train.csv" \
            --checkpoint "${checkpoint}" \
            --out "${outdir}/datastore.h5" \
            --verbose "${verbose}"
    echo "Successfully finished datastore construction."
fi

###########################################################################
# Experimental ############################################################
###########################################################################

if [ "${stage}" -le 4 ] && [ "${stop_stage}" -ge 4 ]; then
    echo "Stage 4: Train fusion net of RAMP"

    [ ! -e "${expdir}" ] && mkdir -p "${expdir}"
    echo "Training start. See the progress via ${expdir}/train.log."

    ln -sf "$(realpath $(ls -l ${pretrained_model_checkpoint} | awk '{print $NF}'))" ${pretrained_model_checkpoint}

    pretrained_model_dir="$(dirname ${pretrained_model_checkpoint})"
    pretrained_model_checkpoint_name=$(basename ${pretrained_model_checkpoint%.*})
    # cp -u "${pretrained_model_dir}/config.yml" "${expdir}/original_config.yml" # maybe we don't need config?
    cp -u "${pretrained_model_checkpoint}" "${expdir}/original_${pretrained_model_checkpoint_name}.pkl"
    cp -u "${datastore_path}" "${expdir}/datastore.h5"

    ${cuda_cmd} --gpu "${n_gpus}" "${expdir}/train.log" \
        train_ramp.py \
            --config "${conf}" \
            --train-csv-path "data/train.csv" \
            --dev-csv-path "data/dev.csv" \
            --parametric-model-checkpoint "${expdir}/original_${pretrained_model_checkpoint_name}.pkl" \
            --datastore "${expdir}/datastore.h5" \
            --outdir "${expdir}" \
            --resume "${resume}" \
            --verbose "${verbose}" \
            --seed "${seed}"

    echo "Successfully finished training."
fi

if [ "${stage}" -le 5 ] && [ "${stop_stage}" -ge 5 ]; then
    echo "Stage 5: Inference"
    # shellcheck disable=SC2012

    [ -z "${checkpoint}" ] && checkpoint="${expdir}/checkpoint-best.pkl"
    outdir="${expdir}/results/$(basename "${checkpoint}" .pkl)"

    for name in "dev"; do
        [ ! -e "${outdir}/${name}" ] && mkdir -p "${outdir}/${name}"
        [ "${n_gpus}" -gt 1 ] && n_gpus=1
        echo "Inference start. See the progress via ${outdir}/${name}/inference.log."
        ${cuda_cmd} --gpu "${n_gpus}" "${outdir}/${name}/inference.log" \
            inference.py \
                --config "${expdir}/config.yml" \
                --csv-path "data/${name}.csv" \
                --checkpoint "${checkpoint}" \
                --outdir "${outdir}/${name}" \
                --verbose "${verbose}"
        echo "Successfully finished inference of ${name} set."
        grep "UTT" "${outdir}/${name}/inference.log"
    done
    echo "Successfully finished inference."
fi