
library(permute)

message('Loading data...')
#This presumes you've arleady set up the target model
load('/mnt/stressdevlab/stress_pipeline/Group/FaceReactivity/NewNeuropoint//eptot.fear/eptot.fear/debug.Rdata')
attach(designmat)
nperm <- 1000 #Make sure this number matches input to NeuroPointillist or is bigger
v <- 1 #to get example brain data



  BRAIN <- voxeldat[,v]
  model_data <- na.omit(data.frame(
    BRAIN = BRAIN, 
    TIMECENTER = TIMECENTER, 
    GCEN_EPISODICTOT = GCEN_EPISODICTOT, 
    WCEN_EPISODICTOT = WCEN_EPISODICTOT, 
    idnum = idnum))

set.seed(8981)
message('Generating ', nperm, ' permutations...')

ctrl.free <- how(within = Within(type = 'free'), nperm = nperm, blocks = NULL)
perm_set.free <- shuffleSet(n = model_data$idnum, control = ctrl.free)
permpath <- file.path('/mnt/stressdevlab/stress_pipeline/Group/FaceReactivity/NewNeuropoint//eptot.fear//perm.free.bw.eptot.fear', 'permute_free.RDS')
message('Saving permutations to ', permpath)
saveRDS(perm_set.free, permpath)
