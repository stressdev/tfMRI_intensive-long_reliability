
library(permute)

message('Loading data...')
#This presumes you've arleady set up the target model
load('/mnt/stressdevlab/stress_pipeline/Group/FaceReactivity/NewNeuropoint//eptot.happy/eptot.happy/debug.Rdata')
attach(designmat)
nperm <- 1000 #Make sure this number matches input to NeuroPointillist or is bigger

set.seed(8981)
message('Generating ', nperm, ' permutations...')
ctrl.free <- how(within = Within(type = 'free'), nperm = nperm, blocks = idnum)
perm_set.free <- shuffleSet(n = idnum, control = ctrl.free)
permpath <- file.path('/mnt/stressdevlab/stress_pipeline/Group/FaceReactivity/NewNeuropoint//eptot.happy//perm.free.eptot.happy', 'permute_free.RDS')
message('Saving permutations to ', permpath)
saveRDS(perm_set.free, permpath)
