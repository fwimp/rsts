
#' Colour text in an Ironclad-based theme.
#'
#' @returns An ironclad-themed colour function.
#' @export
#'
#' @examples
#' col_ironclad("Ironclad-themed text")
col_ironclad <- cli::col_red
# col_ironclad <- cli::make_ansi_style("#AA2222")

#' Colour text in an Silent-based theme.
#'
#' @returns A silent-themed colour function.
#' @export
#'
#' @examples
#' col_silent("Silent-themed text")
col_silent <- cli::make_ansi_style("#648E44")

#' Colour text in an Regent-based theme.
#'
#' @returns A regent-themed colour function.
#' @export
#'
#' @examples
#' col_regent("Regent-themed text")
col_regent <- cli::make_ansi_style("#C07609")

#' Colour text in an Necrobinder-based theme.
#'
#' @returns A necrobinder-themed colour function.
#' @export
#'
#' @examples
#' col_necrobinder("Necrobinder-themed text")
col_necrobinder <- cli::make_ansi_style("#B16580")

#' Colour text in an Defect-based theme.
#'
#' @returns A defect-themed colour function.
#' @export
#'
#' @examples
#' col_defect("Defect-themed text")
col_defect <- cli::make_ansi_style("#2679A3")


#' Colour text in an character-based theme.
#'
#' @param char The character colour to use.
#' @param text The text to theme (or `NULL` if you just want to use "char").
#'
#' @returns A defect-themed colour function.
#' @export
#'
#' @examples
#' col_character("Ironclad")
#' col_character("Silent", "Other text")
col_character <- function(char, text = NULL) {
  do.call(paste0("col_", tolower(char)), args = list(text %||% char))
}

.test_cols <- function(){
  print(col_ironclad("Ironclad"))
  print(col_silent("Silent"))
  print(col_regent("Regent"))
  print(col_necrobinder("Necrobinder"))
  print(col_defect("Defect"))
}
