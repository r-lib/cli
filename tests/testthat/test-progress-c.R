
test_that("c api", {

})

test_that("unloading stops the thread", {
  skip_on_cran()
  fun <- function() {
    before <- ps::ps_num_threads()
    library(cli)
    between <- ps::ps_num_threads()
    unloadNamespace("cli")
    after <- ps::ps_num_threads()
    list(before = before, between = between, after = after)
  }

  out <- callr::r(fun)
  expect_equal(out$between, out$before + 1L)
  expect_equal(out$after, out$between - 1L)
})
