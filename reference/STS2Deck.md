# Set of Slay the Spire 2 Cards (R6).

This is the general holding class for a set of sts2 Cards. It stores the
main card data for the player.

## Value

A new STS2Deck object.

## Public fields

- `player`:

  The [STS2Player](https://fwimp.github.io/rsts/reference/STS2Player.md)
  object this deck belongs to.

- `cards`:

  A list of cards.

- `floorfound`:

  The floors upon which the cards were found.

- `upgradelevel`:

  The upgrade level of each card.

- `enchantments`:

  The enchantments assigned to each card

- `enchantamt`:

  The amount of an enchantment assigned to each card

## Methods

### Public methods

- [`STS2Deck$new()`](#method-STS2Deck-new)

- [`STS2Deck$print()`](#method-STS2Deck-print)

- [`STS2Deck$clone()`](#method-STS2Deck-clone)

------------------------------------------------------------------------

### Method `new()`

Create a new deck object from player data.

#### Usage

    STS2Deck$new(carddata, player = NULL)

#### Arguments

- `carddata`:

  The subset of the list output from jsonlite, usually passed in via
  [STS2Player](https://fwimp.github.io/rsts/reference/STS2Player.md).

- `player`:

  The [STS2Player](https://fwimp.github.io/rsts/reference/STS2Player.md)
  object this deck belongs to.

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print an STS2Deck object.

#### Usage

    STS2Deck$print(..., floor = FALSE)

#### Arguments

- `...`:

  Unused.

- `floor`:

  Whether to show the floor on which a card was obtained.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    STS2Deck$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
