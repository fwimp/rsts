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
      # charcolour <- c("Ironclad" = cli::col_red, "Silent" = cli::col_green, "Regent" = cli::col_yellow, "Necrobinder" = cli::col_magenta, "Defect" = cli::col_blue)
      # chars_fmt <- sapply(self$players, \(x) {charcolour[[x$playercharacter]](x$playercharacter)})
      chars_fmt <- sapply(self$players, \(x) {col_character(x$playercharacter)})
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
