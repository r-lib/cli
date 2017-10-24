
README.md: README.Rmd
	Rscript -e "knitr::knit('$<', output = '$@')"
