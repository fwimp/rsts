# Load Slay the Spire 2 Run Data

Load Slay the Spire 2 Run Data

## Usage

``` r
load_sts_history(
  path = NULL,
  profilenum = 1,
  game = 2,
  platform = c("windows", "mac", "linux")
)
```

## Arguments

- path:

  The path to your installation.

- profilenum:

  Which profile to retrieve data for (or NULL to retrieve all).

- game:

  Which game to retrieve run data for (2 = STS2, 1 = STS), currently
  only STS2 is implemented.

- platform:

  Which platform are you running on?

## Value

The parsed run data.

## Examples

``` r
if (FALSE) { # interactive()
load_sts_history()
}
```
