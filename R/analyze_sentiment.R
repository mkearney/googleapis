
#' inaug45
#'
#' Transcript of Trump's 2017 Inaugural Address tokenized by paragraph.
#'
#' @docType data
#' @keywords datasets
#' @format A character vector consisting of 75 paragraphs.
#' @source https://www.whitehouse.gov/inaugural-address
#' @usage inaug45
"inaug45"

#' analyze_sentiment
#'
#' Conducts and returns results of sentiment analysis using Google Cloud
#'   Natural Language API.
#'
#' @param text Vector of plain text to analyze.
#' @param id Optional, vector of IDs. If provided, length must be equal to
#'   length of text parameter.
#' @return List of parsed response objects.
#' @examples
#'
#' @export
#' @aliases analyse_sentiment
analyze_sentiment <- function(text, id = NULL) {
  eval(call("analyze_sentiment_", text, id))
}


analyze_sentiment_ <- function(text, id = NULL) {
  analyze_sentiment_internal <- function(text) {
    ## API path
    path <- "analyzeSentiment"
    ## format text for request
    jstext <- jsonify_text(text)
    ## execute request
    r <- httr::POST(api_call(path), body = jstext)
    ## parse
    r <- parse_docs(r)
    structure(
      .Data = r,
      class = c("sentiment_analysis", "list"),
      text = text,
      id = id
    )
    ##class(r) <- c("sentiment_analysis", "list")
    ##r
  }
  if (!is.null(id)) {
    stopifnot(length(text) == length(id))
    out <- Map(analyze_sentiment_internal, text, id)
  } else {
    out <- Map(analyze_sentiment_internal, text)
    for (i in seq_along(out)) {
      attr(out[[i]], "id") <- i
    }
  }
  class(out) <- c("sentiment_analysis_list", "list")
  out
}
print
print.sentiment_analysis_list <- function(x, ...) {

}

#' sentiment analysis data frame
#'
#' @param x Data of class sentiment_analysis
#' @return Data frame
#' @export
as.data.frame.sentiment_analysis <- function(x) {
  if (!is.recursive(x)) {
    warning("Sentiment scores not found", call. = FALSE)
  }
  if (!has_name(x, "documentSentiment", "sentences")) {
    return(data.frame())
  }
  doc_score <- x$documentSentiment[["score"]]
  doc_magnitude <- x$documentSentiment[["magnitude"]]
  content <- get_var(x$sentences, "text", "content")
  offset <- get_var(x$sentences, "text", "beginOffset")
  score <- get_var(x$sentences, "sentiment", "score")
  magnitude <- get_var(x$sentences, "sentiment", "magnitude")
  id <- attr(x, "id")
  text <- attr(x, "text")
  lns <- c(
    length(content),
    length(offset),
    length(score),
    length(magnitude)
  )
  if (!all.equal(lns[1], lns[2], lns[3], lns[4])) {
    content <- content[1]
    offset <- offset[1]
    score <- score[1]
    magnitude <- magnitude[1]
  }
  docs <- data.frame(
    id = id,
    unit = "document",
    score = doc_score,
    magnitude = doc_magnitude,
    position = NA_integer_,
    offset = NA_integer_,
    content = text,
    stringsAsFactors = FALSE
  )
  sents <- data.frame(
    id = id,
    unit = "sentence",
    score = score,
    magnitude = magnitude,
    position = seq_along(content),
    offset = offset,
    content = content,
    stringsAsFactors = FALSE
  )
  rbind(docs, sents)
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
