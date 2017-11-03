
context("tree")

test_that("tree", {
  data <- data.frame(
    stringsAsFactors = FALSE,
    package = c("processx", "backports", "assertthat", "Matrix",
      "magrittr", "rprojroot", "clisymbols", "prettyunits", "withr",
      "desc", "igraph", "R6", "crayon", "debugme", "digest", "irlba",
      "rcmdcheck", "callr", "pkgconfig", "lattice"),
    dependencies = I(list(
      c("assertthat", "crayon", "debugme", "R6"), character(0),
      character(0), "lattice", character(0), "backports", character(0),
      c("magrittr", "assertthat"), character(0),
      c("assertthat", "R6", "crayon", "rprojroot"),
      c("irlba", "magrittr", "Matrix", "pkgconfig"), character(0),
      character(0), "crayon", character(0), "Matrix",
      c("callr", "clisymbols", "crayon", "desc", "digest", "prettyunits",
        "R6", "rprojroot", "withr"),
      c("processx", "R6"), character(0), character(0)
    ))
  )
  out <- capt(tree(data))
  exp <- rebox(mode = "tree",
    "processx",
    "├─assertthat",
    "├─crayon",
    "├─debugme",
    "│ └─crayon",
    "└─R6"
  )
  expect_equal(out, exp)

  out <- capt(tree(data, root = "desc"))
  exp <- rebox(mode = "tree",
    "desc",
    "├─assertthat",
    "├─R6",
    "├─crayon",
    "└─rprojroot",
    "  └─backports")
  expect_equal(out, exp)
})
