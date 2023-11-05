
test_that("parsing and formatting", {
  expect_snapshot({
    cpt_txt("plain text")
    cpt_txt("subs {1:6} titution")
    cpt_txt("sty{.emph li}ng")
    cpt_txt("styling {.plus {1:10}} subst")
    cpt_txt("f {1:2}{4:5} {.bar plain}o{.foo {.bar {3:4}}}o")
  })
})

test_that("plurals", {
  expect_snapshot({
    cpt_txt("Loaded {0} file{?s}.")
    cpt_txt("Loaded {1} file{?s}.")
    cpt_txt("Loaded {2} file{?s}.")
  })
})

test_that("plurals postprocessing", {
  expect_snapshot({
    cpt_txt("File{?s} loaded: {0}")
    cpt_txt("File{?s} loaded: {1}")
    cpt_txt("File{?s} loaded: {2}")
  })
})

test_that("inline styling errors", {
  expect_snapshot(error = TRUE, {
    cpt_txt("foo {.not+this} bar")
  })
})
