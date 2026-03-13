# Slay the Spire 2 player (R6).

This is the general holding class for an sts2 player. It stores the main
player data for the run.

## Value

A new STS2Player object.

## Public fields

- `run`:

  The [STS2Run](https://fwimp.github.io/rsts/reference/STS2Run.md)
  object that this player object originates from.

- `playercharacter`:

  The character that the player was playing

- `deck`:

  The deck of the player at the end of the run. An
  [STS2Deck](https://fwimp.github.io/rsts/reference/STS2Deck.md) object.

- `id`:

  The steam player id or 1 if single player.

- `max_potion_slot_count`:

  The maximum number of potions a player could hold.

- `potions`:

  The potions held by the player at the end of the run.

- `relics`:

  The relics held by the player at the end of the run. An
  [STS2Relics](https://fwimp.github.io/rsts/reference/STS2Relics.md)
  object

## Active bindings

- `max_health`:

  The max health of the character at the end of the run.

## Methods

### Public methods

- [`STS2Player$new()`](#method-STS2Player-new)

- [`STS2Player$print()`](#method-STS2Player-print)

- [`STS2Player$clone()`](#method-STS2Player-clone)

------------------------------------------------------------------------

### Method `new()`

Create a new run object from player data.

#### Usage

    STS2Player$new(playerdata, run = NULL, idx = 1)

#### Arguments

- `playerdata`:

  The subset of the list output from jsonlite, usually passed in via
  [STS2Run](https://fwimp.github.io/rsts/reference/STS2Run.md).

- `run`:

  The STS2Run object that this player object originates from.

- `idx`:

  The index within the player list from which this player originates.

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print an STS2Player object.

#### Usage

    STS2Player$print(..., full = FALSE, floor = FALSE)

#### Arguments

- `...`:

  Arguments to pass to [`print()`](https://rdrr.io/r/base/print.html).

- `full`:

  Whether to show the full deck and relics of the player.

- `floor`:

  Whether to show the floor on which a card/relic was obtained when
  `full = TRUE`.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    STS2Player$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
