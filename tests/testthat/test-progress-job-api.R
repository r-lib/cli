
test_that("job api basics", {
  h <- progress_handler_log(prefix = "> ")
  expect_snapshot(with_only_handler(h, {
      id <- job_add("foobar", id = "xy", total = 100)
      job_add_progress(id = id)
      job_set_progress(id = id, 50)
      job_add_progress(id = id, 10)
      job_set_status(id = id, "foobar")
      job_set_estimate(id = id, seconds = 42)
      job_add_output(id = id, "out put")
      job_complete(id = id)
    }
  ))
})
