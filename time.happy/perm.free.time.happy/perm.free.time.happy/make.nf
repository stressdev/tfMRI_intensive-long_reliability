#!/usr/bin/env nextflow/n
prefix='perm.free.time.happy.'
npermute=1000
model='/ncf/mclaughlin/stressdevlab/stress_pipeline/Group/FaceReactivity/NewNeuropoint/time.happy/perm.free.time.happy/permute_free_model.R'
designmat='perm.free.time.happy.designmat.rds'
//Lines that begin with two slashes are comments.
//If you have any other files that you want to use with your code, define them here.
//For example:
//extra='/path/to/file/my/R/code/needs.rds'


maskFile = Channel.fromPath("${prefix}????.nii.gz")
rdsFile =  Channel.fromPath("${prefix}????.rds")
modelFile =  Channel.fromPath("${model}")
designmatFile =  Channel.fromPath("${designmat}")


//If you have any other files that you want to use with your code, create a channel for them here
//For example:
//extraFile = Channel.fromPath("${extra}")
process npointrun {
  publishDir = "."

input:
	each x from 1..npermute
	file mask from maskFile
	file rds from rdsFile
	file model from modelFile
	file designmat from designmatFile
//And also list any other files here. For example:
//	file extradat from extraFile


output:
	file "${prefix}0001WCEN_TIMECENTER-z_sw.${x}.nii.gz"

"""
npointrun -m ${mask} --model ${model} --permutationfile WCEN_TIMECENTER-z_sw.${x}.nii.gz -d ${designmat}
"""
}
