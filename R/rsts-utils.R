#' Format sts2 ids to a prettier form.
#'
#' @param id
#'
#' @note
#' This assumes that ids have only 1 "." character.
#'
#' @returns The formatted ids.
#' @keywords internal
format_sts2id <- function(id) {
  stringr::str_to_title(stringr::str_replace_all(stringr::str_split_i(id, "\\.", 2), "_", " "))
}
