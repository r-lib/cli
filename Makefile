
all: inst/README.markdown

inst/README.markdown: inst/README.Rmd
	Rscript -e "knitr::knit('$<', output = '$@')"
