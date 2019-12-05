## ---- include = FALSE-----------------------------------------------------------------------------
knitr::opts_chunk$set(
  R.options = list(
    crayon.enabled = FALSE,
    cli.unicode = FALSE
  ),
  results = "hold",
  comment = "#>",
  cache = TRUE
)

## -------------------------------------------------------------------------------------------------
library(cli)
nfile <- 0; cli_text("Found {nfile} file{?s}.")
nfile <- 1; cli_text("Found {nfile} file{?s}.")
nfile <- 2; cli_text("Found {nfile} file{?s}.")

## -------------------------------------------------------------------------------------------------
ndir <- 1; cli_text("Found {ndir} director{?y/ies}.")
ndir <- 5; cli_text("Found {ndir} director{?y/ies}.")

## -------------------------------------------------------------------------------------------------
nfile <- 0; cli_text("Found {no(nfile)} file{?s}.")
nfile <- 1; cli_text("Found {no(nfile)} file{?s}.")
nfile <- 2; cli_text("Found {no(nfile)} file{?s}.")

## -------------------------------------------------------------------------------------------------
pkgs <- "pkg1"
cli_text("Will remove the {.pkg {pkgs}} package{?s}.")
pkgs <- c("pkg1", "pkg2", "pkg3")
cli_text("Will remove the {.pkg {pkgs}} package{?s}.")

## -------------------------------------------------------------------------------------------------
pkgs <- character()
cli_text("Will remove {?no/the/the} {.pkg {pkgs}} package{?s}.")
pkgs <- c("pkg1", "pkg2", "pkg3")
cli_text("Will remove {?no/the/the} {.pkg {pkgs}} package{?s}.")

## -------------------------------------------------------------------------------------------------
nfiles <- 3; ndirs <- 1
cli_text("Found {nfiles} file{?s} and {ndirs} director{?y/ies}")

## -------------------------------------------------------------------------------------------------
nupd <- 3; ntotal <- 10
cli_text("{nupd}/{ntotal} {qty(nupd)} file{?s} {?needs/need} updates")

