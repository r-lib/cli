
test_that("parsing and formatting", {
  expect_snapshot({
    cpt_text("plain text")
    cpt_text("subs {1:6} titution")
    cpt_text("sty{.emph li}ng")
    cpt_text("styling {.plus {1:10}} subst")
    cpt_text("f {1:2}{4:5} {.bar plain}o{.foo {.bar {3:4}}}o")
  })
})

test_that("plurals", {
  expect_snapshot({
    cpt_text("Loaded {0} file{?s}.")
    cpt_text("Loaded {1} file{?s}.")
    cpt_text("Loaded {2} file{?s}.")
  })
})

test_that("plurals postprocessing", {
  expect_snapshot({
    cpt_text("File{?s} loaded: {0}")
    cpt_text("File{?s} loaded: {1}")
    cpt_text("File{?s} loaded: {2}")
  })
})

test_that("inline styling errors", {
  expect_snapshot(error = TRUE, {
    cpt_text("foo {.not+this} bar")
  })
})
