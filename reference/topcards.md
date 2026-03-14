# Retrieve the most-taken cards across a history of runs.

Retrieve the most-taken cards across a history of runs.

## Usage

``` r
topcards(
  runhistory,
  n = 10,
  char = NULL,
  return_unique = FALSE,
  ignore_basics = TRUE
)
```

## Arguments

- runhistory:

  An
  [STS2RunHistory](https://fwimp.github.io/rsts/reference/STS2RunHistory.md)
  object, filtered if necessary.

- n:

  The number of results to retrieve, or `NULL` to retrieve all.

- char:

  The character/s to filter by (or `NULL` to return all).

- return_unique:

  Return only 1 entry per unique card in a run. This gives more of a
  metric of "runs where this card was in your deck".

- ignore_basics:

  Don't consider basic cards (strike/defend).

## Value

A `data.frame` of cards and the number of times they appeared in a run

## Examples

``` r
if (FALSE) { # interactive()
myruns <- load_sts_history()
topcards(myruns)
topcards(myruns$filter_outcome("win"), n = 20, return_unique = TRUE)
}
```
