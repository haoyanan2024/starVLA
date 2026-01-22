#!/bin/bash
export PYTHONPATH=$(pwd):${PYTHONPATH} # let LIBERO find the websocket tools from main repo
export star_vla_python=/home/user/miniconda3/envs/starVLA/bin/python
your_ckpt=results/Checkpoints/Qwen3-VL-PI-LIBERO-4in1/checkpoints/steps_100000_pytorch_model.pt
gpu_id=2
port=5694
################# star Policy Server ######################

# export DEBUG=true
CUDA_VISIBLE_DEVICES=$gpu_id ${star_vla_python} deployment/model_server/server_policy.py \
    --ckpt_path ${your_ckpt} \
    --port ${port} \
    --use_bf16

# #################################
