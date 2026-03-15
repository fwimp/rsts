#' Calculate (and potentially plot) winrates by character.
#'
#' @param runhistory An [STS2RunHistory] object, filtered if necessary.
#' @param plotit Whether to plot the data or just return a summary `data.frame`
#' @param relative Whether to calculate the character-based winrate relative to the total winrate.
#' @param expected If set, the expected winrate to scale values relative to (automatically turns on `relative` when set).
#' @param ignoreabandoned Remove abandoned runs from data prior to analysis (otherwise abandoned runs count as losses).
#' @param ci Whether to calculate and plot 95% confidence intervals
#' @param samples The number of iterations to use when generating CIs.
#' @param lower_quant The lower quantile of the CIs.
#' @param upper_quant The upper quantile of the CIs.
#'
#' @returns A `data.frame` summary of winrates by character.
#' @export
#'
#' @examplesIf interactive()
#' myruns <- load_sts_history()
#' winrate(myruns)
#'
winrate <- function(runhistory, plotit = TRUE, relative = FALSE, expected = NULL, ignoreabandoned = FALSE, ci = TRUE, samples = 200, lower_quant = 0.025, upper_quant = 0.975) {
  if (is.null(runhistory$ownerid)) {
    cli::cli_abort("runhistory$ownerid must be set!")
  }

  if (!is.null(expected)) {
    relative <- TRUE
  }

  if (ignoreabandoned) {
    runhistory_filtered <- runhistory$filter_outcome(c("win", "loss"))
  }

  runhistory_filtered <- runhistory$get_individual_player_data()

  playerchar <- get_field(runhistory_filtered, "playercharacter")
  # Got to re-traverse the dataset to get outcomes for only found runs.
  outcome <- sapply(runhistory_filtered, \(x) {x$run$outcome})
  winrate_basedf <- data.frame(outcome, character = playerchar)

  if (!ignoreabandoned) {
    winrate_basedf$outcome[winrate_basedf$outcome == "Abandoned"] <- "Loss"
  }

  winprop <- .summarise_winrate(winrate_basedf)
  if(relative) {
    overall_winrate <- expected %||% (length(winrate_basedf$outcome[winrate_basedf$outcome == "Win"]) / nrow(winrate_basedf))
  }
  if (ci) {
    cis <- .generate_winrate_cis(winrate_basedf, samples, lower_quant, upper_quant)
    winprop <- dplyr::left_join(winprop, cis, by = dplyr::join_by("character"))
    winprop$character <- factor(winprop$character, levels = c("Ironclad", "Silent", "Regent", "Necrobinder", "Defect"))
    if(relative) {
      winprop$winrate <- winprop$winrate - overall_winrate
      winprop$lower <- winprop$lower - overall_winrate
      winprop$upper <- winprop$upper - overall_winrate
    }
    p <- ggplot2::ggplot(winprop, ggplot2::aes(x = .data$character, y = .data$winrate, fill = .data$character, ymin = .data$lower, ymax = .data$upper)) + ggplot2::geom_col() + ggplot2::geom_errorbar(alpha = 0.5, width = 0.3, linewidth = 0.75)
  } else {
    winprop$character <- factor(winprop$character, levels = c("Ironclad", "Silent", "Regent", "Necrobinder", "Defect"))

    if(relative) {
      winprop$winrate <- winprop$winrate - overall_winrate
    }
    p <- ggplot2::ggplot(winprop, ggplot2::aes(x = .data$character, y = .data$winrate, fill = .data$character)) + ggplot2::geom_col()
  }

  if (relative) {
    p <- p + ggplot2::scale_y_continuous(limit = c(-1,1)) +
      ggplot2::labs(x = "Character", y = "Relative Win Rate", title = paste0("Relative Win Rate by Character (expected = ", round(overall_winrate, 2),")"))
  } else {
    p <- p + ggplot2::scale_y_continuous(limit = c(0,1)) +
      ggplot2::labs(x = "Character", y = "Win Rate", title = "Win Rate by Character")
  }
  if (plotit) {
    p <- p +
      ggplot2::theme_bw() +
      ggplot2::theme(legend.position="none") +
      ggplot2::scale_fill_manual(
        values = c(
          "Ironclad" = "#AA2222",
          "Silent" = "#648E44",
          "Regent" = "#C07609",
          "Necrobinder" = "#B16580",
          "Defect" = "#2679A3"
        ))
    print(p)
    return(invisible(winprop))
  }
  return(winprop)
}

.summarise_winrate <- function(df) {
  #.data pronouns stop R CMD CHECK errors, see https://galenholt.github.io/package/rlang_data.html
  df |> dplyr::group_by(.data$character) |>  dplyr::summarise(wins = sum(.data$outcome == "Win"), losses = sum(.data$outcome == "Loss")) |> dplyr::mutate(winrate = .data$wins / (.data$wins + .data$losses))
}

.bootstrap_winrate <- function(df, samples = 200) {
  lapply(1:samples, \(x) {df |> dplyr::group_by(.data$character) |> dplyr::mutate(outcome = sample(.data$outcome, replace = TRUE)) |> .summarise_winrate()})
}

.generate_winrate_cis <- function(df,  samples = 200, lower_quant = 0.025, upper_quant = 0.975) {
  bs_df <- do.call(rbind, .bootstrap_winrate(df, samples = samples))
  cis <- bs_df |> dplyr::group_by(.data$character) |> dplyr::summarise(lower = stats::quantile(.data$winrate, lower_quant, na.rm = TRUE), upper = stats::quantile(.data$winrate, upper_quant, na.rm = TRUE))
}
