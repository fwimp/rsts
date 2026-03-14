# Calculate (and potentially plot) winrates by character.

Calculate (and potentially plot) winrates by character.

## Usage

``` r
winrate(
  runhistory,
  plotit = TRUE,
  relative = FALSE,
  expected = NULL,
  ci = TRUE,
  samples = 200,
  lower_quant = 0.025,
  upper_quant = 0.975
)
```

## Arguments

- runhistory:

  An
  [STS2RunHistory](https://fwimp.github.io/rsts/reference/STS2RunHistory.md)
  object, filtered if necessary.

- plotit:

  Whether to plot the data or just return a summary `data.frame`

- relative:

  Whether to calculate the character-based winrate relative to the total
  winrate.

- expected:

  If set, the expected winrate to scale values relative to
  (automatically turns on `relative` when set.)

- ci:

  Whether to calculate and plot 95% confidence intervals

- samples:

  The number of iterations to use when generating CIs.

- lower_quant:

  The lower quantile of the CIs.

- upper_quant:

  The upper quantile of the CIs.

## Value

A `data.frame` summary of winrates by character.

## Examples

``` r
if (FALSE) { # interactive()
myruns <- load_sts_history()
winrate(myruns)
}
```
