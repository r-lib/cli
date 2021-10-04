
#' MD5 hash
#'
#' Calculate the MD5 hash of each element of a character vector.
#'
#' @param x Character vector. If not a character vector, then
#' [as.character()] is used to try to coerce it into one. `NA` entries
#' will have an `NA` hash.
#' @return Character vector of hexadecimal MD5 hashes.
#'
#' @family hash functions
#' @seealso [tools::md5sum()] for a base R MD5 function that works on
#' files.
#'
#' @export
#' @examples
#' hash_md5(c("foo", NA, "bar", ""))

hash_md5 <- function(x) {
  if (!is.character(x)) x <- as.character(x)
  na <- is.na(x)
  x[na] <- NA_character_
  x[!na] <- .Call(clic_md5, x[!na])
  x
}

#' Emoji hash
#'
#' @details
#' It uses the first 13 hexadecimal characters (out of the 32) of the MD5
#' hash of the input, and converts them into an emoji representation.
#' It uses a manually selected subset of all emojis, that tend to be
#' displated correctly.
#'
#' ## Number of possible hash values
#'
#' ```{r include = FALSE}
#' hf <- function(size) {
#'   format(nrow(emojis)**size, big.mark = ",", scientific = FALSE)
#' }
#' ```
#'
#' cli uses `r nrow(emojis)` possible emojis. This is the number of
#' different hashes you can get for different values of `size`:
#'
#' | `size` | size of hash table space |
#' | -----: | -----------------------: |
#' | 1      | `r hf(1)`                |
#' | 2      | `r hf(2)`                |
#' | 3      | `r hf(3)`                |
#' | 4      | `r hf(4)`                |
#'
#' @param x Character vector. `NA` entries will have an `NA` hash.
#' @param size Number of emojis to use in a hash. Currently it has to
#'   be between 1 and 4.
#' @return A data frame with columns
#'   * `hash`: the emoji hash, a string of the requested size.
#'   * `emojis`: list column with the emoji characters in character
#'     vectors. Note that an emoji might have multiple code points.
#'   * `text`: text representation of `hash`, comma separated.
#'   * `names`: list column with the text representations of `emojis`, in
#'     character vectors.
#'
#' @family hash functions
#' @seealso the emoji package for a comprehensive list of emojis
#' @export
#' @examples
#' hash_emoji(c("foo", NA, "bar", ""))$text
#'
#' # if you increase `size`, the shorter hash is a prefix of the longer:
#' hash_emoji("foobar", 1)$text
#' hash_emoji("foobar", 2)$text
#' hash_emoji("foobar", 3)$text
#' hash_emoji("foobar", 4)$text

hash_emoji <- function(x, size = 3) {
  # our integer arithmetic does not work if size > 4
  stopifnot(
    is.character(x),
    is_count(size),
    size >= 1 && size <= 4
  )

  hashes <- lapply(x, hash_emoji1, size = size)
  emojis <- lapply(hashes, "[[", "emoji")
  names <- lapply(hashes, "[[", "names")

  data.frame(
    stringsAsFactors = FALSE,
    hash = vapply(emojis, collapse, character(1)),
    emojis = I(emojis),
    text = vapply(names, collapse, character(1), sep = ", "),
    names = I(names)
  )
}

collapse <- function(x, sep = "") {
  if (anyNA(x)) {
    NA_character_
  } else {
    paste(x, collapse = sep)
  }
}

hash_emoji1 <- function(x, size = 3) {
  if (is.na(x)) {
    return(list(
      emoji = rep(NA_character_, size),
      names = rep(NA_character_, size)
    ))
  }

  md5 <- hash_md5(x)

  md513 <- substr(md5, 1, 13)
  mdint <- as.integer(as.hexmode(strsplit(md513, "")[[1]]))
  hash <- sum(mdint * 16^(0:12))

  base <- nrow(emojis)
  ehash <- hash %% (base ** size)
  digits <- integer()
  while (ehash > 0) {
    digits <-  c(digits, ehash %% base)
    ehash <- ehash %/% base
  }
  digits <- c(digits, rep(0, 10))[1:size]

  nms <- emojis$name[digits + 1]
  emo <- emojis$emoji[digits + 1]

  list(
    emoji = emo,
    names = nms
  )
}

#' Adjective-animal hash
#'
#' @details
#' It uses the first 13 hexadecimal characters (out of the 32) of the MD5
#' hash of the input, and converts them into an adjective-animal form to
#' create a human readable hash.
#'
#' ## Number of possible hash values
#'
#' ```{r include = FALSE}
#' hf <- function(n_adj) {
#'   format(
#'     length(gfycat_adjectives) ** n_adj * length(gfycat_animals),
#'     big.mark = ",",
#'     scientific = FALSE
#'   )
#' }
#' ```
#'
#' `hash_animals()` uses `r length(gfycat_animals)` animal names and
#' `r length(gfycat_adjectives)` different adjectives. The number of
#' different hashes you can get for different values of `n_adj`:
#'
#' | `n_adj` | size of the hash table space |
#' | ------: | ---------------------------: |
#' | 0       | `r hf(0)`                    |
#' | 1       | `r hf(1)`                    |
#' | 2       | `r hf(2)`                    |
#' | 3       | `r hf(3)`                    |
#'
#' ## Source
#'
#' The list of adjectives and animals comes from the ids package,
#' and in turn from
#' <https://github.com/a-type/adjective-adjective-animal>, and
#' from <https://gfycat.com>.
#'
#' @param x Character vector. `NA` entries will have an `NA` hash.
#' @param n_adj Number of adjectives to use. It must be between 0 and 3.
#' @return A data frame with columns
#'   * `hash`: the hash value, a string.
#'   * `words`: list column with the adjectives and the animal name in a
#'     character vector.
#'
#' @family hash functions
#' @seealso the ids package for generating random adjective-animal ids
#'
#' @export
#' @examples
#' hash_animal(c("foo", "bar"))
#'
#' # if you increase `n_adj`, the shorter hash is a suffix of the longer:
#' hash_animal("cli package", 0)$hash
#' hash_animal("cli package", 1)$hash
#' hash_animal("cli package", 2)$hash
#' hash_animal("cli package", 3)$hash

hash_animal <- function(x, n_adj = 2) {
  stopifnot(
    is.character(x),
    is_count(n_adj),
    n_adj >= 0 && n_adj <= 3
  )

  hashes <- lapply(x, hash_animal1, n_adj = n_adj)

  data.frame(
    stringsAsFactors = FALSE,
    hash = vapply(hashes, collapse, character(1), sep = " "),
    words = I(hashes)
  )
}

hash_animal1 <- function(x, n_adj = 2) {
  if (is.na(x)) {
    return(rep(NA_character_, n_adj + 1))
  }

  md5 <- hash_md5(x)

  md513 <- substr(md5, 1, 13)
  mdint <- as.integer(as.hexmode(strsplit(md513, "")[[1]]))
  hash <- sum(mdint * 16^(0:12))

  len_ani <- length(gfycat_animals)
  len_adj <- length(gfycat_adjectives)
  ehash <- hash %% (len_adj ** n_adj * len_ani)
  digits <- ehash %% len_ani
  ehash <- ehash %/% len_ani

  while (ehash > 0) {
    digits <- c(digits, ehash %% len_adj)
    ehash <- ehash %/% len_adj
  }
  digits <- c(digits, rep(0, 10))[1:(n_adj + 1)]
  digits <- rev(digits)

  c(
    gfycat_adjectives[digits[-length(digits)] + 1],
    gfycat_animals[digits[length(digits)] + 1]
  )
}
