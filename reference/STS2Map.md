# Map points in a Slay The Spire 2 run (R6).

This is the general holding class for STS2 map points.

## Value

A new STS2Map object.

## Public fields

- `run`:

  The run

- `floors`:

  The floors in the map. A list of
  [STS2Floor](https://fwimp.github.io/rsts/reference/STS2Floor.md)
  objects.

## Methods

### Public methods

- [`STS2Map$new()`](#method-STS2Map-new)

- [`STS2Map$clone()`](#method-STS2Map-clone)

------------------------------------------------------------------------

### Method `new()`

Create a new map object from map data.

#### Usage

    STS2Map$new(mapdata, run = NULL)

#### Arguments

- `mapdata`:

  The subset of the list output from jsonlite, usually passed in via
  [STS2Player](https://fwimp.github.io/rsts/reference/STS2Player.md).

- `run`:

  The [STS2Run](https://fwimp.github.io/rsts/reference/STS2Run.md)
  object this map belongs to.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    STS2Map$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
