#' R6 Class representing a Slay the Spire 2 run.
#'
#' @description
#' This is the general holding class for an sts2 run.
#' It stores the main metadata and lists containing more in-depth run data.
#'
#'

STS2Run <- R6Class("STS2Run",
  public = list(
    #' @field acts A vector of the acts that the player encountered.
    acts = character(),

    #' @field ascension The ascension level of the run.
    ascension = 0,

    #' @field build_id The build of the game that this run was generated from.
    build_id = "",

    #' @field game_mode The game mode that the player was playing.
    game_mode = "",

    #' @field killed_by_encounter The encounter that killed the player.
    killed_by_encounter = "",

    #' @field killed_by_event The event that killed the player.
    killed_by_event = "",

    #' @field map_point_history A list storing the play-by-play of the run.
    map_point_history = list(),

    #' @field modifiers Any modifiers that the player had turned on.
    modifiers = list(),

    #' @field platform_type The platform of the game (e.g. steam).
    platform_type = "",

    #' @field players A list of player information.
    players = list(),

    #' @field run_time The run duration (in seconds).
    run_time = 0,

    #' @field schema_version The run schema version.
    schema_version = 0,

    #' @field seed The seed of the run.
    seed = "",

    #' @field start_time The start time (in seconds from unix epoch).
    start_time = 0,

    #' @field was_abandoned Whether the player abandoned the run.
    was_abandoned = FALSE,

    #' @field win Whether the player won the run.
    win = FALSE,

    #' @description
    #' Create a new run object from data parsed with jsonlite.
    #'
    #' @param rundata The list output from jsonlite containing the run data.
    #' @returns A new `STS2Run` object.
    #'
    initialize = function(rundata) {
      self$acts <- format_sts2id(as.character(rundata$acts))
      self$ascension <- rundata$ascension
      self$build_id <- rundata$build_id
      self$game_mode <- rundata$game_mode
      self$killed_by_encounter <- ifelse(rundata$killed_by_encounter == "NONE.NONE", NA, format_sts2id(rundata$killed_by_encounter))
      self$killed_by_event <- ifelse(rundata$killed_by_event == "NONE.NONE", NA, format_sts2id(rundata$killed_by_event))
      self$map_point_history <- rundata$map_point_history
      self$modifiers <- rundata$modifiers
      self$platform_type <- rundata$platform_type
      self$players <- lapply(rundata$players, \(x) {STS2Player$new(x, run = self)})
      self$run_time <- rundata$run_time
      self$schema_version <- rundata$schema_version
      self$seed <- rundata$seed
      self$start_time <- rundata$start_time
      self$was_abandoned <- rundata$was_abandoned
      self$win <- rundata$win
    },

    #' @description
    #' Print an `STS2Run` object.
    #'
    #' @param ... Arguments to pass to `print()`.
    #' @param full Whether to print extra internal run information.
    #'
    print = function(..., full = FALSE) {
      cat(paste0("Seed ", self$seed, " @ Ascension ", self$ascension, "\n"))
      if (self$game_mode != "standard") {
        cat(paste0("Gamemode: ", self$game_mode, "\n"))
      }
      cat(paste0("Start: ", as.POSIXlt(self$start_time), "\n"))
      cat(paste0("Duration: ", strftime(as.POSIXct("00:00:00", format="%H:%M:%S") + self$run_time, format="%H:%M:%S"), "\n"))

      outcome <- if (self$win) {"Win"} else if (self$was_abandoned) {"Abandoned"} else {"Loss"}
      cat(paste0("Outcome: ", outcome, "\n"))

      if (!is.na(self$killed_by_encounter)) {
        cat(paste0("Killed by encounter: ", self$killed_by_encounter, "\n"))
      }

      if (!is.na(self$killed_by_event)) {
        cat(paste0("Killed by event: ", self$killed_by_event, "\n"))
      }

      if (full) {
        cat(paste0("\n========== EXTRA DATA ==========\n"))
        if (self$game_mode == "standard") {
          cat(paste0("Gamemode: ", self$game_mode, "\n"))
        }
        cat(paste0("Build ID: ", self$build_id, "\n"))
        cat(paste0("Platform: ", self$platform, "\n"))
        cat(paste0("Schema Version:: ", self$schema_version, "\n"))
      }
      invisible(self)
    }
  ),
  private = list(
  )
)

#' R6 Class representing a Slay the Spire 2 player.
#'
#' @description
#' This is the general holding class for an sts2 player.
#' It stores the main player data for the run.
#'
STS2Player <- R6Class("STS2Player",
  public = list(
    #' @field run The `STS2Run` object that this player object originates from.
    run = NULL,

    #' @field character The character that the player was playing
    character = "",

    #' @field deck The deck of the player at the end of the run.
    deck = list(),

    #' @field id The internal player id within the run.
    id = 0,

    #' @field max_potion_slot_count The maximum number of potions a player could hold.
    max_potion_slot_count = 0,

    #' @field potions The potions held by the player at the end of the run.
    potions = character(),

    #' @field relics The relics held by the player at the end of the run.
    # TODO: Check what happens with removed relics.
    relics = NULL,

    #' @field max_health The max health of the character at the end of the run.
    max_health = 0,

    #' @description
    #' Create a new run object from player data.
    #'
    #' @param playerdata The subset of the list output from jsonlite, usually passed in via `STS2Run`.
    #' @param run The STS2Run object that this player object originates from.
    #' @returns A new `STS2Player` object.
    #'
    initialize = function(playerdata, run = NULL) {
      self$character <- format_sts2id(playerdata$character)
      self$deck <- STS2Deck$new(playerdata$deck)
      self$id <- playerdata$id
      self$max_potion_slot_count <- playerdata$max_potion_slot_count
      if (length(playerdata$potions) > 0) {
        self$potions <- format_sts2id(unlist(simplify2array(playerdata$potions)[1,]))
      }
      self$relics <- STS2Relics$new(playerdata$relics)
      self$run <- run
      # Find max health
      private$find_max_health()
    }
  ),
  private = list(
    find_max_health = function() {
      # This Should be refactored once map history classes etc. are created.
      act_reached <- length(self$run$map_point_history)
      act_floor_reached <- length(self$run$map_point_history[[act_reached]])
      self$max_health <- self$run$map_point_history[[act_reached]][[act_floor_reached]]$player_stats[[self$id]]$max_hp
      invisible(self)
    }
  )
)

#' R6 Class representing a set of Slay the Spire 2 relics.
#'
#' @description
#' This is the general holding class for a set of sts2 relics.
#' It stores the main relic data for the player.
#'
STS2Relics <- R6Class("STS2Relics",
  public = list(
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
    #' @returns A new `STS2Relics` object.
    #'
    initialize = function(relicdata) {
      if (length(relicdata) > 0) {
        self$floorfound <- as.numeric(sapply(relicdata, \(x){x[1]}))
        self$relicnames <- format_sts2id(as.character(sapply(relicdata, \(x){x[2]})))
        self$extra_data <- lapply(relicdata, \(x){x[-c(1,2)]})
      }
    }
  ),
  private = list(
  )
)

#' R6 Class representing a set of Slay the Spire 2 Cards.
#'
#' @description
#' This is the general holding class for a set of sts2 Cards.
#' It stores the main card data for the player.
#'
STS2Deck <- R6Class("STS2Deck",
  public = list(
    #' @field cards A list of cards.
    cards = character(),

    #' @field floorfound The floors upon which the cards were found.
    floorfound = numeric(),

    #' @field upgradelevel The upgrade level of each card.
    upgradelevel = numeric(),

    #' @description
    #' Create a new relics object from player data.
    #'
    #' @param carddata The subset of the list output from jsonlite, usually passed in via `STS2Player`.
    #' @returns A new `STS2Cards` object.
    #'
    initialize = function(carddata) {
      if (length(carddata) > 0) {
        card_internal_data <- sapply(carddata, \(x){x[c("floor_added_to_deck", "id")]})
        card_upgrade_level <- sapply(carddata, \(x){unlist(x["current_upgrade_level"]) %||% 0})
        names(card_upgrade_level) <- NULL
        self$upgradelevel <- card_upgrade_level
        self$floorfound <- as.numeric(card_internal_data[1,])
        self$cards <- format_sts2id(as.character(card_internal_data[2,]))
        # TODO: Could remove character name from cards (e.g. Strike Defect -> Strike)

      }
    }
  ),
  private = list(
  )
)
