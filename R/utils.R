any_recursive <- function(x) any(vapply(x, is.recursive, logical(1)))

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


has_name <- function(x, ...) {
  vars <- c(...)
  stopifnot(is.character(vars))
  if (!is.recursive(x)) {
    return(FALSE)
  }
  all(vars %in% names(x))
}


menuline <- function(q, a) {
  message(q)
  menu(a)
}

readline_ <- function(...) {
  input <- readline(paste(c(...), collapse = ""))
  gsub("^\"|\"$", "", input)
}

check_renv <- function(path) {
  con <- file(path)
  x <- readLines(con, warn = FALSE)
  close(con)
  x <- paste(x, collapse = "\n")
  cat(x, file = path, fill = TRUE)
  invisible()
}

make_ids <- function(n) {
  f <- function() {
    ids <- sample(c(letters, toupper(letters), 0:9, 0:9), 8, replace = TRUE)
    paste(ids, collapse = "")
  }
  ids <- unique(unlist(replicate(n, f(), simplify = FALSE)))
  if (length(ids) < n) {
    ids <- unique(unlist(replicate(f, n + 5L, simplify = FALSE)))
    ids <- sample(ids, n)
  }
  ids
}
