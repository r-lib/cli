
test_that_cli("tree", {
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

  expect_snapshot(tree(data))

  expect_snapshot(tree(data, root = "desc"))

  # Check that trees with apparent circularity error nicely
  data <- data.frame(
    stringsAsFactors = FALSE,
    X = c("a", "b", "c","d", "e", "f", "g", "h", "j"),
    Y = I(list(
      c("b", "e", "f"),
      c("d", "g"),
      character(0),
      c("a", "h"),
      character(0),
      character(0),
      character(0),
      c("j"),
      character(0)
    ))
  )

  expect_warning(tree(data), "Endless loop found in tree: a -> b -> d -> a")
})

test_that_cli("trimming", {

  pkgdeps <- list(
    "dplyr@0.8.3" = c("assertthat@0.2.1", "glue@1.3.1", "magrittr@1.5",
      "R6@2.4.0", "Rcpp@1.0.2", "rlang@0.4.0", "tibble@2.1.3",
      "tidyselect@0.2.5"),
    "assertthat@0.2.1" = character(),
    "glue@1.3.1" = character(),
    "magrittr@1.5" = character(),
    "pkgconfig@2.0.3" = character(),
    "R6@2.4.0" = character(),
    "Rcpp@1.0.2" = character(),
    "rlang@0.4.0" = character(),
    "tibble@2.1.3" = c("cli@1.1.0", "crayon@1.3.4", "fansi@0.4.0",
       "pillar@1.4.2", "pkgconfig@2.0.3", "rlang@0.4.0"),
    "cli@1.1.0" = c("assertthat@0.2.1", "crayon@1.3.4"),
    "crayon@1.3.4" = character(),
    "fansi@0.4.0" = character(),
    "pillar@1.4.2" = c("cli@1.1.0", "crayon@1.3.4", "fansi@0.4.0",
       "rlang@0.4.0", "utf8@1.1.4", "vctrs@0.2.0"),
    "utf8@1.1.4" = character(),
    "vctrs@0.2.0" = c("backports@1.1.5", "ellipsis@0.3.0",
       "digest@0.6.21", "glue@1.3.1", "rlang@0.4.0", "zeallot@0.1.0"),
    "backports@1.1.5" = character(),
    "ellipsis@0.3.0" = c("rlang@0.4.0"),
    "digest@0.6.21" = character(),
    "glue@1.3.1" = character(),
    "zeallot@0.1.0" = character(),
    "tidyselect@0.2.5" = c("glue@1.3.1", "purrr@1.3.1", "rlang@0.4.0",
       "Rcpp@1.0.2"),
    "purrr@0.3.3" = c("magrittr@1.5", "rlang@0.4.0")
  )

  pkgs <- data.frame(
    stringsAsFactors = FALSE,
    name = names(pkgdeps),
    deps = I(unname(pkgdeps))
  )
  pkgs$label <- pkgs$name
  pkgs$trimmed <- paste(pkgs$name, " (trimmed)")

  expect_snapshot(tree(pkgs, trim = TRUE))
})
