
packages <- list('nlme', 'clubSandwich', 'reghelper')
loaded <- lapply(packages, library, character.only = TRUE)

processVoxel <- function(v) {

  permutationRDS = 'permute_free.RDS'
  targetDV = 'WCEN_EPISODICTOT'
  formula = BRAIN ~ 1 + TIMECENTER + GCEN_EPISODICTOT + WCEN_EPISODICTOT

  BRAIN <- voxeldat[,v]
  NOVAL <- 999
  retvals <- numeric()
  model_data <- data.frame(
    BRAIN = BRAIN, 
    TIMECENTER = TIMECENTER, 
    GCEN_EPISODICTOT = GCEN_EPISODICTOT, 
    WCEN_EPISODICTOT = WCEN_EPISODICTOT, 
    idnum = idnum)

  if(v%%5e3 == 0){
    apercent <- sprintf("%3.0f%%", v/dim(voxeldat)[2]*100)
                     status_message <- paste0(apercent, ": Voxel ", v, " of ", dim(voxeldat)[2], "...")
                     message(status_message)
  }

  # `method = REML` for unbiased estimate of variance parameters.
  # See: 
  # Luke, S. G. (2017). Evaluating significance in linear mixed-effects
  # models in R. Behavior Research Methods, 49(4), 1494–1502. 
  # https://doi.org/10.3758/s13428-016-0809-y
  
  permuteModel <- neuropointillist::npointLmePermutation(permutationNumber = permutationNumber, 
                                                         permutationRDS = permutationRDS,
                                                         targetDV = targetDV,
                                                         z_sw = TRUE, vcov = 'CR2',
                                                         formula = formula,
                                                         random = ~1 | idnum,
                                                         data = model_data,
                                                         lmeOpts = list(method = 'REML', na.action=na.omit))
  if(is.null(permuteModel$Z)){
    Z <- NOVAL
  } else {
    Z <- permuteModel$Z
  }
  names(Z) <- paste0(targetDV,'-z_sw')
  return(Z)
}
