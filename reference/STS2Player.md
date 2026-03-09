# R6 Class representing a Slay the Spire 2 player.

This is the general holding class for an sts2 player. It stores the main
player data for the run.

## Value

A new `STS2Player` object.

## Public fields

- `run`:

  The `STS2Run` object that this player object originates from.

- `character`:

  The character that the player was playing

- `deck`:

  The deck of the player at the end of the run.

- `id`:

  The internal player id within the run.

- `max_potion_slot_count`:

  The maximum number of potions a player could hold.

- `potions`:

  The potions held by the player at the end of the run.

- `relics`:

  The relics held by the player at the end of the run.

- `max_health`:

  The max health of the character at the end of the run.

## Methods

### Public methods

- [`STS2Player$new()`](#method-STS2Player-new)

- [`STS2Player$clone()`](#method-STS2Player-clone)

------------------------------------------------------------------------

### Method `new()`

Create a new run object from player data.

#### Usage

    STS2Player$new(playerdata, run = NULL)

#### Arguments

- `playerdata`:

  The subset of the list output from jsonlite, usually passed in via
  `STS2Run`.

- `run`:

  The STS2Run object that this player object originates from.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    STS2Player$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
