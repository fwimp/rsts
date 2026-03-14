#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @importFrom R6 R6Class
#' @importFrom rlang %||%
#' @importFrom rlang .data
# %||% is base R as of 4.4.0, however until that's more commonly used, we should import from rlang
## usethis namespace: end
NULL

#' @title Force R CMD CHECK to treat packages as imported.
#'
#' @note
#' This allows us to force dependencies to be considered in the package (particularly necessary with R6 classes).
#' @return Nothing
#' @keywords internal
#'
.ignore_unused_imports <- function() {
  lubridate::seconds_to_period(1)
  invisible()
}
