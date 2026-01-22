#!/bin/bash

cd /home/user/hyn/starVLA
source ~/miniconda3/etc/profile.d/conda.sh
conda activate libero310

# 1. 尝试添加常见的 NVIDIA 库路径
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/nvidia
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/x86_64-linux-gnu

# 2. 重新设置 EGL 变量
export MUJOCO_GL=egl
export PYOPENGL_PLATFORM=egl

###########################################################################################
# === Please modify the following paths according to your environment ===
export LIBERO_HOME=/home/user/hyn/starVLA/third_party/LIBERO
export LIBERO_CONFIG_PATH=${LIBERO_HOME}/libero
export LIBERO_Python=/home/user/miniconda3/envs/libero310/bin/python

export PYTHONPATH=$PYTHONPATH:${LIBERO_HOME} # let eval_libero find the LIBERO tools
export PYTHONPATH=$(pwd):${PYTHONPATH} # let LIBERO find the websocket tools from main repo


host="127.0.0.1"
base_port=5694
unnorm_key="franka"
your_ckpt=./results/Checkpoints/Qwen3-VL-PI-LIBERO-4in1/checkpoints/steps_100000_pytorch_model.pt
export DEBUG=false

folder_name=$(echo "$your_ckpt" | awk -F'/' '{print $(NF-2)"_"$(NF-1)"_"$NF}')
# === End of environment variable configuration ===
###########################################################################################

LOG_DIR="logs/$(date +"%Y%m%d_%H%M%S")"
mkdir -p ${LOG_DIR}


num_trials_per_task=50
task_suites=(libero_goal libero_spatial libero_object libero_10)

for task_suite_name in "${task_suites[@]}"; do
    video_out_path="results/${task_suite_name}/${folder_name}"
    log_file="${LOG_DIR}/${task_suite_name}.log"

    PYTHONUNBUFFERED=1 ${LIBERO_Python} -u ./examples/LIBERO/eval_files/eval_libero.py \
        --args.pretrained-path ${your_ckpt} \
        --args.host "$host" \
        --args.port $base_port \
        --args.task-suite-name "$task_suite_name" \
        --args.num-trials-per-task "$num_trials_per_task" \
        --args.video-out-path "$video_out_path" \
        2>&1 | tee "${log_file}"
done
