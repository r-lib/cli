
test_that("loggerr_out", {
  bar <- new.env(parent = emptyenv())
  bar$id <- "id"
  bar$current <- 13
  bar$total <- 113
  local_mocked_bindings(Sys.time = function() .POSIXct(1623325865, tz = "CET"))
  expect_snapshot(logger_out(bar, "updated"))
})
