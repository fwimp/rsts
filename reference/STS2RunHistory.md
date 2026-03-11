# Slay the Spire 2 run history (R6).

This is the general holding class for a full history of sts2 runs.

It can be indexed like a list (i.e. `x[1]` or `x[[1]]`).

## Value

A new `STS2RunHistory` object.

Nothing (called for side-effect)

## Public fields

- `runs`:

  The parsed run logs. A list of `STS2Run` objects.

- `ownerid`:

  The steam ID of the run history owner.

## Methods

### Public methods

- [`STS2RunHistory$new()`](#method-STS2RunHistory-new)

- [`STS2RunHistory$print()`](#method-STS2RunHistory-print)

- [`STS2RunHistory$get_individual_player_data()`](#method-STS2RunHistory-get_individual_player_data)

- [`STS2RunHistory$get_runs_byseed()`](#method-STS2RunHistory-get_runs_byseed)

- [`STS2RunHistory$clone()`](#method-STS2RunHistory-clone)

------------------------------------------------------------------------

### Method `new()`

Create a new run history container from a list of `STS2Run` objects.

#### Usage

    STS2RunHistory$new(historydata, steamid = NULL)

#### Arguments

- `historydata`:

  A list of `STS2Run` objects.

- `steamid`:

  The owner's steamid (for differentiating in the case of multiplayer
  runs).

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print an `STS2RunHistory` object.

#### Usage

    STS2RunHistory$print(...)

#### Arguments

- `...`:

  Unused.

------------------------------------------------------------------------

### Method `get_individual_player_data()`

Retrieve player data for a given player from runs.

#### Usage

    STS2RunHistory$get_individual_player_data(id = NULL, excludemissing = TRUE)

#### Arguments

- `id`:

  The Steam ID of the player data to retrieve (or `NULL` to retrieve the
  data of the run owner).

- `excludemissing`:

  Exclude entries from the list where the desired player is not present.
  (This will result in a list that may be shorter than the number of
  runs in the history.)

  @returns A list of `STS2Player` objects.

------------------------------------------------------------------------

### Method `get_runs_byseed()`

Retrieve runs by seed.

#### Usage

    STS2RunHistory$get_runs_byseed(seed)

#### Arguments

- `seed`:

  The seed (or seeds) that one wishes to retrieve.

  @returns An `STS2RunHistory` object containing only selected seeds.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    STS2RunHistory$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
