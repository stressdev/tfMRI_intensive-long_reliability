
cmdargs <- c("-m","mask.nii.gz", "--set1", "/mnt/stressdevlab/stress_pipeline/Group/FaceReactivity/NewNeuropoint/datafiles/setfilenames_fearGTcalm.txt",
             "--setlabels1", "/mnt/stressdevlab/stress_pipeline/Group/FaceReactivity/NewNeuropoint/datafiles/stress_psych-midpoint5.csv", 
             "--model", "model.R",
             "--testvoxel", "10000",
             "--output", "time.fear/time.fear.",
             "--debugfile", "debug.Rdata",
             "--slurmN", "60")

