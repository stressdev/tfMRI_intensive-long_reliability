
cmdargs <- c("-m","mask.nii.gz", "--set1", "/mnt/stressdevlab/stress_pipeline/Group/FaceReactivity/NewNeuropoint/datafiles/setfilenames_happyGTcalm.txt",
             "--setlabels1", "/mnt/stressdevlab/stress_pipeline/Group/FaceReactivity/NewNeuropoint/datafiles/stress_psych-midpoint5.csv", 
             "--model", "permute_free_model.R",
             "--testvoxel", "10000",
             "--output", "perm.free.panasneg.iv.happy/perm.free.panasneg.iv.happy.",
             "--debugfile", "debug.Rdata",
             "--slurmN", "60",
             "--permute", "1000")

