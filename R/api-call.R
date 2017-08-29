
api_base <- function() {
  baseurl <- getOption("googleapisbaseurl")
  if (baseurl == "" || is.null(baseurl)) {
    options(
      googleapisbaseurl = list(
        scheme = "https",
        base = "language.googleapis.com",
        version = "v1"
      )
    )
  }
  baseurl <- getOption("googleapisbaseurl")
  paste0(baseurl$scheme, "://", baseurl$base, "/", baseurl$version)
}


#' update base url
#'
#' @param scheme http or https
#' @param base base api, e.g., api.twitter.com
#' @param version version string, e.g., v1.1
update_api_base_url <- function(scheme, base, version) {
  abu <- getOption("googleapisbaseurl")
  abu[["scheme"]] <- scheme
  abu[["base"]] <- base
  abu[["version"]] <- version
  options(googleapisbaseurl = abu)
}


#' api_call
#'
#' Composes API requests
#'
#' @param path Specific API hosted at base site.
#' @param ... Other named args are converted as query parameters.
#' @export
#' @noRd
api_call <- function(path, ..., token = NULL) {
  ## add documents: if not already
  if (!grepl("^documents:", path)) {
    path <- paste0("documents:", path)
  }
  ## base URL
  base <- api_base()
  ## params
  params <- c(...)
  params <- params[names(params) != ""]
  ## if no key provided, find it
  if (!"key" %in% names(params) && is.null(token)) {
    params["key"] <- googleapis_token()
  } else if (!"key" %in% names(params) && !is.null(token)) {
    params["key"] <- token
  }
  if (length(params) > 0L) {
    params <- paste(names(params), params, sep = "=")
    params <- paste(params, collapse = "&")
    params <- paste0("?", params)
  }
  ## build complete request
  paste0(base, "/", path, params)
}
