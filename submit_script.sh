#!/bin/bash
#SBATCH -n 4
#SBATCH -p medium
#SBATCH -o output.txt
#SBATCH -e error.txt

module load matlab

#matlab -nodisplay -r "path"

matlab -r "addpath(genpath(fullfile(pwd,'human_dm')));cd('human_dm/clustering/fit psychometric functions');fit_pig_on_server;exit"