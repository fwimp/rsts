# Load Slay the Spire 2 Run Data

Load Slay the Spire 2 Run Data

## Usage

``` r
load_sts_history(
  path = NULL,
  id = NULL,
  profilenum = 1,
  game = 2,
  platform = c("windows", "mac", "linux"),
  players = NULL
)
```

## Arguments

- path:

  The path to your installation.

- id:

  The steamID of the data you want to retrieve. If NULL, will just get
  the first ID directory.

- profilenum:

  Which profile to retrieve data for (or NULL to retrieve all).

- game:

  Which game to retrieve run data for (2 = STS2, 1 = STS), currently
  only STS2 is implemented.

- platform:

  Which platform are you running on?

- players:

  Only analyse runs with this number of players (or NULL for all,
  default).

## Value

The parsed run data.

## Note

If you provide a range of numbers for the `players` argument e.g. `1:3`,
any number of players in this range will be included.

## Examples

``` r
if (FALSE) { # interactive()
load_sts_history()
}
```
