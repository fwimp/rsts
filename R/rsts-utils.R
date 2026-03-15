#' Format sts2 ids to a prettier form.
#'
#' @param id The id/s to format.
#'
#' @note
#' This assumes that ids have only 1 "." character.
#'
#' @returns The formatted ids.
#' @keywords internal
format_sts2id <- function(id) {
  stringr::str_to_title(stringr::str_replace_all(stringr::str_split_i(id, "\\.", 2), "_", " "))
}

#' Get field from a list of runs (or players)
#'
#' @param x A list of [STS2Run] or [STS2Player] objects.
#' @param fieldname The name of the field to retrieve.
#'
#' @returns The formatted ids.
#' @keywords internal
get_field <- function(x, fieldname) {
  stopifnot(is.character(fieldname))
  sapply(x, \(y) {y[[fieldname]]})
}

.sort_version <- function(x) {
  order(numeric_version(gsub("v", "", x)))
}

.compare_version <- function(x, cond, val) {
  cond <- match.arg(cond, c("==", "!=", ">", "<", ">=", "<="))
  x_ver <- numeric_version(gsub("v", "", x))
  val_ver <- numeric_version(gsub("v", "", val))
  do.call(cond, list(x_ver, val_ver))
}

.find_common_ids <- function(runhistory) {
  players <- runhistory$get_player_data()
  table(get_field(players, "id"))
}
