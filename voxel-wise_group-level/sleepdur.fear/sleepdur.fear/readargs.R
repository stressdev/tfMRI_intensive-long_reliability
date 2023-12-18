cmdargs <- c("-m","/ncf/mclaughlin/stressdevlab/stress_pipeline/Group/FaceReactivity/NewNeuropoint/sleepdur.fear/mask.nii.gz",
"--set1", "/ncf/mclaughlin/stressdevlab/stress_pipeline/Group/FaceReactivity/NewNeuropoint/datafiles/setfilenames_fearGTcalm.txt","--setlabels1", "/ncf/mclaughlin/stressdevlab/stress_pipeline/Group/FaceReactivity/NewNeuropoint/datafiles/stress_psych_sleep-midpoint5.csv",
"--model","/ncf/mclaughlin/stressdevlab/stress_pipeline/Group/FaceReactivity/NewNeuropoint/sleepdur.fear/model.R",
"--output","sleepdur.fear/sleepdur.fear.",
debug.Rdata
"--slurmN", "200"
)
