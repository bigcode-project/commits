#!/bin/bash
#SBATCH --job-name=eval
#SBATCH --ntasks=1                   # number of MP tasks
#SBATCH --nodes=1
#SBATCH --cpus-per-task=10           # number of cores per tasks
#SBATCH --hint=nomultithread         # we get physical cores not logical
#SBATCH --time=10:00:00             # maximum execution time (HH:MM:SS)
#SBATCH --output=%x-%j.out          # output file name
#SBATCH --account=ajs@v100
#SBATCH --gres=gpu:1                # number of gpus

source $ajs_ALL_CCFRWORK/start-tr13f-6B3-ml-t0
conda activate bigcode

cd /gpfswork/rech/ajs/commun/code/bigcode/bigcode-evaluation-harness

accelerate launch --config_file config_1a100.yaml main.py \
--model diff-codegen-2b-v2 \
--tasks humaneval-x-bugs-python \
--do_sample False \
--n_samples 1 \
--batch_size 1 \
--allow_code_execution \
--save_generations \
--trust_remote_code \
--mutate_method diff-carper \
--generations_path generations_humanevalxbugspy_codegen2b_greedy.json \
--output_path evaluation_humanevalxbugspy_codegen2b_greedy.json \
--max_length_generation 2048

accelerate launch --config_file config_1a100.yaml main.py \
--model diff-codegen-2b-v2 \
--tasks humaneval-x-bugs-js \
--do_sample False \
--n_samples 1 \
--batch_size 1 \
--allow_code_execution \
--save_generations \
--trust_remote_code \
--mutate_method diff-carper \
--generations_path generations_humanevalxbugsjs_codegen2b_greedy.json \
--output_path evaluation_humanevalxbugsjs_codegen2b_greedy.json \
--generation_only \
--max_length_generation 2048

accelerate launch --config_file config_1a100.yaml main.py \
--model diff-codegen-2b-v2 \
--tasks humaneval-x-bugs-java \
--do_sample False \
--n_samples 1 \
--batch_size 1 \
--allow_code_execution \
--save_generations \
--trust_remote_code \
--mutate_method diff-carper \
--generations_path generations_humanevalxbugsjava_codegen2b_greedy.json \
--output_path evaluation_humanevalxbugsjava_codegen2b_greedy.json \
--generation_only \
--max_length_generation 2048
