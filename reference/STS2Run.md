# Slay the Spire 2 run (R6).

This is the general holding class for an sts2 run. It stores the main
metadata and lists containing more in-depth run data.

## Value

A new STS2Run object.

## Public fields

- `acts`:

  A vector of the acts that the player encountered.

- `ascension`:

  The ascension level of the run.

- `build_id`:

  The build of the game that this run was generated from.

- `game_mode`:

  The game mode that the player was playing.

- `killed_by_encounter`:

  The encounter that killed the player.

- `killed_by_event`:

  The event that killed the player.

- `map`:

  A list storing the play-by-play of the run. An
  [STS2Map](https://fwimp.github.io/rsts/reference/STS2Map.md) object.

- `modifiers`:

  Any modifiers that the player had turned on.

- `platform_type`:

  The platform of the game (e.g. steam).

- `players`:

  A list of player information. A list of
  [STS2Player](https://fwimp.github.io/rsts/reference/STS2Player.md)
  objects.

- `run_time`:

  The run duration (in seconds).

- `schema_version`:

  The run schema version.

- `seed`:

  The seed of the run.

- `start_time`:

  The start time (in seconds from unix epoch, UTC).

- `was_abandoned`:

  Whether the player abandoned the run.

- `win`:

  Whether the player won the run.

- `ownerid`:

  The steam ID of the run owner.

## Active bindings

- `outcome`:

  The outcome of the run.

- `numplayers`:

  The number of players in the run.

- `numfloors`:

  The number of floors in the run.

## Methods

### Public methods

- [`STS2Run$new()`](#method-STS2Run-new)

- [`STS2Run$print()`](#method-STS2Run-print)

- [`STS2Run$get_individual_player_data()`](#method-STS2Run-get_individual_player_data)

- [`STS2Run$get_character()`](#method-STS2Run-get_character)

- [`STS2Run$get_cards()`](#method-STS2Run-get_cards)

- [`STS2Run$clone()`](#method-STS2Run-clone)

------------------------------------------------------------------------

### Method `new()`

Create a new run object from data parsed with jsonlite.

#### Usage

    STS2Run$new(rundata, steamid = NULL)

#### Arguments

- `rundata`:

  The list output from jsonlite containing the run data.

- `steamid`:

  The owner's steamid (for differentiating in the case of multiplayer
  runs).

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print an STS2Run object.

#### Usage

    STS2Run$print(..., full = FALSE)

#### Arguments

- `...`:

  Unused.

- `full`:

  Whether to print extra internal run information.

------------------------------------------------------------------------

### Method `get_individual_player_data()`

Retrieve player data for a given player from a run.

#### Usage

    STS2Run$get_individual_player_data(id = NULL)

#### Arguments

- `id`:

  the Steam ID of the player data to retrieve (or `NULL` to retrieve the
  data of the run owner).

------------------------------------------------------------------------

### Method `get_character()`

Retrieve data for a character.

#### Usage

    STS2Run$get_character(char, onlyowner = FALSE)

#### Arguments

- `char`:

  The character/s to retrieve data for.

- `onlyowner`:

  If TRUE, only retrieve entries where the owner was the character
  specified.

------------------------------------------------------------------------

### Method `get_cards()`

Retrieve all the cards present in a run.

#### Usage

    STS2Run$get_cards(ignore_basics = FALSE, return_unique = FALSE, char = NULL)

#### Arguments

- `ignore_basics`:

  Don't return basic cards.

- `return_unique`:

  Return only 1 entry per unique card.

- `char`:

  The character/s to filter by (or `NULL` to return all).

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    STS2Run$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
