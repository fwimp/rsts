#' Set of Slay the Spire 2 Cards (R6).
#'
#' @description
#' This is the general holding class for a set of sts2 Cards.
#' It stores the main card data for the player.
#'
STS2Deck <- R6Class("STS2Deck",
  public = list(
    #' @field player The `STS2Player` object this deck belongs to.
    player = NULL,

    #' @field cards A list of cards.
    cards = character(),

    #' @field floorfound The floors upon which the cards were found.
    floorfound = numeric(),

    #' @field upgradelevel The upgrade level of each card.
    upgradelevel = numeric(),

    #' @field enchantments The enchantments assigned to each card
    enchantments = character(),

    #' @field enchantamt The amount of an enchantment assigned to each card
    enchantamt = numeric(),
    #' @description
    #' Create a new deck object from player data.
    #'
    #' @param carddata The subset of the list output from jsonlite, usually passed in via `STS2Player`.
    #' @param player The `STS2Player` object this deck belongs to.
    #' @returns A new `STS2Cards` object.
    #'
    initialize = function(carddata, player = NULL) {
      # browser()
      if (length(carddata) > 0) {
        # TODO: rework so that card internal data is split out
        # This will allow us to deal with situations where they are not present
        # Could also consider making sure floors remember what number floor they actually are (somehow).
        # Alternatively could use "card_choices" to rebuild picked cards.
        card_internal_data <- sapply(carddata, \(x){x[c("floor_added_to_deck", "id")]})
        card_upgrade_level <- sapply(carddata, \(x){unlist(x["current_upgrade_level"]) %||% 0})
        self$floorfound <- as.numeric(card_internal_data[1,])
        self$cards <- format_sts2id(as.character(card_internal_data[2,]))
        names(card_upgrade_level) <- NULL
        self$upgradelevel <- as.numeric(card_upgrade_level)
        enchantments_tmp <- lapply(carddata, \(x){x$enchantment %||% list(amount = 0, id = "")})
        self$enchantments <- format_sts2id(sapply(enchantments_tmp, \(x) {x$id}))
        self$enchantamt <- sapply(enchantments_tmp, \(x) {x$amount})
        # TODO: Could remove character name from cards (e.g. Strike Defect -> Strike)
        self$player <- player
      }
    },
    #' @description
    #' Print an `STS2Cards` object.
    #'
    #' @param ... Unused.
    #' @param floor Whether to show the floor on which a card was obtained.
    #'
    #' @returns Nothing (called for side-effect)
    #'
    print = function(..., floor = FALSE) {
      if (length(self) < 1) {
        cli::cli_text("No cards present!")
      }
      floorfound <- ""
      if (floor) {
        floorfound <- paste0(" (", self$floorfound, ")")
      }

      # create colourmap based upon upgradelevel and enchantment
      colmap <- list(cli::col_white, cli::col_green, cli::col_magenta)

      cols <- ifelse(
        self$upgradelevel > 0,
        1,
        0
      )
      cols <- ifelse(
        !is.na(self$enchantments),
        2,
        cols
      )

      out <- ifelse(
        self$upgradelevel > 0,
        paste0(self$cards, sapply(self$upgradelevel, \(x) {if (x > 0) {rep("+", x)} else {""}})),
        self$cards
        )

      out <- ifelse(
        !is.na(self$enchantments),
        paste0(self$cards, sapply(self$enchantments, \(x) {if (!is.na(x)) {paste0(" (", x, ")")} else {""}})),
        out
      )

      out <- paste0(out, floorfound)

      out_final <- c()
      for (i in 1:length(out)) {
        out_final <- c(out_final, colmap[[cols[i]+1]](out[i]))
      }

      out_final <- sort_by(out_final, cols, decreasing = TRUE)

      cli::cli_bullets(out_final)
    }
  ),
  private = list(
  )
)

#' @export
length.STS2Deck <- function(x) {
  length(x$cards)
}
