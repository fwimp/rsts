# R6 Class representing a set of Slay the Spire 2 relics.

This is the general holding class for a set of sts2 relics. It stores
the main relic data for the player.

## Value

A new `STS2Relics` object.

## Public fields

- `relicnames`:

  A list of relics.

- `floorfound`:

  The floors upon which the relics were found.

- `extra_data`:

  The extra_data associated with the relics (unparsed)

## Methods

### Public methods

- [`STS2Relics$new()`](#method-STS2Relics-new)

- [`STS2Relics$clone()`](#method-STS2Relics-clone)

------------------------------------------------------------------------

### Method `new()`

Create a new relics object from player data.

#### Usage

    STS2Relics$new(relicdata)

#### Arguments

- `relicdata`:

  The subset of the list output from jsonlite, usually passed in via
  `STS2Player`.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    STS2Relics$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
