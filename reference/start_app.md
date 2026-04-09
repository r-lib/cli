# Start, stop, query the default cli application

`start_app` creates an app, and places it on the top of the app stack.

## Usage

``` r
start_app(
  theme = getOption("cli.theme"),
  output = c("auto", "message", "stdout", "stderr"),
  .auto_close = TRUE,
  .envir = parent.frame()
)

stop_app(app = NULL)

default_app()
```

## Arguments

- theme:

  Theme to use.

- output:

  How to print the output.

- .auto_close:

  Whether to stop the app, when the calling frame is destroyed.

- .envir:

  The environment to use, instead of the calling frame, to trigger the
  stop of the app.

- app:

  App to stop. If `NULL`, the current default app is stopped. Otherwise
  we find the supplied app in the app stack, and remote it, together
  with all the apps above it.

## Value

`start_app` returns the new app, `default_app` returns the default app.
`stop_app` does not return anything.

## Details

`stop_app` removes the top app, or multiple apps from the app stack.

`default_app` returns the default app, the one on the top of the stack.
