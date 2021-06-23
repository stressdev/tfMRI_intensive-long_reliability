cmdargs <- c("-m","/ncf/mclaughlin/stressdevlab/stress_pipeline/Group/FaceReactivity/NewNeuropoint/panasneg.iv.fear/perm.free.panasneg.iv.fear/mask.nii.gz",
"--set1", "/ncf/mclaughlin/stressdevlab/stress_pipeline/Group/FaceReactivity/NewNeuropoint/datafiles/setfilenames_fearGTcalm.txt","--setlabels1", "/ncf/mclaughlin/stressdevlab/stress_pipeline/Group/FaceReactivity/NewNeuropoint/datafiles/stress_psych-midpoint5.csv",
"--model","/ncf/mclaughlin/stressdevlab/stress_pipeline/Group/FaceReactivity/NewNeuropoint/panasneg.iv.fear/perm.free.panasneg.iv.fear/permute_free_model.R",
"--output","perm.free.panasneg.iv.fear/perm.free.panasneg.iv.fear.",
debug.Rdata
"--slurmN", "60"
)
