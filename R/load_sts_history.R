#' Load Slay the Spire 2 Run Data
#'
#' @param path The path to your installation.
#' @param id The Steam ID of the data you want to retrieve. If `NULL`, will just get the first ID directory when `path = NULL`.
#' @param profilenum Which profile to retrieve data for (or `NULL` to retrieve all).
#' @param game Which game to retrieve run data for (2 = STS2, 1 = STS), currently only STS2 is implemented.
#' @param platform Which platform are you running on?
#' @param players Only analyse runs with this number of players (or `NULL` for all, default).
#'
#' @note
#' If you provide a range of numbers for the `players` argument e.g. `1:3`, any number of players in this range will be included.
#'
#' If you provide a path yourself, make sure to provide a steam ID to consider as the "owning" player. This is necessary for any functions that automatically get player data from multiplayer runs.
#'
#' @returns The parsed run data.
#' @export
#'
#' @examplesIf interactive()
#' load_sts_history()
#'
load_sts_history <- function(path = NULL, id = NULL, profilenum = 1, game = 2, platform = c("windows", "mac", "linux"), players = NULL) {
  # Runs are located at C:\Program Files (x86)\Steam\steamapps\common\SlayTheSpire\runs\<CHARACTER> on windows for STS1.
  # Runs are located at %APPDATA%/Roaming/SlayTheSpire2/steam/<STEAMID>/profile<x>/saves/history on windows for STS2.
  platform <- match.arg(platform)
  if(game != 2) {
    cli::cli_abort(c("x" = "This package currently only supports loading STS2 runs."))
  }

  platform <- tolower(platform)
  if (!is.null(path) && is.null(id)) {
    # Try to extract from the path
    path <- gsub("\\\\", "/", path)
    id <- stringr::str_extract(path, "\\/(\\d{17})\\/", group = 1)
    if (is.na(id)) {
      cli::cli_warn(c("!" = "Steam ID not provided alongside explicit path!", "i" = "Some functions may not work."))
      id <- NULL
    }
  }
  if (is.null(path)) {
    if(platform != "windows") {
      cli::cli_abort(c(
        "x" = "This package currently only supports Windows operating systems by default.",
        "i" = "If you can find the location of your saves yourself, you can pass this into the {.arg path} argument."
      ))
    }
    # Only windows for now. Magic number is steamID so will not be consistent across players.
    # TODO: Must lookup some way.
    basepath <- "~/../AppData/Roaming/SlayTheSpire2/steam"
    if (is.null(id)){
      id <- list.dirs(basepath, recursive = FALSE, full.names = FALSE)[1]
    }
    default_location <- file.path(basepath, id, paste0("profile", profilenum),"saves/history/")
    path <- default_location
  }

  path <- gsub("\\\\", "/", path)

  # TODO: Parallelise if this takes too long when people have a lot of runs.
  # Load runs
  cli::cli_progress_step("Loading runs...")
  run_files <- list.files(path, full.names = TRUE)
  runs <- lapply(run_files, \(x) {
    tryCatch({
      jsonlite::read_json(x)
    }, error = function(e) {
      cli::cli_warn("Error reading run JSON for file {tail(strsplit(x, '/')[[1]], 1)}.")
      NULL
    })
  })

  runs_parsed <- lapply(runs, \(x) {
    tryCatch({
      if (!is.null(players)) {
        if (!(length(x$players) %in% players)) {
          return(NULL)
        }
      }
      STS2Run$new(x, id)
    }, error = function(e) {
      cli::cli_warn("Error parsing run JSON for seed {x$seed}. Message: {e$message}")
      NULL
    })

  })

  runs_parsed <- STS2RunHistory$new(runs_parsed, id)
  cli::cli_progress_done()
  return(runs_parsed)
}
