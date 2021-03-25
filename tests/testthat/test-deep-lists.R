
start_app()
on.exit(stop_app(), add = TRUE)

test_that("deep lists ul", {
  test_ul = function(n = 2) {
    for(i in seq_len(n)) {
      cli::cli_ul()
      cli::cli_li(paste0("Level ",i))
    }
  }
  expect_snapshot(
    for (i in 1:4) test_ul(i)
  )
})

test_that("deep lists ol", {
  test_ol = function(n = 2) {
    for(i in seq_len(n)) {
      cli::cli_ol()
      cli::cli_li(paste0("Level ",i))
    }
  }
  expect_snapshot(
    for (i in 1:4) test_ol(i)
  )
})

test_that("deep lists ol ul", {
  test_ol_ul = function(n = 2) {
    for(i in seq_len(n)) {
      cli::cli_ol()
      cli::cli_li(paste0("Level ",2*i-1))

      cli::cli_ul()
      cli::cli_li(paste0("Level ",2*i))
    }
  }
  expect_snapshot(
    for (i in 1:4) test_ol_ul(i)
  )
})

test_that("deep lists ul ol", {
  test_ul_ol = function(n = 2) {
    for(i in seq_len(n)) {
      cli::cli_ul()
      cli::cli_li(paste0("Level ",2*i-1))

      cli::cli_ol()
      cli::cli_li(paste0("Level ",2*i))
    }
  }
  expect_snapshot(
    for (i in 1:4) test_ul_ol(i)
  )
})
