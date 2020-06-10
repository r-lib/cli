
test_that("suppress output", {
  if (getRversion() >= "4.0.0") {
    cnd <- NULL
    tryCatch(
      suppressMessages(cli_text("foo"), "cliMessage"),
      message = function(cnd2) cnd <<- cnd2
    )
    expect_null(cnd)
  }

  mysuppress <- function(expr) {
    withCallingHandlers(
      expr,
      cliMessage = function(msg) invokeRestart("muffleMessage")
    )
  }

  cnd <- NULL
  tryCatch(
    mysuppress(cli_text("foo")),
    message = function(cnd2) cnd <<- cnd2
  )
  expect_null(cnd)
})
