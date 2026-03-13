#' Slay the Spire 2 player (R6).
#'
#' @description
#' This is the general holding class for an sts2 player.
#' It stores the main player data for the run.
#'
STS2Player <- R6Class("STS2Player",
  public = list(
    #' @field run The [STS2Run] object that this player object originates from.
    run = NULL,

    #' @field playercharacter The character that the player was playing
    playercharacter = "",

    #' @field deck The deck of the player at the end of the run. An [STS2Deck] object.
    deck = list(),

    #' @field id The steam player id or 1 if single player.
    id = "",

    #' @field max_potion_slot_count The maximum number of potions a player could hold.
    max_potion_slot_count = 0,

    #' @field potions The potions held by the player at the end of the run.
    potions = character(),

    #' @field relics The relics held by the player at the end of the run. An [STS2Relics] object
    relics = NULL,

    #' @description
    #' Create a new run object from player data.
    #'
    #' @param playerdata The subset of the list output from jsonlite, usually passed in via [STS2Run].
    #' @param run The STS2Run object that this player object originates from.
    #' @param idx The index within the player list from which this player originates.
    #' @returns A new [STS2Player] object.
    #'
    initialize = function(playerdata, run = NULL, idx = 1) {
      self$playercharacter <- format_sts2id(playerdata$character)
      self$deck <- STS2Deck$new(playerdata$deck, player = self)
      self$id <- as.character(playerdata$id)
      private$.idx <- idx
      self$max_potion_slot_count <- playerdata$max_potion_slot_count
      if (length(playerdata$potions) > 0) {
        self$potions <- format_sts2id(unlist(simplify2array(playerdata$potions)[1,]))
      }
      self$relics <- STS2Relics$new(playerdata$relics, player = self)
      self$run <- run
    },

    #' @description
    #' Print an [STS2Player] object.
    #'
    #' @param ... Arguments to pass to `print()`.
    #' @param full Whether to show the full deck and relics of the player.
    #' @param floor Whether to show the floor on which a card/relic was obtained when `full = TRUE`.
    #'
    print = function(..., full = FALSE, floor = FALSE) {
      # charcolour <- c("Ironclad" = cli::col_red, "Silent" = cli::col_green, "Regent" = cli::col_yellow, "Necrobinder" = cli::col_magenta, "Defect" = cli::col_blue)
      # charcolfn <- charcolour[[self$playercharacter]]

      cli::cli_text(cli::style_bold(col_character(self$playercharacter)))
      cli::cli_text("HP: {cli::col_red(self$max_health)}")
      cli::cli_text("Deck: {length(self$deck)} card{?s}")
      cli::cli_text("Relics: {length(self$relics)}")
      cli::cli_text("Potions: {length(self$potions)}")
      if (full) {
        cli::cli_h2("Relics")
        print(self$relics, floor = floor)
        cli::cli_h2("Deck")
        print(self$deck, floor = floor)
      }
    }
  ),
  private = list(
    .idx = 0,
    find_max_health = function() {
      private$.max_health <- self$run$map$floors[[length(self$run$map$floors)]]$player_stats[[private$.idx]]$max_hp
      return(invisible(self))
    },
    .max_health = NULL
  ),
  active = list(
    #' @field max_health The max health of the character at the end of the run.
    max_health = function() {
      # Note this only works when the [STS2Map] class has been initialised.
      # As such this is sort of a deferred-calculation system
      if (is.null(private$.max_health)) {
        private$find_max_health()
      }
      private$.max_health
    }
  )
)
