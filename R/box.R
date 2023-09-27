new_space_box <- function(height = 0) {
  structure(list(height = height), class = c("cli_box_space", "cli_box"))
}

new_text_box <- function(..., components = NULL) {
  # TODO: check arguments
  components <- c(list(...), components)
  structure(
    list(components = components),
    class = c("cli_box_text", "cli_box")
  )
}

format_text_box <- function(box, margins = NULL, paddings = NULL,
                            color = NULL, background_color = NULL) {
  stopifnot(inherits(box, "cli_box_text"))

  
}

clii2_inline <- function(text) {
  
}
