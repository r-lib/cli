
rule_class <- function(x) {
  structure(x, class = c("cli_rule", "rule", "cli_ansi_string", "ansi_string", "character"))
}

capture_msgs <- function(expr) {
  msgs <- character()
  i <- 0
  suppressMessages(withCallingHandlers(
    expr,
    message = function(e) msgs[[i <<- i + 1]] <<- conditionMessage(e)))
  paste0(msgs, collapse = "")
}

capture_cli_messages <- function(expr) {
  msgs <- character()
  withCallingHandlers(
    expr,
    cliMessage = function(e) {
      msgs <<- c(msgs, conditionMessage(e))
      invokeRestart("muffleMessage")
    }
  )
  msgs
}

capt <- function(expr, print_it = TRUE) {
  pr <- if (print_it) print else identity
  paste(capture.output(pr(expr)), collapse = "\n")
}

capt0 <- function(expr, strip_style = FALSE) {
  out <- capture_msgs(expr)
  if  (strip_style) ansi_strip(out) else out
}

local_cli_config <- function(unicode = FALSE, dynamic = FALSE,
                             ansi = FALSE, num_colors = 1,
                             .local_envir = parent.frame()) {
  withr::local_options(
    cli.dynamic = dynamic,
    cli.ansi = ansi,
    cli.unicode = unicode,
    crayon.enabled = num_colors > 1,
    crayon.colors = num_colors,
    .local_envir = .local_envir
  )
  withr::local_envvar(
    PKG_OMIT_TIMES = "true",
    PKG_OMIT_SIZES = "true",
    .local_envir = .local_envir
  )
}

test_style <- function() {
  list(
    ".testcli h1" = list(
      "font-weight" = "bold",
      "font-style" = "italic",
      "margin-top" = 1,
      "margin-bottom" = 1),
    ".testcli h2" = list(
      "font-weight" = "bold",
      "margin-top" = 1,
      "margin-bottom" = 1),
    ".testcli h3" = list(
      "text-decoration" = "underline",
      "margin-top" = 1)
  )
}

fix_times <- function(out) {
  out <- sub("[(][ ]*[.0-9]+ [Mk]B/s[)]", "(8.5 MB/s)", out)
  out <- sub("[(][.0-9]+/s[)]", "(100/s)", out)
  out <- sub(" [.0-9]+(ms|s|m)", " 3ms", out)
  out <- sub("ETA:[ ]*[.0-9]+m?s", "ETA:  1s", out)
  out <- gsub("\\[[.0-9]+m?s\\]", "[1s]", out)
  out
}

fix_logger_output <- function(lines) {
  sub(
    paste0(
      "^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]T",
      "[0-9][0-9]:[0-9][0-9]:[0-9][0-9]\\+00:00 ",
      "cli-[0-9]+-[0-9]+ "
    ),
    "2021-06-18T00:09:14+00:00 cli-36434-1 ",
    lines
  )
}

make_c_function <- function(file = NULL,
                            code = NULL,
                            args = character(),
                            type = c(".c", ".cpp"),
                            header = NULL,
                            linkingto = packageName(),
                            quiet = Sys.getenv("TESTTHAT") == "true") {
  type <- match.arg(type)

  # Create source file
  dir.create(dir <- tempfile())
  if (is.null(file)) {
    lines <- create_c_function_call(code, args, header = header)
  } else {
    lines <- readLines(file)
  }
  src <- basename(tempfile(fileext = type))
  writeLines(lines, file.path(dir, src))

  # Compile
  cflags <- ""
  for (pkg in linkingto) {
    pkgdir <- file.path(find.package(pkg), "include")
    lcldir <- file.path(find.package(pkg), "inst", "include")
    cflags <- paste(cflags, "-I", pkgdir, "-I", lcldir)
  }
  env <- c(PKG_CFLAGS = cflags)
  callr::rcmd(
    "SHLIB",
    src,
    wd = file.path(dir),
    env = env,
    echo = !quiet,
    show = !quiet
  )

  # Load DLL
  dllfile <- file.path(dir, sub("[.]c(pp)?$", .Platform$dynlib.ext, src))
  dll <- dyn.load(dllfile, local = TRUE, now = TRUE)

  # TODO: finalizer to unload/delete

  dll
}

create_c_function_call <- function(code, args, header = NULL) {
  c(
    "#include <Rinternals.h>",
    header,
    "SEXP tmp_c_function(",
    if (length(args) > 0) paste0("SEXP ", args, collapse = ", "),
    ") {",
    code,
    "}\n"
  )
}

win2unix <- function (str) {
  gsub("\r\n", "\n", str, fixed = TRUE, useBytes = TRUE)
}

st_from_bel <- function(x) {
  gsub("\007", "\033\\", x, fixed = TRUE)
}

st_to_bel <- function(x) {
  gsub("\033\\", "\007", x, fixed = TRUE)
}

test_package_root <- function() {
  x <- tryCatch(
    rprojroot::find_package_root_file(),
    error = function(e) NULL)

  if (!is.null(x)) return(x)

  pkg <- testthat::testing_package()
  x <- tryCatch(
    rprojroot::find_package_root_file(
      path = file.path("..", "..", "00_pkg_src", pkg)),
    error = function(e) NULL)

  if (!is.null(x)) return(x)

  stop("Cannot find package root")
}

sanitize_wd <- function(x) {
  wd <- paste0("file://", getwd())
  gsub(wd, "file:///testthat/home", x, fixed = TRUE)
}

sanitize_home <- function(x) {
  home <- paste0("file://", path.expand("~"))
  gsub(home, "file:///my/home", x, fixed = TRUE)
}
