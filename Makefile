
README.md: README.Rmd
	Rscript -e "rmarkdown::render('$<')"
