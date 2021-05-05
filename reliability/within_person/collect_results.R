library(data.table)
library(brms)
CPUS_DEFAULT <- 17
setDTthreads(CPUS_DEFAULT)

#collect

compute_reliability <- function(fit_files_dt){
  fits <- lapply(file.path('fits', fit_files_dt$file), readRDS)
  cfit <- brms::combine_models(mlist = fits)
  vc <- VarCorr(cfit, summary = FALSE)
  tau_pi <- vc$`id:sess`$sd^2
  tau_beta <- vc$id$sd^2
  sigma2 <- vc$residual__$sd^2
  nvoxel <- length(cfit$data$y)/dim(unique(cfit$data[, c('sess', 'id:sess')]))[[1]]
  alpha_post <- tau_pi / (tau_pi + sigma2/nvoxel)
  pvar <- tau_pi / (tau_pi + tau_beta + sigma2)
  post_df <- data.frame(alpha = alpha_post[,1], prop_var = pvar[,1])
  post_sum <- data.table(posterior_summary(post_df, robust = TRUE), keep.rownames = TRUE)
  post_sum[, c('nvoxel', 'roi', 'sub') := c(nvoxel, unique(fit_files_dt[, c('roi', 'sub')]))]
  return(post_sum)
}

gsub_regex <- 'alpha-fearGTcalm-ROI([0-9]{1,3})(-more_\\d{2})*(-sub)*.rds'

alpha_fit_files <- data.table(file = dir('fits', pattern = 'alpha-fearGTcalm.*rds'))
alpha_fit_files[, c('roi', 'more', 'sub') := 
                  list(gsub(gsub_regex, '\\1', file),
                       gsub(gsub_regex, '\\2', file),
                       gsub(gsub_regex, '\\3', file))]
filenames <- split(split(alpha_fit_files, 
                         by = c('roi', 'sub'),
                         drop = TRUE), 1:CPUS_DEFAULT)
rel_fn <- 'reliability_results.rds'
if(!file.exists(rel_fn)){
  cl <- parallel::makeCluster(CPUS_DEFAULT)
  
  parallel::clusterExport(cl, c('compute_reliability'))
  nada <- parallel::clusterEvalQ(cl, {library(data.table); library(brms)})
  system.time({reliability_list <- parallel::parLapply(cl = cl, filenames, function(some_fns){
    lapply(some_fns, compute_reliability)
    
  })})
  
  parallel::stopCluster(cl)
  
  reliability_dt <- rbindlist(unlist(reliability_list, recursive = FALSE))
  saveRDS(reliability_dt, rel_fn)
} else {
  reliability_dt <- readRDS(rel_fn)
}

reliability_dt[, roi_num := as.numeric(roi)]

#Count

reliability_dt[
  rn == 'prop_var' & sub == '-sub', ][
    data.table(roi = sprintf('%03d', 1:421)), on = 'roi'][
      is.na(Estimate), roi]

#should be 421
reliability_dt[
  rn == 'prop_var' & sub == '-sub', ][
    data.table(roi = sprintf('%03d', 1:421)), on = 'roi'][
      !is.na(Estimate), .N]

reliability_dt[rn == 'prop_var' & sub == '-sub' & nvoxel < 15]

#Plot 

ho_sub_labels <- fread('HO_sub.csv', col.names = c('label', 'roi_num'))
ho_sub_labels[, roi_num := roi_num + 400]
reliability_dt_labels <- ho_sub_labels[reliability_dt, on = 'roi_num']
reliability_dt_labels[, label_text := fifelse(Estimate < .5, label, NA_character_)]

reliability_dt_labels[rn == 'prop_var' & sub == '-sub' & roi > 400, c('label', 'label_text')]

reliability_dt_labels[, roi_num_reverse := -1*(roi_num - 401)]

library(ggplot2)
library(ggrepel)
within_icc_plot <- ggplot(reliability_dt_labels[rn == 'prop_var' & sub == '-sub' & ! grepl('Cerebral Cortex', label)], 
                          aes(x = Estimate, xmin = Q2.5, xmax = Q97.5, y = roi_num_reverse)) +
  geom_rect(ymin = -19, ymax = 0, xmin = 0, xmax = 1, fill = 'lightgrey') + 
  geom_errorbar(alpha = .5, width = 0, size = .25) +
  geom_point() + 
  scale_y_continuous(breaks = c(-19, 1, seq(80, 400, 80)), labels = c('Harvard/Oxford\nSubcortex', 1, seq(80, 320, 80), 'Schaefer-400')) +
  theme_minimal() + 
  coord_cartesian(x = c(0, 1)) + 
  geom_label_repel(aes(label = label_text), box.padding = 1, max.overlaps = Inf, min.segment.length = 0, 
                   nudge_x = -1, nudge_y = 75, fill = alpha('white', .65)) + 
  labs(x = 'Proportion variance due to participant-session', y = 'Parcel')
print(within_icc_plot)
  # theme(axis.text.y = element_blank(), axis.ticks.y = element_blank())
ggsave('prop_var_id-session.svg', width = 8, height = 5, dpi = 150)

#correspondence between 15 voxel sample and all voxels
ggplot(dcast(reliability_dt[rn == 'prop_var', c('Estimate', 'sub', 'roi')], roi ~ sub, value.var = 'Estimate'),
       aes(x = V1, y = `-sub`)) + 
  geom_point() + 
  geom_abline(slope = 1, intercept = 0)

ggplot(dcast(reliability_dt[sub == '-sub', c('Estimate', 'rn', 'roi')], roi ~ rn, value.var = 'Estimate'),
       aes(y = alpha, x = prop_var)) + 
  geom_point() + 
  coord_cartesian(x = c(0, 1), y = c(0, 1))


##Write so we can convert to NII and surface

sch400_HO_dump <- fread('Sch400_HO_maskdump.tsv', sep = ' ',  col.names = c('i', 'j', 'k', 'roi_num'), header = FALSE)

prop_var_sub_out_dt <- reliability_dt[rn == 'prop_var' & sub == '-sub'][sch400_HO_dump, on = 'roi_num']
prop_var_sub_out_dt[is.na(Estimate), c('Estimate', 'Q2.5', 'Q97.5') := 0]

readr::write_delim(prop_var_sub_out_dt[, c('i', 'j', 'k', 'Estimate')], 'prop_id-sess_var_15voxsub.tsv', delim = ' ', col_names = FALSE)


