test_that("is_cpt_block", {
  expect_true(is_cpt_block(cpt_div()))
  expect_true(is_cpt_block(cpt_h1("foo")))
  expect_true(is_cpt_block(cpt_h2("foo")))
  expect_true(is_cpt_block(cpt_h3("foo")))

  expect_false(is_cpt_block(cpt_txt("foobar")))
  expect_false(is_cpt_block(cpt_span()))
})

test_that("is_cpt_inline", {
  expect_true(is_cpt_inline(cpt_txt("foobar")))
  expect_true(is_cpt_inline(cpt_span()))

  expect_false(is_cpt_inline(cpt_div()))
  expect_false(is_cpt_inline(cpt_h1("foo")))
  expect_false(is_cpt_inline(cpt_h2("foo")))
  expect_false(is_cpt_inline(cpt_h3("foo")))
})

test_that("cpt_div", {
  expect_snapshot({
    cpt_div()
    cpt_div(cpt_div())
    cpt_div(cpt_div(), cpt_div())
  })
})

test_that("cpt_span", {
  expect_snapshot({
    cpt_span()
    cpt_span(cpt_span())
    cpt_span(cpt_span(), cpt_span())
    cpt_span(cpt_txt("foobar"))
  })
})

test_that("cpt_h1", {
  expect_snapshot({
    cpt_h1("foobar")
    cpt_h1(cpt_txt("foo"))
    cpt_h1(cpt_span())
  })
})

test_that("cpt_h2", {
  expect_snapshot({
    cpt_h2("foobar")
    cpt_h2(cpt_txt("foo"))
    cpt_h2(cpt_span())
  })
})

test_that("cpt_h3", {
  expect_snapshot({
    cpt_h3("foobar")
    cpt_h3(cpt_txt("foo"))
    cpt_h3(cpt_span())
  })
})
