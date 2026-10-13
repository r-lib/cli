test_that("No leftover SVG figures", {
  skip_on_cran()
  skip_on_covr()
  pkg_dir <- test_package_root()
  figs <- dir(file.path(pkg_dir, "man", "figures"), pattern = "[.]svg$")
  rd <- dir(file.path(pkg_dir, "man"), pattern = "[.]Rd$", full.names = TRUE)
  rd_figs <- unlist(lapply(rd, function(x) {
    grep("\\\\figure\\{", readLines(x), value = TRUE)
  }))
  rd_figs <- sub("^.*\\\\figure\\{(.*[.]svg).*$", "\\1", rd_figs)

  expect_equal(
    sort(figs),
    sort(unique(rd_figs))
  )

  figs2 <- dir(
    file.path(pkg_dir, "man", "figures", "README"),
    pattern = "[.]svg$"
  )
  readme <- file.path(pkg_dir, "README.md")
  readme_figs <- grep("man/figures/", readLines(readme), value = TRUE)
  readme_figs <- sub("^.*man/figures/README/(.*[.]svg).*$", "\\1", readme_figs)

  expect_equal(
    sort(figs2),
    sort(unique(readme_figs))
  )
})
