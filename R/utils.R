
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
