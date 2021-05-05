library(RNifti)
library(data.table)
library(ggplot2)
library(viridis)
library(patchwork)

eptot_within_t <- RNifti::readNifti('~/NewNeuropoint/eptot.fear/eptot.fear/eptot.fear.WCEN_EPISODICTOT-t_sw.nullcrrct.nii.gz')
eptot_within_t_not_sw <- RNifti::readNifti('~/NewNeuropoint/eptot.fear/eptot.fear/eptot.fear.WCEN_EPISODICTOT-t.nullcrrct.nii.gz')
eptot_within_p <- RNifti::readNifti('~/NewNeuropoint/eptot.fear/eptot.fear/eptot.fear.WCEN_EPISODICTOT-p_satt_sw.nii.gz')
eptot_within_p_not_sw <- RNifti::readNifti('~/NewNeuropoint/eptot.fear/eptot.fear/eptot.fear.WCEN_EPISODICTOT-p.nii.gz')
eptot_within_est <- RNifti::readNifti('~/NewNeuropoint/eptot.fear/eptot.fear/eptot.fear.WCEN_EPISODICTOT-est.nii.gz')
eptot_between_t <- RNifti::readNifti('~/NewNeuropoint/eptot.fear/eptot.fear/eptot.fear.GCEN_EPISODICTOT-t_sw.nullcrrct.nii.gz')
eptot_between_est <- RNifti::readNifti('~/NewNeuropoint/eptot.fear/eptot.fear/eptot.fear.GCEN_EPISODICTOT-est.nii.gz')
chsev_within_t <- RNifti::readNifti('~/NewNeuropoint/chsev.fear/chsev.fear/chsev.fear.WCEN_CHRONICSEV-t_sw.nullcrrct.nii.gz')
chsev_within_est <- RNifti::readNifti('~/NewNeuropoint/chsev.fear/chsev.fear/chsev.fear.WCEN_CHRONICSEV-est.nii.gz')
chsev_between_t <- RNifti::readNifti('~/NewNeuropoint/chsev.fear/chsev.fear/chsev.fear.GCEN_CHRONICSEV-t_sw.nullcrrct.nii.gz')
chsev_between_est <- RNifti::readNifti('~/NewNeuropoint/chsev.fear/chsev.fear/chsev.fear.GCEN_CHRONICSEV-est.nii.gz')



eptot_sw_comp_dt <- data.table(t_sw = as.numeric(eptot_within_t), 
                         t = as.numeric(eptot_within_t_not_sw))
eptot_sw_comp_dt <- eptot_sw_comp_dt[t_sw != 0 & t != 0]

eptot_swp_comp_dt <- data.table(p_sw = 1-as.numeric(eptot_within_p), 
                               p = 1-as.numeric(eptot_within_p_not_sw))
eptot_swp_comp_dt <- eptot_swp_comp_dt[p_sw != 1 & p != 1]

eptot_t_dt <- data.table(within = as.numeric(eptot_within_t), 
                   between = as.numeric(eptot_between_t))
eptot_t_dt_0 <- eptot_t_dt[within != 0 | between != 0]
eptot_est_dt <- data.table(within = as.numeric(eptot_within_est), 
                   between = as.numeric(eptot_between_est))
eptot_est_dt_0 <- eptot_est_dt[within != 0 | between != 0]
chsev_t_dt <- data.table(within = as.numeric(chsev_within_t), 
                         between = as.numeric(chsev_between_t))
chsev_t_dt_0 <- chsev_t_dt[within != 0 | between != 0]
chsev_est_dt <- data.table(within = as.numeric(chsev_within_est), 
                           between = as.numeric(chsev_between_est))
chsev_est_dt_0 <- chsev_est_dt[within != 0 | between != 0]


ept.p <- ggplot(eptot_t_dt_0, aes(x = within, y = between)) +
  geom_hex(aes(color = ..count.., fill = ..count..)) +
  scale_fill_viridis(trans = 'log', aesthetics = c('color', 'fill'), 
                      breaks = c(0, 10, 100, 1000), name = 'N voxels') +
  # geom_smooth(method = 'gam', color = 'black') + 
  theme_minimal() + 
  theme(plot.title = element_text(hjust = 0.5)) +
  labs(title = 'Episodic Stress t-scores', x = 'Within-person', y = 'Between-person') + 
  coord_cartesian(x = c(-6, 8), y = c(-6, 8))

epest.p <- ggplot(eptot_est_dt_0, aes(x = within, y = between)) +
  geom_hex(aes(color = ..count.., fill = ..count..)) +
  scale_fill_viridis(trans = 'log', aesthetics = c('color', 'fill'), 
                      breaks = c(0, 10, 100, 1000)) +
  geom_smooth(method = 'gam', color = 'black') +
  theme_minimal() + 
  theme(legend.position = 'none', plot.title = element_text(hjust = 0.5)) + 
  labs(title = 'Episodic Stress coefficients', x = 'Within-person', y = 'Between-person')

cht.p <- ggplot(chsev_t_dt_0, aes(x = within, y = between)) +
  geom_hex(aes(color = ..count.., fill = ..count..)) +
  scale_fill_viridis(trans = 'log', aesthetics = c('color', 'fill'), 
                     breaks = c(0, 10, 100, 1000)) +
  # geom_smooth(method = 'gam', color = 'black') + 
  theme_minimal() + 
  theme(legend.position = 'none', plot.title = element_text(hjust = 0.5)) + 
  labs(title = 'Chronic Stress t-scores', x = 'Within-person', y = 'Between-person') + 
  coord_cartesian(x = c(-6, 8), y = c(-6, 8))

ches.p <- ggplot(chsev_est_dt_0, aes(x = within, y = between)) +
  geom_hex(aes(color = ..count.., fill = ..count..)) +
  scale_fill_viridis(trans = 'log', aesthetics = c('color', 'fill'), 
                     breaks = c(0, 10, 100, 1000)) +
  geom_smooth(method = 'gam', color = 'black') + 
  theme_minimal() + 
  theme(legend.position = 'none') + 
  labs(title = 'Chronic Stress coefficients', x = 'Within-person', y = 'Between-person')

ept.p + cht.p + patchwork::plot_layout(guides = 'collect')

ggplot(eptot_sw_comp_dt, aes(y = t_sw, x = t)) +
  geom_hex(aes(color = ..count.., fill = ..count..)) +
  geom_abline(intercept = 0, slope = 1, color = 'black', alpha = .5) + 
  scale_fill_viridis(trans = 'log', aesthetics = c('color', 'fill'), 
                     breaks = c(0, 10, 100, 1000), name = 'N voxels') +
  theme_minimal() + 
  theme(plot.title = element_text(hjust = 0.5)) +
  labs(title = 'Episodic Stress t-scores', y = 't with SE correction', x = 'raw t') + 
  coord_cartesian(x = c(-6, 8), y = c(-6, 8))

ggplot(eptot_swp_comp_dt, aes(y = p_sw, x = p)) +
  geom_hex(aes(color = ..count.., fill = ..count..)) +
  geom_abline(intercept = 0, slope = 1, color = 'black', alpha = .5) + 
  scale_fill_viridis(trans = 'log', aesthetics = c('color', 'fill'), 
                     breaks = c(0, 10, 100, 1000), name = 'N voxels') +
  theme_minimal() + 
  theme(plot.title = element_text(hjust = 0.5)) +
  labs(title = 'Episodic Stress p-values', y = 'p with SE and DF correction', x = 'raw p')

ggplot(eptot_swp_comp_dt, aes(x = p_sw)) + 
  geom_histogram()

ggplot(eptot_swp_comp_dt, aes(x = p)) + 
  geom_histogram()
