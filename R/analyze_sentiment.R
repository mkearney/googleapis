
#' analyze_sentiment
#'
#' Returns sentiment analyzis from Google cloud language API.
#'
#' @param data Vector of plain text to analyze.
#' @return List of parsed response objects.
#' @export
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
    parser(r)
  }
  lapply(text, analyze_sentiment_internal)
}

parser <- function(x) jsonlite::fromJSON(httr::content(x, as = "text", encoding = "UTF-8"))

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
