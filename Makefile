
README.md: inst/README.Rmd
	Rscript -e "knitr::knit('$<', output = '$@')"
