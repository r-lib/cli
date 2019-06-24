
defer <- function(expr, envir = parent.frame(),
                  priority = c("first", "last")) {
  if (identical(envir, .GlobalEnv)) {
    stop("attempt to defer event on global environment")
  }
  priority <- match.arg(priority)
  front <- priority == "first"
  invisible(add_handler(
    envir, list(expr = substitute(expr), envir = parent.frame()), front))
}

# Handlers used for 'defer' calls. Attached as a list of expressions for the
# 'handlers' attribute on the environment, with 'on.exit' called to ensure
# those handlers get executed on exit.

get_handlers <- function(envir) {
  as.list(attr(envir, "handlers"))
}

set_handlers <- function(envir, handlers) {
  has_handlers <- "handlers" %in% names(attributes(envir))
  attr(envir, "handlers") <- handlers
  if (!has_handlers) {
    call <- as.call(list(execute_handlers, envir))

    # We have to use do.call here instead of eval because of the way on.exit
    # determines its evaluation context
    # (https://stat.ethz.ch/pipermail/r-devel/2013-November/067867.html)
    do.call(base::on.exit, list(substitute(call), TRUE), envir = envir)
  }
}

execute_handlers <- function(envir) {
  handlers <- get_handlers(envir)
  for (handler in handlers) {
    tryCatch(eval(handler$expr, handler$envir), error = identity)
  }
}

add_handler <- function(envir, handler, front) {

  handlers <- if (front) {
    c(list(handler), get_handlers(envir))
  } else {
    c(get_handlers(envir), list(handler))
  }

  set_handlers(envir, handlers)
  handler
}
