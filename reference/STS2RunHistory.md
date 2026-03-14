# Slay the Spire 2 run history (R6).

This is the general holding class for a full history of sts2 runs.

It can be indexed like a list (i.e. `x[1]` or `x[[1]]`).

## Value

A new STS2RunHistory object.

## Filters

Any method starting `filter_` returns a new STS2RunHistory object.

As such these can be chained together:

    myruns <- load_sts_history()
    myruns$filter_ascension(0)$filter_outcome("Win")

## STS2Run objects

[STS2Run](https://fwimp.github.io/rsts/reference/STS2Run.md) objects are
passed by reference. As such if you modify a run in a filtered history,
those changes will appear in the original list.

## Public fields

- `runs`:

  The parsed run logs. A list of
  [STS2Run](https://fwimp.github.io/rsts/reference/STS2Run.md) objects.

- `ownerid`:

  The steam ID of the run history owner.

- `filtersteps`:

  The filtering steps performed on this run history.

## Methods

### Public methods

- [`STS2RunHistory$new()`](#method-STS2RunHistory-new)

- [`STS2RunHistory$print()`](#method-STS2RunHistory-print)

- [`STS2RunHistory$get_individual_player_data()`](#method-STS2RunHistory-get_individual_player_data)

- [`STS2RunHistory$get_player_data()`](#method-STS2RunHistory-get_player_data)

- [`STS2RunHistory$filter_seed()`](#method-STS2RunHistory-filter_seed)

- [`STS2RunHistory$filter_character()`](#method-STS2RunHistory-filter_character)

- [`STS2RunHistory$filter_outcome()`](#method-STS2RunHistory-filter_outcome)

- [`STS2RunHistory$filter_ascension()`](#method-STS2RunHistory-filter_ascension)

- [`STS2RunHistory$filter_playercount()`](#method-STS2RunHistory-filter_playercount)

- [`STS2RunHistory$filter_version()`](#method-STS2RunHistory-filter_version)

- [`STS2RunHistory$filter_floorcount()`](#method-STS2RunHistory-filter_floorcount)

- [`STS2RunHistory$filter_gamemode()`](#method-STS2RunHistory-filter_gamemode)

- [`STS2RunHistory$generate_summary()`](#method-STS2RunHistory-generate_summary)

- [`STS2RunHistory$clone()`](#method-STS2RunHistory-clone)

------------------------------------------------------------------------

### Method `new()`

Create a new run history container from a list of
[STS2Run](https://fwimp.github.io/rsts/reference/STS2Run.md) objects.

#### Usage

    STS2RunHistory$new(historydata, steamid = NULL, filtersteps = NULL)

#### Arguments

- `historydata`:

  A list of [STS2Run](https://fwimp.github.io/rsts/reference/STS2Run.md)
  objects.

- `steamid`:

  The owner's steamid (for differentiating in the case of multiplayer
  runs).

- `filtersteps`:

  The filtering steps performed on this run history.

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print an STS2RunHistory object.

#### Usage

    STS2RunHistory$print(...)

#### Arguments

- `...`:

  Unused.

------------------------------------------------------------------------

### Method `get_individual_player_data()`

Retrieve player data for a given player from runs.

#### Usage

    STS2RunHistory$get_individual_player_data(id = NULL)

#### Arguments

- `id`:

  The Steam ID of the player data to retrieve (or `NULL` to retrieve the
  data of the run owner).

------------------------------------------------------------------------

### Method `get_player_data()`

Retrieve player data for all players from runs.

#### Usage

    STS2RunHistory$get_player_data()

------------------------------------------------------------------------

### Method `filter_seed()`

Retrieve runs by seed.

#### Usage

    STS2RunHistory$filter_seed(seed, .filtertext = "filtered by seed")

#### Arguments

- `seed`:

  The seed (or seeds) that one wishes to retrieve.

- `.filtertext`:

  The text to add to the filter list (mostly used internally).

------------------------------------------------------------------------

### Method `filter_character()`

Retrieve runs containing character/s across the run history.

#### Usage

    STS2RunHistory$filter_character(
      char,
      onlyowner = FALSE,
      .filtertext = "filtered by character"
    )

#### Arguments

- `char`:

  The character/s to retrieve data for.

- `onlyowner`:

  If TRUE, only retrieve runs where the owner was the character
  specified.

- `.filtertext`:

  The text to add to the filter list (mostly used internally).

------------------------------------------------------------------------

### Method `filter_outcome()`

Retrieve runs with desired outcome/s across the run history.

#### Usage

    STS2RunHistory$filter_outcome(outcome, .filtertext = "filtered by outcome")

#### Arguments

- `outcome`:

  The outcome/s to retrieve data for.

- `.filtertext`:

  The text to add to the filter list (mostly used internally).

------------------------------------------------------------------------

### Method `filter_ascension()`

Retrieve runs with desired ascensions across the run history.

#### Usage

    STS2RunHistory$filter_ascension(
      ascension = 0,
      .filtertext = "filtered by ascension"
    )

#### Arguments

- `ascension`:

  The ascensions to retrieve data for.

- `.filtertext`:

  The text to add to the filter list (mostly used internally).

------------------------------------------------------------------------

### Method `filter_playercount()`

Retrieve runs with desired player count across the run history.

#### Usage

    STS2RunHistory$filter_playercount(
      players = 1,
      .filtertext = "filtered by player count"
    )

#### Arguments

- `players`:

  The player count/s to retrieve data for.

- `.filtertext`:

  The text to add to the filter list (mostly used internally).

------------------------------------------------------------------------

### Method `filter_version()`

Retrieve runs with desired patch version across the run history.

#### Usage

    STS2RunHistory$filter_version(
      cond = "==",
      patch,
      .filtertext = "filtered by version"
    )

#### Arguments

- `cond`:

  A condition (e.g. "=" or "\>").

- `patch`:

  The version to compare runs against.

- `.filtertext`:

  The text to add to the filter list (mostly used internally).

------------------------------------------------------------------------

### Method `filter_floorcount()`

Retrieve runs with desired floor count across the run history.

#### Usage

    STS2RunHistory$filter_floorcount(
      floors,
      .filtertext = "filtered by number of floors"
    )

#### Arguments

- `floors`:

  The floor count/s to retrieve data for.

- `.filtertext`:

  The text to add to the filter list (mostly used internally).

------------------------------------------------------------------------

### Method `filter_gamemode()`

Retrieve runs with desired gamemode across the run history.

#### Usage

    STS2RunHistory$filter_gamemode(gamemode, .filtertext = "filtered by gamemode")

#### Arguments

- `gamemode`:

  The gamemode/s to retrieve data for.

- `.filtertext`:

  The text to add to the filter list (mostly used internally).

------------------------------------------------------------------------

### Method `generate_summary()`

Generate a summary dataframe for the run history.

#### Usage

    STS2RunHistory$generate_summary()

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    STS2RunHistory$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
