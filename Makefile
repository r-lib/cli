
README.md: README.Rmd header.md
	Rscript -e "rmarkdown::render('$<')" && \
	sed -i .bak 's|tools/figures|https://cdn.jsdelivr.net/gh/r-lib/cli@v1.1.0-pre/tools/figures|g' README.md
