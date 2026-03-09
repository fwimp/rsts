# R6 Class representing a set of Slay the Spire 2 Cards.

This is the general holding class for a set of sts2 Cards. It stores the
main card data for the player.

## Value

A new `STS2Cards` object.

## Public fields

- `cards`:

  A list of cards.

- `floorfound`:

  The floors upon which the cards were found.

- `upgradelevel`:

  The upgrade level of each card.

## Methods

### Public methods

- [`STS2Deck$new()`](#method-STS2Deck-new)

- [`STS2Deck$clone()`](#method-STS2Deck-clone)

------------------------------------------------------------------------

### Method `new()`

Create a new relics object from player data.

#### Usage

    STS2Deck$new(carddata)

#### Arguments

- `carddata`:

  The subset of the list output from jsonlite, usually passed in via
  `STS2Player`.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    STS2Deck$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
