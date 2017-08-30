## get variable(s) from nested obj
get_var <- function(x, ...) {
  vars <- c(...)
  success <- FALSE
  for (i in vars) {
    if (!is.recursive(x)) break
    if (has_name(x, i)) {
      x <- x[[i]]
      if (i == vars[length(vars)]) {
        success <- TRUE
      }
    } else if (any_recursive(x)) {
      x <- lapply(x, "[[", i)
      if (i == vars[length(vars)]) {
        success <- TRUE
      }
    }
  }
  if (!success) return(NULL)
  if (length(x) == 0L) return(NA)
  if (any_recursive(x)) {
    return(x)
  }
  unlist(x)
}

any_recursive <- function(x) {
  any(vapply(x, is.recursive, logical(1)))
}

## hase name(s) accepts one or more names (looks for all == TRUE)
has_name <- function(x, ...) {
  vars <- c(...)
  stopifnot(is.character(vars))
  if (!is.recursive(x)) {
    return(FALSE)
  }
  all(vars %in% names(x))
}

## question and answer (choices) for interactive sessions
menuline <- function(q, a) {
  message(q)
  menu(a)
}

## accept line broken chr vector and remove user provided quotes
## for interactive sessions
readline_ <- function(...) {
  input <- readline(paste(c(...), collapse = ""))
  gsub("^\"|^\'|\"$|\'$", "", input)
}

## make sure last line of R environment file has been filled
check_renv <- function(path) {
  if (!file.exists(path)) {
    return(invisible())
  }
  con <- file(path)
  x <- readLines(con, warn = FALSE)
  close(con)
  x <- paste(x, collapse = "\n")
  cat(x, file = path, fill = TRUE)
  invisible()
}

## parse method defaults to parsing individual docs
parse_docs <- function(x, simplify = FALSE) {
  if (simplify) {
    jsonlite::fromJSON(
      httr::content(x, as = "text", encoding = "UTF-8"))
  } else {
    httr::content(x)
  }
}

## prep text
#' @export
#' @noRd
prep_text <- function(x) {
  x <- gsub(
    "@\\S{1,}|http\\S{1,}|\\n", "", x
  )
  x <- gsub(
    "^\\.\\S{0,}", "", x
  )
  trimws(gsub(
    "[ ]{2,}", " ", x
  ))
}
