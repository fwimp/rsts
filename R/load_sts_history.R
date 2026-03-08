#' Load Slay the Spire 2 Run Data
#'
#' @param path The path to your installation.
#' @param profile_num Which profile to retrieve data for (or NULL to retrieve all).
#' @param game Which game to retrieve run data for (2 = STS2, 1 = STS), currently only STS2 is implemented.
#'
#' @returns The parsed run data.
#' @export
#'
#' @examples
#' load_sts2_history()
load_sts_history <- function(path = NULL, profilenum = NULL, game = 2) {
  # Runs are located at C:\Program Files (x86)\Steam\steamapps\common\SlayTheSpire\runs\<CHARACTER> on windows for STS1.
  # Runs are located at %APPDATA%/Roaming/SlayTheSpire2/steam/<ID?>/profile<x>/saves/history on windows for STS2.
  invisible()
}
