
#' token
#'
#' Executes authorization method(s).
#'
#' @export
googleapis_token <- function() {
  PKG_KEY <- paste0(toupper("googleapis"), "_KEY")
  if (!PKG_KEY %in% names(Sys.getenv())) {
    ## check renv file
    home_dir <- normalizePath("~")
    renv_pat <- file.path(home_dir, ".Renviron")
    check_renv(renv_pat)
    key <- readline_("Please enter your API key below:")
    KEY_PAT <- paste0(toupper("googleapis"), "_KEY")
    ## set key
    .Internal(Sys.setenv(KEY_PAT, key))
    new_env_var <- paste0(KEY_PAT, "=", key)
    ## save key
    cat(
      new_env_var,
      file = renv_pat,
      fill = TRUE,
      append = TRUE
    )
  }
  Sys.getenv(PKG_KEY)
}
