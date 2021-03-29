
#' Create a table
#'
#' @param ... The rows of the table, character vectors.
#' @param data if not `NULL`, then a data frame to attach to the
#' search path while creating the table.
#' @param th A header row, optionally.
#' @param .close Whether to close the table. If it is not close then
#' more lines can be added to it.
#' @inheritParams cli_div
#' @return The id of the table container, invisibly.
#'
#' @family tables
#' @export

cli_table <- function(..., data = NULL, th = NULL, id = NULL, class = NULL,
                      .close = TRUE, .auto_close = TRUE,
                      .envir = parent.frame()) {

}

#' Add a header row to a table
#'
#' @param ... One or more character vectors, the headers row(s).
#' @inheritParams cli_table
#' @return The id of the header container, invisibly.
#'
#' @family tables
#' @export

cli_th <- function(..., data = NULL, id = NULL, class = NULL,
                   .envir = parent.frame()) {

}

#' Add a row to the table
#'
#' @param ... One or more character vectors, the row(s) to add.
#' @inheritParams cli_table
#' @return The id of the row container, invisibly.
#'
#' @family tables
#' @export

cli_tr <- function(..., data = NULL, id = NULL, class = NULL,
                   .envir = parent.frame()) {

}


function() {

  cli_table(
    data = mtcars,
    c("{.right {rownames(data)}}", "{mpg} MPG", "{hp} HP")
  )

}
