# Load Slay the Spire 2 Run Data

Load Slay the Spire 2 Run Data

## Usage

``` r
load_sts_history(path = NULL, profilenum = NULL, game = 2)
```

## Arguments

- path:

  The path to your installation.

- game:

  Which game to retrieve run data for (2 = STS2, 1 = STS), currently
  only STS2 is implemented.

- profile_num:

  Which profile to retrieve data for (or NULL to retrieve all).

## Value

The parsed run data.

## Examples

``` r
load_sts2_history()
#> Error in load_sts2_history(): could not find function "load_sts2_history"
```
