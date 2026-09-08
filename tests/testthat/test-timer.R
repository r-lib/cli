test_that("ALTREP methods", {
  expect_equal(length(`__cli_update_due`), 1L)

  expect_silent({
    tim <- `__cli_update_due`
    tim[1] <- FALSE
  })

  expect_silent({
    `__cli_update_due`[1]
  })
})

test_that("cli_tick_set", {
  skip_on_cran()
  expect_silent(cli_tick_set())
})

test_that("Windows timer cleanup does not depend on the architecture env var", {
  skip_if_not(.Platform$OS.type == "windows")

  for (no_thread in c(NA_character_, "true")) {
    out <- callr::r(
      function() {
        loadNamespace("cli")
        cli:::unload()
        cli:::unload()
        TRUE
      },
      env = c(PROCESSOR_ARCHITECTURE = NA_character_, CLI_NO_THREAD = no_thread),
      timeout = 10
    )
    expect_true(out)
  }
})

test_that("Windows timer can restart and stop during a long wait", {
  skip_if_not(.Platform$OS.type == "windows")

  out <- callr::r(
    function() {
      loadNamespace("cli")
      for (i in seq_len(10)) {
        cli:::cli_tick_set(60000L)
      }
      cli:::cli_tick_set(10L)
      cli::cli_tick_reset()
      deadline <- Sys.time() + 5
      while (!cli::`__cli_update_due` && Sys.time() < deadline) Sys.sleep(0.01)
      ticking <- isTRUE(cli::`__cli_update_due`)
      cli:::cli_tick_set(60000L)
      Sys.setenv(CLI_NO_THREAD = "true")
      cli:::cli_tick_set()
      cli:::cli_tick_set()
      cli:::unload()
      ticking
    },
    env = c(CLI_NO_THREAD = NA_character_, CLI_TICK_TIME = "60000",
            CLI_SPEED_TIME = "1"),
    timeout = 15
  )
  expect_true(out)
})

test_that("Windows sessions exit with a sleeping timer thread", {
  skip_if_not(.Platform$OS.type == "windows")

  for (i in seq_len(3)) {
    out <- callr::r(
      function() {
        loadNamespace("cli")
        TRUE
      },
      env = c(CLI_NO_THREAD = NA_character_, CLI_TICK_TIME = "60000",
              CLI_SPEED_TIME = "1"),
      timeout = 10
    )
    expect_true(out)
  }
})

test_that("Windows timer finishes before its DLL is unloaded", {
  skip_if_not(.Platform$OS.type == "windows")

  out <- callr::r(
    function() {
      for (i in seq_len(10)) {
        loadNamespace("cli")
        unloadNamespace("cli")
      }
      !"cli" %in% names(getLoadedDLLs())
    },
    env = c(CLI_NO_THREAD = NA_character_, CLI_TICK_TIME = "60000",
            CLI_SPEED_TIME = "1"),
    timeout = 15
  )
  expect_true(out)
})
