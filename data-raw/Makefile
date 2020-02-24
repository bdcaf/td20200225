#
# Makefile
# Clemens Ager, 2020-02-08 10:06
#
BASEGH:=https://raw.github.com/rfordatascience/tidytuesday/master

all: food_consumption.csv readme.md

readme.md:
	curl -L "$(BASEGH)/data/2020/2020-02-18/readme.md" -o "$@"
food_consumption.csv:
	curl -L "$(BASEGH)/data/2020/2020-02-18/food_consumption.csv" -o "$@"

# vim:ft=make
#
