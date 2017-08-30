
#' analyze_sentiment
#'
#' Returns sentiment analyzis from Google cloud language API.
#'
#' @param data Vector of plain text to analyze.
#' @return List of parsed response objects.
#' @export
#' @aliases analyse_sentiment
analyze_sentiment <- function(data) {
  eval(call("analyze_sentiment_", data))
}

analyze_sentiment_ <- function(text) {
  analyze_sentiment_internal <- function(text) {
    ## API path
    path <- "analyzeSentiment"
    ## format text for request
    text <- jsonify_text(text)
    ## execute request
    r <- httr::POST(api_call(path), body = text)
    ## parse
    r <- parse_docs(r)
    class(r) <- c("sentiment_analysis", "list")
    r
  }
  out <- lapply(text, analyze_sentiment_internal)
  class(out) <- c("sentiment_analysis_list", "list")
  out
}

#' sentiment analysis data frame
#'
#' @param data Data of class sentiment_analysis
#' @return Data frame
#' @export
as.data.frame.sentiment_analysis <- function(x) {
  if (!is.recursive(x)) {
    warning("Sentiment scores not found", call. = FALSE)
  }
  if (!has_name(x, "documentSentiment", "sentences")) {
    return(data.frame())
  }
  document <- x$documentSentiment[["score"]]
  content <- get_var(x$sentences, "text", "content")
  offset <- get_var(x$sentences, "text", "beginOffset")
  score <- get_var(x$sentences, "sentiment", "score")
  if (!all.equal(length(content), length(offset), length(score))) {
    content <- content[1]
    offset <- offset[1]
    score <- score[1]
  }
  data.frame(
    id = make_ids(1),
    document = document,
    sentence = seq_along(content),
    offset = offset,
    score = score,
    content = content,
    stringsAsFactors = FALSE
  )
}

#' @export
as.data.frame.sentiment_analysis_list <- function(x) {
  do.call("rbind", lapply(x, as.data.frame.sentiment_analysis))
}
#' @export
as.tibble.sentiment_analysis_list <- function(x) {
  do.call("rbind", lapply(x, as_tibble.sentiment_analysis))
}
#' @export
as_tibble.sentiment_analysis_list <- function(x) {
  do.call("rbind", lapply(x, as_tibble.sentiment_analysis))
}

#' sentiment analysis tbl
#'
#' @param data Data of class sentiment_analysis
#' @return A tbl
#' @export
as_tibble.sentiment_analysis <- function(data) {
  data <- as.data.frame(data)
  tibble::as_tibble(data, validate = FALSE)
}

parse_docs <- function(x, simplify = FALSE) {
  if (simplify) {
    jsonlite::fromJSON(
      httr::content(x, as = "text", encoding = "UTF-8"))
  } else {
    httr::content(x)
  }
}

jsonify_text <- function(text) {
  lst <- list(
    encodingType = "UTF8",
    document = list(
      type = "PLAIN_TEXT",
      content = text
    )
  )
  jsonlite::toJSON(
    lst,
    pretty = TRUE,
    auto_unbox = TRUE
  )
}
