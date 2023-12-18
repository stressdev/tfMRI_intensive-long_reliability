cmdargs <- c("-m","/ncf/mclaughlin/stressdevlab/stress_pipeline/Group/FaceReactivity/NewNeuropoint/sleepdur.happy/mask.nii.gz",
"--set1", "/ncf/mclaughlin/stressdevlab/stress_pipeline/Group/FaceReactivity/NewNeuropoint/datafiles/setfilenames_happyGTcalm.txt","--setlabels1", "/ncf/mclaughlin/stressdevlab/stress_pipeline/Group/FaceReactivity/NewNeuropoint/datafiles/stress_psych_sleep-midpoint5.csv",
"--model","/ncf/mclaughlin/stressdevlab/stress_pipeline/Group/FaceReactivity/NewNeuropoint/sleepdur.happy/model.R",
"--output","sleepdur.happy/sleepdur.happy.",
debug.Rdata
"--slurmN", "200"
)
