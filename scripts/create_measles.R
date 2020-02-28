# create_measles.R
#
# This creates RDS files for the measle data in the data directory for
# quick(er) loading.
#
# Note the name measledata is used just here and doesn't transfer to
# other scripts.  This file is triggered by the rule `make
# data/measles.RDS` and the dependency to `data-raw/measles.csv` is
# automatically discovered.
#

devtools::load_all()
library(dplyr)

measledata <- readr::read_csv('data-raw/measles.csv')

# clean obvious stuff:
# 1. -1 to NA
# 2. add suspicious note when percentages add to numbers > 100
measleclean <- measledata %>%
  mutate_at(.vars = vars(mmr, overall, xmed, xper),
            .funs = ~(na_if(., -1))) %>%
  mutate(maxknownexcl = pmax(0,xmed, xper, na.rm=T)) %>%
  mutate(suspicious = maxknownexcl > 100 | mmr+maxknownexcl > 100)


#save results ------------------------------------------------------------
args <- commandArgs(trailingOnly = TRUE)
saveRDS(measleclean, file=args[[1]])
