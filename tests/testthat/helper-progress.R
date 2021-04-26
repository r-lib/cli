
with_only_handler <- function(handler, expr) {
  withr::local_options(list(progress_omit_default_handler = TRUE))
  hs <- new.env(parent = emptyenv())
  hs[["test"]] <- new_handler_record("test", handler)
  withr::local_options(list(progress_handlers_override = hs))
  expr
}
