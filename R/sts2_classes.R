#' Slay the Spire 2 run history (R6).
#'
#' @description
#' This is the general holding class for a full history of sts2 runs.
#'
#' It can be indexed like a list (i.e. `x[1]` or `x[[1]]`).
#'
STS2RunHistory <- R6Class("STS2RunHistory",
  public = list(
  #' @field runs The parsed run logs. A list of `STS2Run` objects.
  runs = list(),
  #' @field ownerid The steam ID of the run history owner.
  ownerid = "",
  #' @field filtersteps The filtering steps performed on this run history.
  filtersteps = NULL,

  #' @description
  #' Create a new run history container from a list of `STS2Run` objects.
  #'
  #' @param historydata A list of `STS2Run` objects.
  #' @param steamid The owner's steamid (for differentiating in the case of multiplayer runs).
  #' @param filtersteps The filtering steps performed on this run history.
  #'
  #' @returns A new `STS2RunHistory` object.
  #'
  initialize = function(historydata, steamid = NULL, filtersteps = NULL) {
    self$runs <- historydata
    self$ownerid <- as.character(steamid)
    self$filtersteps = filtersteps
  },

  #' @description
  #' Print an `STS2RunHistory` object.
  #'
  #' @param ... Unused.
  #'
  #' @returns Nothing (called for side-effect)
  #'
  print = function(...) {
    cli::cli_text("Run history for ID {self$ownerid}:\n")
    if (!is.null(self$filtersteps)) {

      cli::cli_ol(self$filtersteps)
    }
    for (x in self$runs) {
      print(x)
      cli::cli_text("")
    }
  },

  #' @description
  #' Retrieve player data for a given player from runs.
  #'
  #' @param id The Steam ID of the player data to retrieve (or `NULL` to retrieve the data of the run owner).
  #' @param excludemissing Exclude entries from the list where the desired player is not present. (This will result in a list that may be shorter than the number of runs in the history.)
  #'
  #'  @returns A list of `STS2Player` objects.
  #'
  get_individual_player_data = function(id = NULL, excludemissing = TRUE) {
    if (is.null(id)) {
      id <- self$ownerid
      if (is.null(id)) {
        cli::cli_abort("Owner ID not present, nor supplied in an argument.")
      }
    }
    id <- as.character(id)
    found_playerdata <- lapply(self$runs, \(x) {
      x$get_individual_player_data(id)
    })
    if (excludemissing) {
      found_playerdata <- found_playerdata[which(!sapply(found_playerdata, is.null))]
    }
    return(found_playerdata)
  },

  #' @description
  #' Retrieve data for character/s across the run history.
  #'
  #' @param char The character/s to retrieve data for.
  #' @param onlyowner If TRUE, only retrieve runs where the owner was the character specified.
  #'
  #' @returns A list of `STS2Player` objects containing only selected characters.
  #'
  get_character = function(char, onlyowner = FALSE) {
    poss_chars <- c("ironclad", "silent", "regent", "necrobinder", "defect")
    char <- tolower(char)
    char <- char[char %in% poss_chars]
    found_playerdata <- sapply(self$runs, \(x) {x$get_character(char, onlyowner = onlyowner)})
    unlist(found_playerdata[which(sapply(found_playerdata, \(x) {length(x) > 0}))])
  },

  #' @description
  #' Retrieve runs by seed.
  #'
  #' @param seed The seed (or seeds) that one wishes to retrieve.
  #' @param .filtertext The text to add to the filter list (mostly used internally).
  #'
  #' @returns An `STS2RunHistory` object containing only selected seeds.
  #'
  #' @note
  #' `STS2Run` objects are passed by reference. As such if you modify a run in a filtered history, those changes will appear in the original list.
  #'
  get_run_byseed = function(seed, .filtertext = "filtered by seed") {
    STS2RunHistory$new(
      self$runs[sapply(self$runs, \(x) {x$seed %in% seed})],
      steamid = self$ownerid,
      filtersteps = c(self$filtersteps, .filtertext)
      )
  },

  #' @description
  #' Retrieve runs containing character/s across the run history.
  #'
  #' @param char The character/s to retrieve data for.
  #' @param onlyowner If TRUE, only retrieve runs where the owner was the character specified.
  #' @param .filtertext The text to add to the filter list (mostly used internally).
  #'
  #' @returns An `STS2RunHistory` object containing only selected seeds.
  #'
  #' @note
  #' `STS2Run` objects are passed by reference. As such if you modify a run in a filtered history, those changes will appear in the original list.
  #'
  get_run_bycharacter = function(char, onlyowner = FALSE, .filtertext = "filtered by character") {
    runs_with_character <- self$get_character(char, onlyowner = onlyowner)
    seeds <- unique(sapply(runs_with_character, \(x) x$run$seed))
    self$get_run_byseed(seeds, .filtertext = .filtertext)
  },

  #' @description
  #' Retrieve runs with desired outcome/s across the run history.
  #'
  #' @param outcome The outcome/s to retrieve data for.
  #' @param .filtertext The text to add to the filter list (mostly used internally).
  #'
  #' @returns An `STS2RunHistory` object containing only selected outcomes.
  #'
  #' @note
  #' `STS2Run` objects are passed by reference. As such if you modify a run in a filtered history, those changes will appear in the original list.
  #'
  get_run_byoutcome = function(outcome, .filtertext = "filtered by outcome") {
    poss_outcomes <- c("win", "loss", "abandoned")
    outcome <- outcome[outcome %in% poss_outcomes]
    STS2RunHistory$new(
      self$runs[which(sapply(self$runs, \(x) {tolower(x$get_outcome()) %in% outcome}))],
      steamid = self$ownerid,
      filtersteps = c(self$filtersteps, .filtertext)
      )
  },

  #' @description
  #' Retrieve runs with desired ascensions across the run history.
  #'
  #' @param ascension The ascensions to retrieve data for.
  #' @param .filtertext The text to add to the filter list (mostly used internally).
  #'
  #' @returns An `STS2RunHistory` object containing only selected ascensions.
  #'
  #' @note
  #' `STS2Run` objects are passed by reference. As such if you modify a run in a filtered history, those changes will appear in the original list.
  #'
  get_run_byascension = function(ascension = 0, .filtertext = "filtered by ascension") {
    ascension <- unique(max(min(ascension, 10), 0))
    STS2RunHistory$new(
      self$runs[which(sapply(self$runs, \(x) {x$ascension %in% ascension}))],
      steamid = self$ownerid,
      filtersteps = c(self$filtersteps, .filtertext)
      )
  }

  # generate_summary = function() {
  #   # TODO: Finish
  #   seeds <- sapply(self$runs, \(x) (x$seed))
  #   ascensions <- sapply(self$runs, \(x) (x$ascension))
  #   gamemode <- sapply(self$runs, \(x) (x$game_mode))
  # }

  # TODO: A way to filter runs by date
  # TODO: A way to filter runs
  ),
  private = list())

#' @export
length.STS2RunHistory <- function(x) {
  length(x$runs)
}

#' @export
`[.STS2RunHistory` <- function(x, i) {
  STS2RunHistory$new(x$runs[i], steamid = x$ownerid, filtersteps = c(x$filtersteps, "indexed"))
}

#' @export
`[[.STS2RunHistory` <- function(x, i, exact = TRUE) {
  x$runs[[i, exact = exact]]
}

#' Slay the Spire 2 run (R6).
#'
#' @description
#' This is the general holding class for an sts2 run.
#' It stores the main metadata and lists containing more in-depth run data.
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

    #' @field map A list storing the play-by-play of the run. An `STS2Map` object.
    map = list(),

    #' @field modifiers Any modifiers that the player had turned on.
    modifiers = list(),

    #' @field platform_type The platform of the game (e.g. steam).
    platform_type = "",

    #' @field players A list of player information. A list of `STS2Player` objects.
    players = list(),

    #' @field run_time The run duration (in seconds).
    run_time = 0,

    #' @field schema_version The run schema version.
    schema_version = 0,

    #' @field seed The seed of the run.
    seed = "",

    #' @field start_time The start time (in seconds from unix epoch, UTC).
    start_time = 0,

    #' @field was_abandoned Whether the player abandoned the run.
    was_abandoned = FALSE,

    #' @field win Whether the player won the run.
    win = FALSE,

    #' @field ownerid The steam ID of the run owner.
    ownerid = "",

    #' @description
    #' Create a new run object from data parsed with jsonlite.
    #'
    #' @param rundata The list output from jsonlite containing the run data.
    #' @param steamid The owner's steamid (for differentiating in the case of multiplayer runs).
    #' @returns A new `STS2Run` object.
    #'
    initialize = function(rundata, steamid = NULL) {
      self$ownerid <- as.character(steamid)
      self$acts <- format_sts2id(as.character(rundata$acts))
      self$ascension <- rundata$ascension
      self$build_id <- rundata$build_id
      self$game_mode <- rundata$game_mode
      self$killed_by_encounter <- ifelse(rundata$killed_by_encounter == "NONE.NONE", NA, format_sts2id(rundata$killed_by_encounter))
      self$killed_by_event <- ifelse(rundata$killed_by_event == "NONE.NONE", NA, format_sts2id(rundata$killed_by_event))
      self$modifiers <- rundata$modifiers
      self$platform_type <- rundata$platform_type
      self$players <- lapply(1:length(rundata$players), \(i) {STS2Player$new(rundata$players[[i]], run = self, idx = i)})
      self$run_time <- rundata$run_time
      self$schema_version <- rundata$schema_version
      self$seed <- rundata$seed
      self$start_time <- rundata$start_time
      self$was_abandoned <- rundata$was_abandoned
      self$win <- rundata$win
      # Map data must be loaded after players.
      self$map <- STS2Map$new(rundata$map_point_history, run = self)
    },

    #' @description
    #' Print an `STS2Run` object.
    #'
    #' @param ... Unused.
    #' @param full Whether to print extra internal run information.
    #'
    #' @returns Nothing (called for side-effect)
    #'
    print = function(..., full = FALSE) {
      cli::cli_rule(left = "Seed: {self$seed}")
      cli::cli_text("Ascension: {self$ascension}")
      if (self$game_mode != "standard") {
        cli::cli_text("Gamemode: {self$game_mode}")
      }
      if (length(self$modifiers) > 0) {
        cli::cli_text("Modifiers: {self$modifiers}")
      }
      cli::cli_text("Start: {as.POSIXlt(self$start_time)} UTC")
      cli::cli_text("Duration: {strftime(as.POSIXct('00:00:00', format='%H:%M:%S') + self$run_time, format='%H:%M:%S')}")
      charcolour <- c("Ironclad" = cli::col_red, "Silent" = cli::col_green, "Regent" = cli::col_yellow, "Necrobinder" = cli::col_magenta, "Defect" = cli::col_blue)
      chars_fmt <- sapply(self$players, \(x) {charcolour[[x$playercharacter]](x$playercharacter)})
      cli::cli_text("Player{?s}: {chars_fmt}")

      cli::cli_text("Floors: {length(self$map)}")
      outcome <- if (self$win) {cli::col_green("Win")} else if (self$was_abandoned) {cli::col_yellow("Abandoned")} else {cli::col_red("Loss")}
      cli::cli_text("Outcome: {outcome}")

      if (!is.na(self$killed_by_encounter)) {
        cli::cli_text("Killed by encounter: {cli::col_red(self$killed_by_encounter)}")
      }

      if (!is.na(self$killed_by_event)) {
        cli::cli_text("Killed by event: {cli::col_red(self$killed_by_event)}")
      }

      if (full) {
        cli::cli_h2("Extra Data")
        if (self$game_mode == "standard") {
          cli::cli_text("Gamemode: {self$game_mode}")
        }
        cli::cli_text("Build ID: {self$build_id}")
        cli::cli_text("Platform: {self$platform_type}")
        cli::cli_text("Schema Version: {self$schema_version}")
      }
    },

    #' @description
    #' Retrieve player data for a given player from a run.
    #'
    #' @param id the Steam ID of the player data to retrieve (or `NULL` to retrieve the data of the run owner).
    #'
    #' @returns An `STS2Player` object or `NULL`.
    #'
    get_individual_player_data = function(id = NULL) {
      if (is.null(id)) {
        id <- self$ownerid
        if (is.null(id)) {
          cli::cli_abort("Owner ID not present, nor supplied in an argument.")
        }
      }
      id <- as.character(id)
      if (id == self$ownerid) {
        # Also capture single-player runs
        id <- c(id, "1")
      }
      found_players <- self$players[which(sapply(self$players, \(x) {x$id %in% id}))]
      if (length(found_players) > 0) {
        return(found_players[[1]])
      } else {
        return(NULL)
      }
    },

    #' @description
    #' Retrieve data for a character.
    #'
    #' @param char The character/s to retrieve data for.
    #' @param onlyowner If TRUE, only retrieve entries where the owner was the character specified.
    #'
    #' @returns A list of `STS2Player` objects containing only selected characters.
    #'
    get_character = function(char, onlyowner = FALSE) {
      poss_chars <- c("ironclad", "silent", "regent", "necrobinder", "defect")
      char <- tolower(char)
      char <- char[char %in% poss_chars]
      if (onlyowner) {
        self$players[which(sapply(self$players, \(x) {(tolower(x$playercharacter) %in% char) && (x$id %in% c(self$ownerid, "1"))}))]
      } else {
        self$players[which(sapply(self$players, \(x) {tolower(x$playercharacter) %in% char}))]
      }
    },

    #' @description
    #' Get run outcome.
    #'
    #' @returns The outcome of the run as a string (one of Win, Abandoned, or Loss).
    #'
    get_outcome = function(){
      if (self$win) {"Win"} else if (self$was_abandoned) {"Abandoned"} else {"Loss"}
    }
  ),
  private = list(
  )
)

#' Slay the Spire 2 player (R6).
#'
#' @description
#' This is the general holding class for an sts2 player.
#' It stores the main player data for the run.
#'
STS2Player <- R6Class("STS2Player",
  public = list(
    #' @field run The `STS2Run` object that this player object originates from.
    run = NULL,

    #' @field playercharacter The character that the player was playing
    playercharacter = "",

    #' @field deck The deck of the player at the end of the run. An `STS2Deck` object.
    deck = list(),

    #' @field id The steam player id or 1 if single player.
    id = "",

    #' @field max_potion_slot_count The maximum number of potions a player could hold.
    max_potion_slot_count = 0,

    #' @field potions The potions held by the player at the end of the run.
    potions = character(),

    #' @field relics The relics held by the player at the end of the run. An `STS2Relics` object
    relics = NULL,

    #' @description
    #' Create a new run object from player data.
    #'
    #' @param playerdata The subset of the list output from jsonlite, usually passed in via `STS2Run`.
    #' @param run The STS2Run object that this player object originates from.
    #' @param idx The index within the player list from which this player originates.
    #' @returns A new `STS2Player` object.
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
    #' Print an `STS2Player` object.
    #'
    #' @param ... Arguments to pass to `print()`.
    #' @param full Whether to show the full deck and relics of the player.
    #' @param floor Whether to show the floor on which a card/relic was obtained when `full = TRUE`.
    #'
    #' @returns Nothing (called for side-effect)
    #'
    print = function(..., full = FALSE, floor = FALSE) {
      charcolour <- c("Ironclad" = cli::col_red, "Silent" = cli::col_green, "Regent" = cli::col_yellow, "Necrobinder" = cli::col_magenta, "Defect" = cli::col_blue)
      charcolfn <- charcolour[[self$playercharacter]]
      cli::cli_text(cli::style_bold(charcolfn(self$playercharacter)))
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
      # Note this only works when the `STS2Map` class has been initialised.
      # As such this is sort of a deferred-calculation system
      if (is.null(private$.max_health)) {
        private$find_max_health()
      }
      private$.max_health
    }
  )
)

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

#' Map points in a Slay The Spire 2 run (R6).
#'
#' @description
#' This is the general holding class for STS2 map points.

STS2Map <- R6Class("STS2Map",
  public = list(
    #' @field run The run
    run = NULL,

    #' @field floors The floors in the map. A list of `STS2Floor` objects.
    floors = list(),

    #' @description
    #' Create a new map object from map data.
    #'
    #' @param mapdata The subset of the list output from jsonlite, usually passed in via `STS2Player`.
    #' @param run The `STS2Run` object this map belongs to.
    #' @returns A new `STS2Map` object.
    #'
    initialize = function(mapdata, run = NULL) {
      self$run <- run
      mapdata_parsed <- lapply(1:length(mapdata), \(i) {
        lapply(mapdata[[i]], \(x) {STS2Floor$new(x, act = i, map = self)})
      })
      self$floors <- unlist(mapdata_parsed)
    }
  ),
  private = list())

#' @export
length.STS2Map <- function(x) {
  length(x$floors)
}

#' Slay the Spire 2 floor (R6).
#'
#' @description
#' This is the general holding class for a sts2 floor.
#'
STS2Floor <- R6Class("STS2Floor",
  public = list(
    #' @field act The act this floor appeared in.
    act = 0,

    #' @field map The `STS2Map` object this floor belongs to.
    map = NULL,

    #' @field floor_type The type of floor that this is.
    floor_type = "",

    #' @field player_stats The stats of the player/s at the end of this floor. A list of `STS2PlayerMidrun` objects.
    player_stats = list(),

    #' @field turns_taken The number of turns this room took.
    turns_taken = 0,

    #' @field model_id The model id of the encounter (or `NULL` if rest site/treasure room).
    model_id = NULL,

    #' @field monsters The monsters present on the floor.
    monsters = NULL,

    #' @field rooms A list of the unparsed room data.
    rooms = list(),

    #' @description
    #' Create a new floor object from floor data.
    #'
    #' @param floordata The individual floor-level output from jsonlite, usually passed in via `STS2Map`.
    #' @param map The `STS2Map` object this floor belongs to.
    #' @param act The act this floor appeared in.
    #' @returns A new `STS2Floor` object.
    #'
    initialize = function(floordata, act = 0, map = NULL) {
      # browser()
      self$act <- act
      self$map <- map
      self$floor_type <- floordata$map_point_type
      # Will need better parsing later
      # It seems like there's only ever 1 entry in the rooms field.
      if(length(floordata$rooms) > 2) {
        seed <- self$map$run$seed
        cli::cli_warn("More than two rooms ({length(floordata$rooms)}) in floor data. Seed: {seed}, Act: {self$act}, Type: {self$floor_type}. Please report if you see this.")
      }
      # extract out room1 as we usually just need that
      room1 <- floordata$rooms[[1]]
      self$turns_taken <- sum(sapply(floordata$rooms, \(x) {x$turns_taken}))
      if (self$floor_type == "unknown") {
        if (!is.null(room1$room_type)) {
          self$floor_type <- room1$room_type
        } else {
          self$floor_type <- "event"
        }
      }
      if (!is.null(room1$model_id)) {
        # If there's two rooms, we still only want the first.
        self$model_id <- format_sts2id(as.character(room1$model_id))
      }
      if (length(floordata$rooms) > 1) {
        # Get monsters from all rooms (filter for rooms with monsters and then put together all those)
        self$monsters <- as.character(sapply(floordata$rooms[which(sapply(floordata$rooms, \(x) {!is.null(x$monster_ids)}))],
                                \(y) {format_sts2id(as.character(y$monster_ids))}
                                ))
      } else {
        if (!is.null(room1$monster_ids)) {
          self$monsters <- format_sts2id(as.character(room1$monster_ids))
        }
      }
      # Save the raw room data just in case it's needed
      self$rooms <- floordata$rooms

      self$player_stats <- lapply(1:length(floordata$player_stats), \(i) {
        playerinfo <- self$map$run$players[[i]]
        player_stats <- floordata$player_stats[[i]]
        STS2PlayerMidrun$new(player_stats, floor = self, player = playerinfo)
      })
    }
  ),
  private = list())

#' A Slay the Spire 2 player, mid-run (R6).
#'
#' @description
#' This is the general holding class for a sts2 player at a point in the run.
#'
#' @note
#' All fields in this are considered to be "at the end of this floor".
#' For example current_hp on a floor where a player dies will be 0, even if they entered the fight with more than 0 HP.
#'
STS2PlayerMidrun <- R6Class("STS2PlayerMidrun",
  public = list(
    #' @field floor The `STS2Floor` object this midrun object refers to.
    floor = NULL,

    #' @field player The `STS2Player` object this midrun object refers to.
    player = NULL,

    # Consistent data
    #' @field current_gold Current gold.
    current_gold = 0,

    #' @field current_hp Current health.
    current_hp = 0,

    #' @field damage_taken Damage taken during the floor.
    damage_taken = 0,

    #' @field gold_gained Gold gained.
    gold_gained = 0,

    #' @field gold_lost Gold lost.
    gold_lost = 0,

    #' @field gold_spent Gold spent.
    gold_spent = 0,

    #' @field gold_stolen Gold stolen (damn gremlins).
    gold_stolen = 0,

    #' @field hp_healed Health recovered during the floor.
    hp_healed = 0,

    #' @field max_hp Max health.
    max_hp = 0,

    #' @field max_hp_gained Max health gained during the floor.
    max_hp_gained = 0,

    #' @field max_hp_lost Max health lost during the floor.
    max_hp_lost = 0,

    #' @field player_id The id of the player within the run data.
    player_id = 0,

    # Floor-specific data

    #' @field ancient_choice The choices available from the ancient (and which was picked).
    ancient_choice = list(),

    #' @field bought_colorless The colorless cards bought during the floor.
    bought_colorless = list(),

    #' @field bought_potions The potions bought during the floor.
    bought_potions = list(),

    #' @field bought_relics The relics bought during the floor.
    bought_relics = list(),

    #' @field card_choices The card choices available.
    card_choices = list(),

    #' @field cards_enchanted The cards enchanted during the floor.
    cards_enchanted = list(),

    #' @field cards_gained The cards gained from the floor.
    cards_gained = list(),

    #' @field cards_removed The cards removed during the floor.
    cards_removed = list(),

    #' @field cards_transformed The cards transformed during the floor.
    cards_transformed = list(),

    #' @field completed_quests The quests completed on the floor.
    completed_quests = list(),

    #' @field event_choices The choices made during the event (not in a particularly useful form).
    event_choices = list(),

    #' @field potion_choices The potion choices available.
    potion_choices = list(),

    #' @field potion_discarded The potions discarded during the floor.
    potion_discarded = list(),

    #' @field potion_used The potions used during the floor.
    potion_used = list(),

    #' @field relic_choices The choices available from the floor (and which was picked).
    relic_choices = list(),

    #' @field relics_removed The relics removed during the floor.
    relics_removed = list(),

    #' @field rest_site_choices The rest site choices (and which was picked).
    rest_site_choices = list(),

    #' @field upgraded_cards The cards upgraded during the floor.
    upgraded_cards = list(),


    #' @description
    #' Create a new mid-run player object from player data.
    #'
    #' @param playerstats The individual player_stats output from jsonlite, usually passed in via `STS2Player`.
    #' @param floor The `STS2Floor` object this midrun object refers to.
    #' @param player The `STS2Player` object this midrun object refers to.
    #' @returns A new `STS2PlayerMidrun` object.
    #'
    initialize = function(playerstats, floor = NULL, player = NULL) {
      # browser()
      self$floor <- floor
      self$player <- player
      # Consistent player stats
      continuous_player_stats <- c("current_gold", "current_hp", "damage_taken",
        "gold_gained", "gold_lost", "gold_spent", "gold_stolen", "hp_healed",
        "max_hp", "max_hp_gained", "max_hp_lost", "player_id")
      for (x in continuous_player_stats) {
        self[[x]] <- playerstats[[x]]
      }

      # Variable player stats
      # TODO: Temporary until custom parsers can be implemented
      variable_player_stats <- c("ancient_choice", "bought_colorless", "bought_potions", "bought_relics",
        "card_choices", "cards_enchanted", "cards_gained", "cards_removed",
        "cards_transformed", "completed_quests", "event_choices", "potion_choices",
        "potion_discarded", "potion_used", "relic_choices", "relics_removed",
        "rest_site_choices", "upgraded_cards")
      for (x in variable_player_stats) {
        if (!is.null(playerstats[[x]])) {
          self[[x]] <- playerstats[[x]]
        }
      }

      # if (!is.null(playerstats$ancient_choice)) {
      #   self$ancient_choice <- playerstats$ancient_choice
      # }
      #
      # if (!is.null(playerstats$bought_colorless)) {
      #   self$bought_colorless <- playerstats$bought_colorless
      # }
      #
      # if (!is.null(playerstats$bought_potions)) {
      #   self$bought_potions <- playerstats$bought_potions
      # }
      #
      # if (!is.null(playerstats$bought_relics)) {
      #   self$bought_relics <- playerstats$bought_relics
      # }
      #
      # if (!is.null(playerstats$card_choices)) {
      #   self$card_choices <- playerstats$card_choices
      # }
      #
      # if (!is.null(playerstats$cards_enchanted)) {
      #   self$cards_enchanted <- playerstats$cards_enchanted
      # }
      #
      # if (!is.null(playerstats$cards_gained)) {
      #   self$cards_gained <- playerstats$cards_gained
      # }
      #
      # if (!is.null(playerstats$cards_removed)) {
      #   self$cards_removed <- playerstats$cards_removed
      # }
      #
      # if (!is.null(playerstats$cards_transformed)) {
      #   self$cards_transformed <- playerstats$cards_transformed
      # }
      #
      # if (!is.null(playerstats$completed_quests)) {
      #   self$completed_quests <- playerstats$completed_quests
      # }
      #
      # if (!is.null(playerstats$event_choices)) {
      #   self$event_choices <- playerstats$event_choices
      # }
      #
      # if (!is.null(playerstats$potion_choices)) {
      #   self$potion_choices <- playerstats$potion_choices
      # }
      #
      # if (!is.null(playerstats$potion_discarded)) {
      #   self$potion_discarded <- playerstats$potion_discarded
      # }
      #
      # if (!is.null(playerstats$potion_used)) {
      #   self$potion_used <- playerstats$potion_used
      # }
      #
      # if (!is.null(playerstats$relic_choices)) {
      #   self$relic_choices <- playerstats$relic_choices
      # }
      #
      # if (!is.null(playerstats$relics_removed)) {
      #   self$relics_removed <- playerstats$relics_removed
      # }
      #
      # if (!is.null(playerstats$rest_site_choices)) {
      #   self$rest_site_choices <- playerstats$rest_site_choices
      # }
      #
      # if (!is.null(playerstats$upgraded_cards)) {
      #   self$upgraded_cards <- playerstats$upgraded_cards
      # }
    }
  ),
  private = list())
