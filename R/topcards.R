#' Retrieve the most-taken cards across a history of runs.
#'
#' @param runhistory An [STS2RunHistory] object, filtered if necessary.
#' @param n The number of results to retrieve, or `NULL` to retrieve all.
#' @param char The character/s to filter by (or `NULL` to return all).
#' @param return_unique Return only 1 entry per unique card in a run. This gives more of a metric of "runs where this card was in your deck".
#' @param ignore_basics Don't consider basic cards (strike/defend).
#'
#' @returns A `data.frame` of cards and the number of times they appeared in a run
#' @export
#'
#' @examplesIf interactive()
#' myruns <- load_sts_history()
#' topcards(myruns)
#' topcards(myruns$filter_outcome("win"), n = 20, return_unique = TRUE)
topcards <- function(runhistory, n = 10, char = NULL, return_unique = FALSE, ignore_basics = TRUE) {
  runcards <- unlist(sapply(runhistory$runs, \(x) {x$get_cards(ignore_basics, return_unique = return_unique, char = char)}))
  summary_table <- table(runcards)
  outdf <- data.frame(card = names(summary_table), count = as.numeric(summary_table))
  outdf <- outdf[order(outdf$count, decreasing = TRUE),]
  if (!is.null(n)) {
    utils::head(outdf, n)
  } else {
    outdf
  }
}

.cardwins <- function(runhistory, ignore_basics = TRUE, return_unique = FALSE) {
  runcards <- lapply(runhistory$runs, \(x) {x$get_cards(ignore_basics, return_unique)})
  runoutcomes <- get_field(runhistory$runs, "outcome")
  runoutcomes <- unlist(sapply(1:length(runoutcomes), \(i) {rep(runoutcomes[i], length(runcards[[i]]))}))
  runcards <- unlist(runcards)
  outdf <- data.frame(card = runcards, outcome = runoutcomes)
  outdf <- subset(outdf, outdf$outcome != "Abandoned")
  outdf
}
