#!/bin/bash
export PYTHONPATH=$(pwd):${PYTHONPATH} # let LIBERO find the websocket tools from main repo
export star_vla_python=/home/user/miniforge3/envs/starVLA/bin/python
your_ckpt=results/Checkpoints/0216_starvla_qwenpi_253B_calvin_task_D_D/final_model/pytorch_model.pt
gpu_id=0
port=5694
################# star Policy Server ######################

# export DEBUG=true
CUDA_VISIBLE_DEVICES=$gpu_id ${star_vla_python} deployment/model_server/server_policy.py \
    --ckpt_path ${your_ckpt} \
    --port ${port} \
    --use_bf16

# #################################
