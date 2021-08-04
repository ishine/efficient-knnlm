#!/bin/bash
#SBATCH --output=slurm_out/slurm-%A_%a.out
#SBATCH --error=slurm_out/slurm-%A_%a.err
#SBATCH --array=3-3%1
#SBATCH --gres=gpu:1
#SBATCH --mem=16g
#SBATCH --cpus-per-task=16
#SBATCH -t 0
##SBATCH --exclude=compute-0-31,compute-0-19,compute-0-15
##SBATCH —nodelist=compute-0-31,compute-0-30

jobid=${SLURM_ARRAY_JOB_ID}
taskid=${SLURM_ARRAY_TASK_ID}

# taskid=4

# declare -a temp_list=(0.1 0.5 1)
# declare -a index_list=("dstore/knn.103225485.pca16.m8.index" \
#     "dstore/knn.103225485.pca32.m16.index" \
#     "dstore/knn.103225485.pca64.m32.index" \
#     "dstore/knn.103225485.pca128.m64.index" \
#     "dstore/knn.103225485.pca512.m64.index" \
#     "dstore/knn.103225485.pca256.index")

# dstore_size=103225485
# dstore_file="dstore/dstore_size103225485_embed1024_fp16"
# index_file=dstore/knn.103225485.pca256.index
# dataset=wikitext-103
# ckpt="knnlm_ckpt/wt103_checkpoint_best.pt"
# split="test"
# temp=${temp_list[$taskid]}

declare -a temp_list=(0.1 0.5 1)
declare -a index_list=("dstore/law/knn.19048862.pca32.m16.index" \
    "dstore/law/knn.19048862.pca64.m32.index" \
    "dstore/law/knn.19048862.pca128.m64.index" \
    "dstore/law/knn.19048862.pca256.m64.index" \
    "dstore/law/knn.19048862.pca512.m64.index")

dstore_size=19068709
dstore_file="dstore/law/dstore_size19068709_embed1536_fp16"
dataset=law
ckpt="wmtnc_lm_ckpt/wmt19.en/model.pt"
split="valid"
temp=${temp_list[$taskid]}

temp=1
index_file=${index_list[$taskid]}

echo "evaluate knnlm with temperature ${temp}, index ${index_file}"

bash knnlm_scripts/utils_cmd/eval_knnlm.sh -n ${dstore_size} -p ${dstore_file} -i ${index_file} -d ${dataset} -c ${ckpt} -e ${temp} -s ${split}

