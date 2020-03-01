REPORT_DIR:=render
CACHEDIR= cache
LMK=latexmk -pdf -f --interaction=nonstopmode -outdir=$(REPORT_DIR) -bibtex
.PHONY= all clean
WORKSCRIPTS:=$(wildcard scripts/*.R) 
DOCSCRIPTS:=$(wildcard doc/*.Rnw) $(wildcard doc/*/*.Rnw) $(wildcard doc/*.Rmd) $(wildcard doc/*/*.Rmd) $(wildcard doc/*.tex) $(wildcard doc/*/*.tex)
.PHONY: Makefile.auto clean

R:=Rscript
knitBase=$R \
	-e "require(knitr); require(markdown);" \
	-e "require(pander)" \
	-e "knitr::opts_knit[['set']](root.dir = normalizePath('./'))" \
	-e "knitr::opts_chunk[['set']](cache.path='$(@D)/')" \
	-e "knitr::opts_chunk[['set']](fig.path='$(@D)/')" \
	-e "knitr::opts_chunk[['set']](fig.lp='fig:')" \
	-e "knitr::opts_chunk[['set']](fig.show='asis')"

all: reports 

reports: artifacts/cern.docx artifacts/vignette.pdf

Makefile.auto: $(WORKSCRIPTS) $(DOCSCRIPTS)
	@perl scripts/recursive.pl $^ > $@
include Makefile.auto
include Makefile.project

## data-raw
data-raw/%: data-raw/Makefile
	make -C data-raw $(patsubst data-raw/%,%,$@)

## data
data/%.RDS: scripts/create_%.R
	$R $< $@

BLOGLOC:=blogdir/$(shell basename `pwd`)
toblog: $(REPORT_DIR)/post/index.md
	-mkdir -p $(BLOGLOC)
	cp -r $(<D)/* $(BLOGLOC)


# figures are not showing up yet!
$(REPORT_DIR)/%/index.md : doc/%/index.Rmd
	-mkdir -p $(@D)
	$(knitBase) -e "knit('$<', '$@')"
	sed -i.bak -E 's:^!\[([^#]*)#?(.*)\]\($(@D)/(.*)\):{{< bundle-figure name="\3" class="\2"  caption="\1" >}}:g' $@ 
	#perl -pe 's/^!\[([^#]*)#?(.*)\]\((.*)\)/{{< bundle-figure name="\3" class="\2"  caption="\1" >}}/g' $< > $@

# end generic 

#cleaning
.PHONY: dataclean articlen docclean clean
clean: docclean articlean dataclean

dataclean:
	-rm -rf data/*

articlean:
	-rm -rf artifacts/*

docclean:
	-rm -rf $(REPORT_DIR)/*
# end cleaning 
