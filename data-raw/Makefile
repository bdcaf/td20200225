#
# Makefile 
# --------
#
# In most cases the rules will be explicitly - however here a more automatic
# approach is showcased.  As example setup to pull in data for the weekly
# #TidyTuesday.  See https://github.com/rfordatascience/tidytuesday
#
# It uses three variables which need to be set. BASEGH should not change.  For a particular
# #TidyTuesday adjust the date in the DATADIR.  To get the data file adjust
# the DATANAME to corresponding title.  Explicitly put all the labels for the
# dataset in the `all` dependency.  However this is not necessary and when the
# parent makefile requires a `csv` file in `data-dir` it will know what to do.
#
# Notes:
#
# Readme.md is not required - but may be nice to obtain, as it contains some
# explanation of the data set.
#
#`make online` goes to the days page in github (to figure out the file names).
#
# In a realistic workflow it will make more sense to obtain the data by
# running the `%.csv: %.R` rule. In the spirit of this cookiecutter I would
# usually suggest downloading the input files here (into data-raw) and use the
# scripts to create data in the data directory. I do not enable this by
# default as it requires some packages to be installed.
#  

# The github url for this day is: https://github.com/rfordatascience/tidytuesday/tree/master/data/2020/2020-02-25
BASEGH:=https://raw.github.com/rfordatascience/tidytuesday/master/data
DATADIR:=2020/2020-02-25
DATANAME:=measles

all: $(DATANAME).csv $(DATANAME).R readme.md

@PHONY: clean list online
clean:
	-rm readme.md
	-rm *.csv

online:
	open https://github.com/rfordatascience/tidytuesday/tree/master/data/$(DATADIR)

%.csv %.R %.md:
	curl -L "$(BASEGH)/$(DATADIR)/$@" -o "$@"

# Create csv via the Rscript
# %.csv: %.R:
# 	Rscript $<


# vim:ft=make
#
