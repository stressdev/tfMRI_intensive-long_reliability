#!/bin/bash

sbatch -c 4 --mem=16G -t 0-01:00:00 --array="${1}" ~/data/containers/sbatch_R_command.bash \
	verse-cmdstan.simg \
	oldicc.R $2
