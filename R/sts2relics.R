#' Set of Slay the Spire 2 relics (R6).
#'
#' @description
#' This is the general holding class for a set of sts2 relics.
#' It stores the main relic data for the player.
#'
STS2Relics <- R6Class("STS2Relics",
  public = list(
    #' @field player The `STS2Player` object these relics belong to.
    player = NULL,
    #' @field relicnames A list of relics.
    relicnames = character(),

    #' @field floorfound The floors upon which the relics were found.
    floorfound = numeric(),

    #' @field extra_data The extra_data associated with the relics (unparsed)
    extra_data = list(),

    #' @description
    #' Create a new relics object from player data.
    #'
    #' @param relicdata The subset of the list output from jsonlite, usually passed in via `STS2Player`.
    #' @param player The `STS2Player` object these relics belong to.
    #' @returns A new `STS2Relics` object.
    #'
    initialize = function(relicdata, player = NULL) {
      if (length(relicdata) > 0) {
        self$floorfound <- as.numeric(sapply(relicdata, \(x){x[1]}))
        self$relicnames <- format_sts2id(as.character(sapply(relicdata, \(x){x[2]})))
        self$extra_data <- lapply(relicdata, \(x){x[-c(1,2)]})
        self$player <- player
      }
    },

    #' @description
    #' Print an `STS2Relics` object.
    #'
    #' @param ... Unused.
    #' @param floor Whether to show the floor on which a card was obtained.
    #'
    #' @returns Nothing (called for side-effect)
    #'
    print = function(..., floor = FALSE) {
      floorfound <- ""
      if (floor) {
        floorfound <- paste0(" (", self$floorfound, ")")
      }

      cli::cli_bullets(cli::col_white(paste0(self$relicnames, floorfound)))
    }
  ),
  private = list(
  )
)

#' @export
length.STS2Relics <- function(x) {
  length(x$relicnames)
}
