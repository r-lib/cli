# stop_app() errors

    Code
      stop_app(1:10)
    Condition
      Error:
      ! `app` must be a CLI app
      i `app` is an integer vector

# warning if inactive app

    Code
      stop_app(app)
    Condition
      Warning in `stop_app()`:
      No app to end
    Output
      NULL

