# A Slay the Spire 2 player, mid-run (R6).

This is the general holding class for a sts2 player at a point in the
run.

## Value

A new `STS2PlayerMidrun` object.

## Note

All fields in this are considered to be "at the end of this floor". For
example current_hp on a floor where a player dies will be 0, even if
they entered the fight with more than 0 HP.

## Public fields

- `floor`:

  The `STS2Floor` object this midrun object refers to.

- `player`:

  The `STS2Player` object this midrun object refers to.

- `current_gold`:

  Current gold.

- `current_hp`:

  Current health.

- `damage_taken`:

  Damage taken during the floor.

- `gold_gained`:

  Gold gained.

- `gold_lost`:

  Gold lost.

- `gold_spent`:

  Gold spent.

- `gold_stolen`:

  Gold stolen (damn gremlins).

- `hp_healed`:

  Health recovered during the floor.

- `max_hp`:

  Max health.

- `max_hp_gained`:

  Max health gained during the floor.

- `max_hp_lost`:

  Max health lost during the floor.

- `player_id`:

  The id of the player within the run data.

- `ancient_choice`:

  The choices available from the ancient (and which was picked).

- `bought_colorless`:

  The colorless cards bought during the floor.

- `bought_potions`:

  The potions bought during the floor.

- `bought_relics`:

  The relics bought during the floor.

- `card_choices`:

  The card choices available.

- `cards_enchanted`:

  The cards enchanted during the floor.

- `cards_gained`:

  The cards gained from the floor.

- `cards_removed`:

  The cards removed during the floor.

- `cards_transformed`:

  The cards transformed during the floor.

- `completed_quests`:

  The quests completed on the floor.

- `event_choices`:

  The choices made during the event (not in a particularly useful form).

- `potion_choices`:

  The potion choices available.

- `potion_discarded`:

  The potions discarded during the floor.

- `potion_used`:

  The potions used during the floor.

- `relic_choices`:

  The choices available from the floor (and which was picked).

- `relics_removed`:

  The relics removed during the floor.

- `rest_site_choices`:

  The rest site choices (and which was picked).

- `upgraded_cards`:

  The cards upgraded during the floor.

## Methods

### Public methods

- [`STS2PlayerMidrun$new()`](#method-STS2PlayerMidrun-new)

- [`STS2PlayerMidrun$clone()`](#method-STS2PlayerMidrun-clone)

------------------------------------------------------------------------

### Method `new()`

Create a new mid-run player object from player data.

#### Usage

    STS2PlayerMidrun$new(playerstats, floor = NULL, player = NULL)

#### Arguments

- `playerstats`:

  The individual player_stats output from jsonlite, usually passed in
  via `STS2Player`.

- `floor`:

  The `STS2Floor` object this midrun object refers to.

- `player`:

  The `STS2Player` object this midrun object refers to.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    STS2PlayerMidrun$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
