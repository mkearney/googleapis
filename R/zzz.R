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
