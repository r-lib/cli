#' Emit a cli message
#'
#' @param cpt Component to include in the message.
#'
#' @export

# TODO: can we return some information on whether the message was
# printed or not?
# TODO: can we get away with a single withRestarts()?

cli_msg <- function(cpt) {
  cond <- list(message = cpt)
  class(cond) <- c(
    getOption("cli.message_class2"),
    "cli_message2",
    "condirtion"
  )
  withRestarts(cli_message_handled = function() NULL, {
    signalCondition(cond)
    cli__default_handler2(cond)
  })

  invisible()
}

cli__default_handler2 <- function(msg) {
  lines <- preview(msg$message)
  lines <- gsub("\u00a0", " ", lines, fixed = TRUE)
  msg2 <- .makeMessage(paste0(lines, "\n"), appendLF = FALSE)
  cond <- simpleMessage(msg2)
  class(cond) <- c("cliMessage", class(cond))

  withRestarts(muffleMessage = function() NULL, {
    signalCondition(cond)
    cli__default_handler2_write(lines)
  })

  invisible()
}

cli__default_handler2_write <- function(lines) {
  output <- cli_output_connection()
  writeLines(lines, output)
  invisible()
}
