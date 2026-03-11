# Slay the Spire 2 floor (R6).

This is the general holding class for a sts2 floor.

## Value

A new `STS2Floor` object.

## Public fields

- `act`:

  The act this floor appeared in.

- `map`:

  The `STS2Map` object this floor belongs to.

- `floor_type`:

  The type of floor that this is.

- `player_stats`:

  The stats of the player/s at the end of this floor. A list of
  `STS2PlayerMidrun` objects.

- `turns_taken`:

  The number of turns this room took.

- `model_id`:

  The model id of the encounter (or `NULL` if rest site/treasure room).

- `monsters`:

  The monsters present on the floor.

- `rooms`:

  A list of the unparsed room data.

## Methods

### Public methods

- [`STS2Floor$new()`](#method-STS2Floor-new)

- [`STS2Floor$clone()`](#method-STS2Floor-clone)

------------------------------------------------------------------------

### Method `new()`

Create a new floor object from floor data.

#### Usage

    STS2Floor$new(floordata, act = 0, map = NULL)

#### Arguments

- `floordata`:

  The individual floor-level output from jsonlite, usually passed in via
  `STS2Map`.

- `act`:

  The act this floor appeared in.

- `map`:

  The `STS2Map` object this floor belongs to.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    STS2Floor$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
