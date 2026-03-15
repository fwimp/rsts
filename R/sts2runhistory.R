#' Slay the Spire 2 run history (R6).
#'
#' @description
#' This is the general holding class for a full history of sts2 runs.
#'
#' It can be indexed like a list (i.e. `x[1]`).
#'
STS2RunHistory <- R6Class("STS2RunHistory",
  public = list(
  #' @field runs The parsed run logs. A list of [STS2Run] objects.
  runs = list(),
  #' @field ownerid The steam ID of the run history owner.
  ownerid = "",
  #' @field filtersteps The filtering steps performed on this run history.
  filtersteps = NULL,

  #' @description
  #' Create a new run history container from a list of [STS2Run] objects.
  #'
  #' @param historydata A list of [STS2Run] objects.
  #' @param steamid The owner's steamid (for differentiating in the case of multiplayer runs).
  #' @param filtersteps The filtering steps performed on this run history.
  #'
  #' @section Filters:
  #' Any method starting `filter_` returns a new [STS2RunHistory] object.
  #'
  #' As such these can be chained together:
  #'
  #' ```r
  #' myruns <- load_sts_history()
  #' myruns$filter_ascension(0)$filter_outcome("Win")
  #' ```
  #'
  #' @section STS2Run objects:
  #' [STS2Run] objects are passed by reference. As such if you modify a run in a filtered history, those changes will appear in the original list.
  #'
  #' @returns A new [STS2RunHistory] object.
  #'
  initialize = function(historydata, steamid = NULL, filtersteps = NULL) {
    self$runs <- historydata
    self$ownerid <- as.character(steamid)
    self$filtersteps = filtersteps
  },

  #' @description
  #' Print an [STS2RunHistory] object.
  #'
  #' @param ... Unused.
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
    invisible(self)
  },

  #' @description
  #' Retrieve player data for a given player from runs.
  #'
  #' @param id The Steam ID of the player data to retrieve (or `NULL` to retrieve the data of the run owner).
  #'
  get_individual_player_data = function(id = NULL) {
    if (is.null(id)) {
      id <- c(self$ownerid, "1")
      if (is.null(id)) {
        cli::cli_abort("Owner ID not present, nor supplied in an argument.")
      }
    }
    id <- as.character(id)
    found_playerdata <- unlist(get_field(self$runs, "players"))
    found_playerdata <- found_playerdata[which(get_field(found_playerdata, "id") %in% id)]

    return(found_playerdata)
  },

  #' @description
  #' Retrieve player data for all players from runs.
  #'
  get_player_data = function() {
    unlist(get_field(self$runs, "players"))
  },

  #' @description
  #' Retrieve runs by seed.
  #'
  #' @param seed The seed (or seeds) that one wishes to retrieve.
  #' @param .filtertext The text to add to the filter list (mostly used internally).
  #'
  filter_seed = function(seed, .filtertext = "filtered by seed") {
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
  filter_character = function(char, onlyowner = FALSE, .filtertext = "filtered by character") {
    runs_with_character <- private$get_character(char, onlyowner = onlyowner)
    seeds <- unique(sapply(runs_with_character, \(x) x$run$seed))
    self$filter_seed(seeds, .filtertext = .filtertext)
  },

  #' @description
  #' Retrieve runs with desired outcome/s across the run history.
  #'
  #' @param outcome The outcome/s to retrieve data for.
  #' @param .filtertext The text to add to the filter list (mostly used internally).
  #'
  filter_outcome = function(outcome, .filtertext = "filtered by outcome") {
    outcome <- tolower(outcome)
    poss_outcomes <- c("win", "loss", "abandoned")
    outcome <- outcome[outcome %in% poss_outcomes]
    STS2RunHistory$new(
      self$runs[which(sapply(self$runs, \(x) {tolower(x$outcome) %in% outcome}))],
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
  filter_ascension = function(ascension = 0, .filtertext = "filtered by ascension") {
    ascension <- unique(pmax(pmin(ascension, 10), 0))
    STS2RunHistory$new(
      self$runs[which(sapply(self$runs, \(x) {x$ascension %in% ascension}))],
      steamid = self$ownerid,
      filtersteps = c(self$filtersteps, .filtertext)
      )
  },

  #' @description
  #' Retrieve runs with desired player count across the run history.
  #'
  #' @param players The player count/s to retrieve data for.
  #' @param .filtertext The text to add to the filter list (mostly used internally).
  #'
  filter_playercount = function(players = 1, .filtertext = "filtered by player count") {
    players <- unique(pmax(pmin(players, 4), 1))
    STS2RunHistory$new(
      self$runs[which(sapply(self$runs, \(x) {x$numplayers %in% players}))],
      steamid = self$ownerid,
      filtersteps = c(self$filtersteps, .filtertext)
    )
  },

  #' @description
  #' Retrieve runs with desired patch version across the run history.
  #'
  #' @param cond A condition (e.g. "=" or ">").
  #' @param patch The version to compare runs against.
  #' @param .filtertext The text to add to the filter list (mostly used internally).
  #'
  filter_version = function(cond = "==", patch, .filtertext = "filtered by version") {
    # Handle cases where the user only specifies the patch version.
    if (missing(patch)) {
      patch <- cond
      cond <- "=="
    }
    STS2RunHistory$new(
      self$runs[.compare_version(get_field(self$runs, "build_id"), cond, patch)],
      steamid = self$ownerid,
      filtersteps = c(self$filtersteps, .filtertext)
      )
  },

  #' @description
  #' Retrieve runs with desired floor count across the run history.
  #'
  #' @param floors The floor count/s to retrieve data for.
  #' @param .filtertext The text to add to the filter list (mostly used internally).
  #'
  filter_floorcount = function(floors, .filtertext = "filtered by number of floors") {
    # Clamp at floor 1, but max floors can be whatever
    floors <- unique(pmax(floors, 1))
    STS2RunHistory$new(
      self$runs[which(sapply(self$runs, \(x) {x$numfloors %in% floors}))],
      steamid = self$ownerid,
      filtersteps = c(self$filtersteps, .filtertext)
    )
  },

  #' @description
  #' Retrieve runs with desired gamemode across the run history.
  #'
  #' @param gamemode The gamemode/s to retrieve data for.
  #' @param .filtertext The text to add to the filter list (mostly used internally).
  #'
  filter_gamemode = function(gamemode, .filtertext = "filtered by gamemode") {
    gamemode <- tolower(gamemode)
    poss_gamemodes <- c("standard", "daily")
    gamemode <- gamemode[gamemode %in% poss_gamemodes]
    STS2RunHistory$new(
      self$runs[which(sapply(self$runs, \(x) {tolower(x$game_mode) %in% gamemode}))],
      steamid = self$ownerid,
      filtersteps = c(self$filtersteps, .filtertext)
    )
  },

  #' @description
  #' Generate a summary dataframe for the run history.
  #'
  generate_summary = function() {
    fields <- c("seed", "ascension", "game_mode", "build_id", "numplayers", "start_time", "run_time", "outcome", "killed_by_encounter", "killed_by_event")
    listout <- lapply(fields, \(x){get_field(self$runs, x)})
    names(listout) <- fields
    for (i in 1:4) {
      listout[[paste0("player", i)]] <- sapply(self$runs, \(x) {tryCatch(x$players[[i]]$playercharacter, error = function(e){NA})})
    }
    out <- as.data.frame(listout)
    out$start_time <- lubridate::as_datetime(out$start_time)
    out$run_time <- lubridate::seconds_to_period(out$run_time)
    return(out)
  }

  # TODO: A way to filter runs by date

  ),
  private = list(
    get_character = function(char, onlyowner = FALSE) {
      poss_chars <- c("ironclad", "silent", "regent", "necrobinder", "defect")
      char <- tolower(char)
      char <- char[char %in% poss_chars]
      found_playerdata <- sapply(self$runs, \(x) {x$get_character(char, onlyowner = onlyowner)})
      unlist(found_playerdata[which(sapply(found_playerdata, \(x) {length(x) > 0}))])
    }
  ))

#' @export
length.STS2RunHistory <- function(x) {
  length(x$runs)
}

#' @export
`[.STS2RunHistory` <- function(x, i) {
  STS2RunHistory$new(x$runs[i], steamid = x$ownerid, filtersteps = c(x$filtersteps, "indexed"))
}

# #' @export
# `[[.STS2RunHistory` <- function(x, i, exact = TRUE) {
#   # Note: Defining this disables Rstudio's introspection
#   x$runs[[i, exact = exact]]
# }

#' @export
summary.STS2RunHistory <- function(object, ...) {
  object$generate_summary()
}

testR6 <- R6Class("testR6",
  public = list(
    test1 = list()
  ))
