# job api basics

    Code
      with_only_handler(h, {
        id <- job_add("foobar", id = "xy")
        job_add_progress(id = id)
        job_set_progress(id = id, 50)
        job_add_progress(id = id, 10)
        job_set_status(id = id, "foobar")
        job_set_estimate(id = id, seconds = 42)
        job_add_output(id = id, "out put")
        job_complete(id = id)
      })
    Output
      > xy add_job
      > xy add_job_progress 1
      > xy set_job_progress 50
      > xy add_job_progress 10
      > xy set_job_status foobar
      > xy set_job_estimate 42
      > xy add_job_output out put
      > xy complete_job success: TRUE

