#' Load Slay the Spire 2 Run Data
#'
#' @param path The path to your installation.
#' @param profilenum Which profile to retrieve data for (or NULL to retrieve all).
#' @param game Which game to retrieve run data for (2 = STS2, 1 = STS), currently only STS2 is implemented.
#' @param platform Which platform are you running on?
#'
#' @returns The parsed run data.
#' @export
#'
#' @examplesIf interactive()
#' load_sts_history()
#'
load_sts_history <- function(path = NULL, profilenum = 1, game = 2, platform = c("windows", "mac", "linux")) {
  # Runs are located at C:\Program Files (x86)\Steam\steamapps\common\SlayTheSpire\runs\<CHARACTER> on windows for STS1.
  # Runs are located at %APPDATA%/Roaming/SlayTheSpire2/steam/<ID?>/profile<x>/saves/history on windows for STS2.
  platform <- match.arg(platform)
  if(game != 2) {
    cli::cli_abort(c("x" = "This package currently only supports loading STS2 runs."))
  }

  platform <- tolower(platform)

  if (is.null(path)) {
    if(platform != "windows") {
      cli::cli_abort(c(
        "x" = "This package currently only supports Windows operating systems by default.",
        "i" = "If you can find the location of your saves yourself, you can pass this into the {.arg path} argument."
      ))
    }
    # Only windows for now, let's see if the random number changes, it might well do.
    default_location <- paste0("~/../AppData/Roaming/SlayTheSpire2/steam/76561198003753555/profile", profilenum,"/saves/history/")
    path <- default_location
  }

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
      STS2Run$new(x)
    }, error = function(e) {
      cli::cli_warn("Error parsing run JSON for seed {x$seed}.")
      NULL
    })

  })
  cli::cli_progress_done()
  return(runs_parsed)
}
