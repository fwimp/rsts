# Slay the Spire 2 run history (R6).

This is the general holding class for a full history of sts2 runs.

It can be indexed like a list (i.e. `x[1]` or `x[[1]]`).

## Value

A new `STS2RunHistory` object.

Nothing (called for side-effect)

A list of `STS2Player` objects containing only selected characters.

An `STS2RunHistory` object containing only selected seeds.

An `STS2RunHistory` object containing only selected seeds.

An `STS2RunHistory` object containing only selected outcomes.

An `STS2RunHistory` object containing only selected ascensions.

## Note

`STS2Run` objects are passed by reference. As such if you modify a run
in a filtered history, those changes will appear in the original list.

`STS2Run` objects are passed by reference. As such if you modify a run
in a filtered history, those changes will appear in the original list.

`STS2Run` objects are passed by reference. As such if you modify a run
in a filtered history, those changes will appear in the original list.

`STS2Run` objects are passed by reference. As such if you modify a run
in a filtered history, those changes will appear in the original list.

## Public fields

- `runs`:

  The parsed run logs. A list of `STS2Run` objects.

- `ownerid`:

  The steam ID of the run history owner.

- `filtersteps`:

  The filtering steps performed on this run history.

## Methods

### Public methods

- [`STS2RunHistory$new()`](#method-STS2RunHistory-new)

- [`STS2RunHistory$print()`](#method-STS2RunHistory-print)

- [`STS2RunHistory$get_individual_player_data()`](#method-STS2RunHistory-get_individual_player_data)

- [`STS2RunHistory$get_character()`](#method-STS2RunHistory-get_character)

- [`STS2RunHistory$filter_seed()`](#method-STS2RunHistory-filter_seed)

- [`STS2RunHistory$filter_character()`](#method-STS2RunHistory-filter_character)

- [`STS2RunHistory$filter_outcome()`](#method-STS2RunHistory-filter_outcome)

- [`STS2RunHistory$filter_byascension()`](#method-STS2RunHistory-filter_byascension)

- [`STS2RunHistory$clone()`](#method-STS2RunHistory-clone)

------------------------------------------------------------------------

### Method `new()`

Create a new run history container from a list of `STS2Run` objects.

#### Usage

    STS2RunHistory$new(historydata, steamid = NULL, filtersteps = NULL)

#### Arguments

- `historydata`:

  A list of `STS2Run` objects.

- `steamid`:

  The owner's steamid (for differentiating in the case of multiplayer
  runs).

- `filtersteps`:

  The filtering steps performed on this run history.

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

### Method `get_character()`

Retrieve data for character/s across the run history.

#### Usage

    STS2RunHistory$get_character(char, onlyowner = FALSE)

#### Arguments

- `char`:

  The character/s to retrieve data for.

- `onlyowner`:

  If TRUE, only retrieve runs where the owner was the character
  specified.

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

### Method `filter_byascension()`

Retrieve runs with desired ascensions across the run history.

#### Usage

    STS2RunHistory$filter_byascension(
      ascension = 0,
      .filtertext = "filtered by ascension"
    )

#### Arguments

- `ascension`:

  The ascensions to retrieve data for.

- `.filtertext`:

  The text to add to the filter list (mostly used internally).

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    STS2RunHistory$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
