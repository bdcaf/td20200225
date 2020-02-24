# td20180225

Data analysis for A short description of the project.
Created by Clemens Ager clemens.ager@a1.net.

Started on 2020-02-24. 

All results are put in the `artifacts` directory.

## Quick start 

The project can be built typing `make`.


## Example Project
When checked out it contains the working example project. 
This works on [CERN Higgs data](http://opendata.cern.ch/record/300).
It follows the first few steps along the [Instruction for use of CMS Open Data in R](http://opendata.cern.ch/record/5102).


The example project consist of following steps:

0. Obtain input data:
 a. [CERN Higgs data](http://opendata.cern.ch/record/300) is downloaded to `data-raw/`
1. Create R data: `data-raw/Jpsimumu.csv` is read into `data/jspi.RDS`
2. Manipulate R data: 
3. Create a markdown report which is then converted to `.docx` (word)
   `artifacts/titanic.docx` via [pandoc](https://pandoc.org/)
4. Create a `Rnw` report which is then rendered with other tex files to
   a `pdf`: `artifacts/sample_report.pdf` via `latexmk`.

If all is setup `make` should build all data files.

Individual files are created using e.g. `make work/transform.RDS`
## Idioms

### General

This work flow depends on make.
Make is picky about file names. In particular avoid spaces. 
Input data often comes in annoying characters - I find the command [detox](https://linux.die.net/man/1/detox) handy for this task.

### Folder structure

I came up with following structure. 
In particular the folders `data`, `render`, `artifacts` are excluded from git and also may recreate automatically.
The files in folder `data-raw` are not altered by the scripts.

#### R
- `R` holds R commands, these should be loadable with `devtools_load_all()`.
- 'scripts' R scripts that create data and binary files such as images.
- `doc` holds `Rnw` and `Rmd` files. It can also hole `tex` and `md` files which will be just copied over into the render directory.

#### data
- `data-raw` for unprocessed data. Files in here must not get altered by scripts.
- `data` in processed form - `Rdata` or `RDS`. Every file in `data` is created by commands in `scripts/`.

#### outputs
- `render` - output from `Rnw` and `Rmd` files together with their embedded images.  The content of this directory can get deleted.
- `artifacts` - completed products

### Script Patterns

#### `make.auto`

I use the perl script `scripts/recursive.pl` to walk through a number of files to automatically generate dependencies.
For now I only look for the `readRDS` command in R code, more definitely to come. 
Likely it may not catch some dependencies. Easiest is to add them yourself to the Makefile - or as I prefer an imported one here I called it `make.project`.
It`s difficult to figure out modifications in functions under `R`. If I depend on them I add them to this file.
I also want it to catch included `tex` files. 

Either way filling in this requirements manually in `make.project` is no big deal for reasonably sized projects.
For huge ones it pays to adapt `scripts/recursive.pl`, but I doubt this generalizes.

#### `scripts/create_myname.R`
A script to create `data/myname.RDS`.
By using this pattern the Makefile rule is automatic.

I set it so the target file is also first argument. 
That way I don't need to repeat the filename inside the script. 
Also makes moving to a different name automatic.

Inside the script end with:
```{r}
#save results ------------------------------------------------------------
args <- commandArgs(trailingOnly = TRUE)
saveRDS(mydata, file=args[[1]])
```




## Tricks

### general

- I reference files from the project root. Both in Makefile and also in R. This helps to keep references consistent.

### R

- I (ab)use `devtools`.  In particular often `devtools::load_all()`.  This requires the folder be named as valid R package and the `DESCRIPTION` file being valid.  The most common issue that an R package name may only contain characters, numbers and `.`, and must start with a character.


### git

- git only stores files - not directories. To keep the structure there are empty files `.gitkeep`.
- git does not handle binary files well. Use [git lfs](https://git-lfs.github.com/) for binary files like `Rdata` or preferable store them externally.


### Make

- For tasks that are independent on the rest of the project a separate `Makefile` may be used in a subdir. I perform the download of external data to `data-raw`. The file `data-raw/Makefile` contains the code. 
Inside the main `Makefile` I use the code:

```
data-raw/%: data-raw/Makefile
	make -C data-raw $(patsubst data-raw/%,%,$@)
```

This way even if `data-raw/Makefile` defines more data files but those are not used. 
Only the required ones should download to save space and bandwidth.
