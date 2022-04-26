
autolink_calls <- function(fun_names, env = NULL) {
  pkgs <- find_functions(fun_names, env)

  # TODO
  print(pkgs)

  fun_names
}

find_functions <- function(fun_names, env = NULL) {
  fns <- mget(
    fun_names,
    envir = env %||% as.environment(-1L),
    mode = "function",
    ifnotfound = list(NULL),
    inherits = TRUE
  )

  envs <- lapply(fns, function(x) {
    if (is.null(x)) {
      NULL
    } else if (is.primitive(x)) {
      .BaseNamespaceEnv
    } else {
      environment(x)
    }
  })

  pkgs <- vcapply(envs, function(env) {
    if (is.null(env)) {
      NA_character_
    } else {
      env_label(env)
    }
  })

  exps <- mapply(fun_names, envs, FUN = function(fn, env) {
    tryCatch({
      getExportedValue(env, fn)
      TRUE
    }, error = function(e) FALSE)
  })

  data.frame(
    stringsAsFactors = FALSE,
    fun = fun_names,
    pkg = pkgs,
    exp = exps
  )
}

env_label <- function(env) {
  nm <- env_name(env)
  if (nzchar(nm)) {
    nm
  } else {
    NA_character_
  }
}

env_name <- function(env) {
  if (identical(env, globalenv())) {
    return(NA_character_)
  }
  if (identical(env, baseenv())) {
    return("base")
  }
  if (identical(env, emptyenv())) {
    return(NA_character_)
  }
  if (isNamespace(env)) {
    environmentName(env)
  } else {
    NA_character_
  }
}
