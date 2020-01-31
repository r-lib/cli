
context("pluralization")

setup(start_app())
teardown(stop_app())

test_that("simplest", {
  cases <- list(
    list("{0} package{?s}", "0 packages"),
    list("{1} package{?s}", "1 package"),
    list("{2} package{?s}", "2 packages")
  )
  for (c in cases) expect_equal(str_trim(capt0(cli_text(c[[1]]))), c[[2]])
})

test_that("irregular", {
  cases <- list(
    list("{0} dictionar{?y/ies}", "0 dictionaries"),
    list("{1} dictionar{?y/ies}", "1 dictionary"),
    list("{2} dictionar{?y/ies}", "2 dictionaries")
  )
  for (c in cases) expect_equal(str_trim(capt0(cli_text(c[[1]]))), c[[2]])
})

test_that("multiple substitutions", {
  cases <- list(
    list("{0} package{?s} {?is/are} ...", "0 packages are ..."),
    list("{1} package{?s} {?is/are} ...", "1 package is ..."),
    list("{2} package{?s} {?is/are} ...", "2 packages are ...")
  )
  for (c in cases) expect_equal(str_trim(capt0(cli_text(c[[1]]))), c[[2]])
})

test_that("multiple quantities", {
  cases <- list(
    list("{0} package{?s} and {0} folder{?s}", "0 packages and 0 folders"),
    list("{1} package{?s} and {0} folder{?s}", "1 package and 0 folders"),
    list("{2} package{?s} and {0} folder{?s}", "2 packages and 0 folders"),
    list("{0} package{?s} and {1} folder{?s}", "0 packages and 1 folder"),
    list("{1} package{?s} and {1} folder{?s}", "1 package and 1 folder"),
    list("{2} package{?s} and {1} folder{?s}", "2 packages and 1 folder"),
    list("{0} package{?s} and {2} folder{?s}", "0 packages and 2 folders"),
    list("{1} package{?s} and {2} folder{?s}", "1 package and 2 folders"),
    list("{2} package{?s} and {2} folder{?s}", "2 packages and 2 folders")
  )
  for (c in cases) expect_equal(str_trim(capt0(cli_text(c[[1]]))), c[[2]])
})

test_that("no()", {
  cases <- list(
    list("{no(0)} package{?s}", "no packages"),
    list("{no(1)} package{?s}", "1 package"),
    list("{no(2)} package{?s}", "2 packages")
  )
  for (c in cases) expect_equal(str_trim(capt0(cli_text(c[[1]]))), c[[2]])
})

test_that("set qty() explicitly", {
  cases <- list(
    list("{qty(0)}There {?is/are} {0} package{?s}", "There are 0 packages"),
    list("{qty(1)}There {?is/are} {1} package{?s}", "There is 1 package"),
    list("{qty(2)}There {?is/are} {2} package{?s}", "There are 2 packages")
  )
  for (c in cases) expect_equal(str_trim(capt0(cli_text(c[[1]]))), c[[2]])
})

test_that("collapsing vectors", {
  pkgs <- function(n) glue("pkg{seq_len(n)}")
  cases <- list(
    list("The {pkgs(1)} package{?s}", "The pkg1 package"),
    list("The {pkgs(2)} package{?s}", "The pkg1 and pkg2 packages"),
    list("The {pkgs(3)} package{?s}", "The pkg1, pkg2, and pkg3 packages")
  )
  for (c in cases) expect_equal(str_trim(capt0(cli_text(c[[1]]))), c[[2]])
})

test_that("pluralization and style", {

  special_style <- list(span.foo = list(before = "<", after = ">"))
  cli_div(theme = special_style)

  cases <- list(
    list("{0} {.foo package{?s}}", "0 <packages>"),
    list("{1} {.foo package{?s}}", "1 <package>"),
    list("{2} {.foo package{?s}}", "2 <packages>")
  )
  for (c in cases) {
    expect_equal(str_trim(capt0(cli_text(c[[1]]), strip_style = TRUE)), c[[2]])
  }

  pkgs <- function(n) glue("pkg{seq_len(n)}")
  cases <- list(
    list("The {.foo {pkgs(1)}} package{?s}",
         "The <pkg1> package"),
    list("The {.foo {pkgs(2)}} package{?s}",
         "The <pkg1> and <pkg2> packages"),
    list("The {.foo {pkgs(3)}} package{?s}",
         "The <pkg1>, <pkg2>, and <pkg3> packages")
  )
  for (c in cases) {
    expect_equal(str_trim(capt0(cli_text(c[[1]]), strip_style = TRUE)), c[[2]])
  }
})

test_that("post-processing", {
  cases <- list(
    list("Package{?s}: {0}", "Packages: 0"),
    list("Package{?s}: {1}", "Package: 1"),
    list("Package{?s}: {2}", "Packages: 2")
  )
  for (c in cases) expect_equal(str_trim(capt0(cli_text(c[[1]]))), c[[2]])

  pkgs <- function(n) glue("pkg{seq_len(n)}")
  cases <- list(
    list("Package{?s}: {pkgs(1)}", "Package: pkg1"),
    list("Package{?s}: {pkgs(2)}", "Packages: pkg1 and pkg2")
  )
  for (c in cases) expect_equal(str_trim(capt0(cli_text(c[[1]]))), c[[2]])
})

test_that("post-processing errors", {
  expect_error(
    cli_text("package{?s}"),
    "Cannot pluralize without a quantity"
  )
  expect_error(
    cli_text("package{?s} {5} {10}"),
    "Multiple quantities for pluralization"
  )
})
