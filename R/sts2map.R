#' Map points in a Slay The Spire 2 run (R6).
#'
#' @description
#' This is the general holding class for STS2 map points.

STS2Map <- R6Class("STS2Map",
  public = list(
    #' @field run The run
    run = NULL,

    #' @field floors The floors in the map. A list of [STS2Floor] objects.
    floors = list(),

    #' @description
    #' Create a new map object from map data.
    #'
    #' @param mapdata The subset of the list output from jsonlite, usually passed in via [STS2Player].
    #' @param run The [STS2Run] object this map belongs to.
    #' @returns A new [STS2Map] object.
    #'
    initialize = function(mapdata, run = NULL) {
      self$run <- run
      mapdata_parsed <- lapply(1:length(mapdata), \(i) {
        lapply(mapdata[[i]], \(x) {STS2Floor$new(x, act = i, map = self)})
      })
      self$floors <- unlist(mapdata_parsed)
    }
  ),
  private = list())

#' @export
length.STS2Map <- function(x) {
  length(x$floors)
}

#' Slay the Spire 2 floor (R6).
#'
#' @description
#' This is the general holding class for a sts2 floor.
#'
STS2Floor <- R6Class("STS2Floor",
  public = list(
    #' @field act The act this floor appeared in.
    act = 0,

    #' @field map The [STS2Map] object this floor belongs to.
    map = NULL,

    #' @field floor_type The type of floor that this is.
    floor_type = "",

    #' @field player_stats The stats of the player/s at the end of this floor. A list of [STS2PlayerMidrun] objects.
    player_stats = list(),

    #' @field turns_taken The number of turns this room took.
    turns_taken = 0,

    #' @field model_id The model id of the encounter (or `NULL` if rest site/treasure room).
    model_id = NULL,

    #' @field monsters The monsters present on the floor.
    monsters = NULL,

    #' @field rooms A list of the unparsed room data.
    rooms = list(),

    #' @description
    #' Create a new floor object from floor data.
    #'
    #' @param floordata The individual floor-level output from jsonlite, usually passed in via [STS2Map].
    #' @param map The [STS2Map] object this floor belongs to.
    #' @param act The act this floor appeared in.
    #' @returns A new [STS2Floor] object.
    #'
    initialize = function(floordata, act = 0, map = NULL) {
      # browser()
      self$act <- act
      self$map <- map
      self$floor_type <- floordata$map_point_type
      # Will need better parsing later
      # It seems like there's only ever 1 entry in the rooms field.
      if(length(floordata$rooms) > 2) {
        seed <- self$map$run$seed
        cli::cli_warn("More than two rooms ({length(floordata$rooms)}) in floor data. Seed: {seed}, Act: {self$act}, Type: {self$floor_type}. Please report if you see this.")
      }
      # extract out room1 as we usually just need that
      room1 <- floordata$rooms[[1]]
      self$turns_taken <- sum(sapply(floordata$rooms, \(x) {x$turns_taken}))
      if (self$floor_type == "unknown") {
        if (!is.null(room1$room_type)) {
          self$floor_type <- room1$room_type
        } else {
          self$floor_type <- "event"
        }
      }
      if (!is.null(room1$model_id)) {
        # If there's two rooms, we still only want the first.
        self$model_id <- format_sts2id(as.character(room1$model_id))
      }
      if (length(floordata$rooms) > 1) {
        # Get monsters from all rooms (filter for rooms with monsters and then put together all those)
        self$monsters <- as.character(sapply(floordata$rooms[which(sapply(floordata$rooms, \(x) {!is.null(x$monster_ids)}))],
                                \(y) {format_sts2id(as.character(y$monster_ids))}
                                ))
      } else {
        if (!is.null(room1$monster_ids)) {
          self$monsters <- format_sts2id(as.character(room1$monster_ids))
        }
      }
      # Save the raw room data just in case it's needed
      self$rooms <- floordata$rooms

      self$player_stats <- lapply(1:length(floordata$player_stats), \(i) {
        playerinfo <- self$map$run$players[[i]]
        player_stats <- floordata$player_stats[[i]]
        STS2PlayerMidrun$new(player_stats, floor = self, player = playerinfo)
      })
    }
  ),
  private = list())

#' A Slay the Spire 2 player, mid-run (R6).
#'
#' @description
#' This is the general holding class for a sts2 player at a point in the run.
#'
#' @note
#' All fields in this are considered to be "at the end of this floor".
#' For example current_hp on a floor where a player dies will be 0, even if they entered the fight with more than 0 HP.
#'
STS2PlayerMidrun <- R6Class("STS2PlayerMidrun",
  public = list(
    #' @field floor The [STS2Floor] object this midrun object refers to.
    floor = NULL,

    #' @field player The [STS2Player] object this midrun object refers to.
    player = NULL,

    # Consistent data
    #' @field current_gold Current gold.
    current_gold = 0,

    #' @field current_hp Current health.
    current_hp = 0,

    #' @field damage_taken Damage taken during the floor.
    damage_taken = 0,

    #' @field gold_gained Gold gained.
    gold_gained = 0,

    #' @field gold_lost Gold lost.
    gold_lost = 0,

    #' @field gold_spent Gold spent.
    gold_spent = 0,

    #' @field gold_stolen Gold stolen (damn gremlins).
    gold_stolen = 0,

    #' @field hp_healed Health recovered during the floor.
    hp_healed = 0,

    #' @field max_hp Max health.
    max_hp = 0,

    #' @field max_hp_gained Max health gained during the floor.
    max_hp_gained = 0,

    #' @field max_hp_lost Max health lost during the floor.
    max_hp_lost = 0,

    #' @field player_id The id of the player within the run data.
    player_id = 0,

    # Floor-specific data

    #' @field ancient_choice The choices available from the ancient (and which was picked).
    ancient_choice = list(),

    #' @field bought_colorless The colorless cards bought during the floor.
    bought_colorless = list(),

    #' @field bought_potions The potions bought during the floor.
    bought_potions = list(),

    #' @field bought_relics The relics bought during the floor.
    bought_relics = list(),

    #' @field card_choices The card choices available.
    card_choices = list(),

    #' @field cards_enchanted The cards enchanted during the floor.
    cards_enchanted = list(),

    #' @field cards_gained The cards gained from the floor.
    cards_gained = list(),

    #' @field cards_removed The cards removed during the floor.
    cards_removed = list(),

    #' @field cards_transformed The cards transformed during the floor.
    cards_transformed = list(),

    #' @field completed_quests The quests completed on the floor.
    completed_quests = list(),

    #' @field event_choices The choices made during the event (not in a particularly useful form).
    event_choices = list(),

    #' @field potion_choices The potion choices available.
    potion_choices = list(),

    #' @field potion_discarded The potions discarded during the floor.
    potion_discarded = list(),

    #' @field potion_used The potions used during the floor.
    potion_used = list(),

    #' @field relic_choices The choices available from the floor (and which was picked).
    relic_choices = list(),

    #' @field relics_removed The relics removed during the floor.
    relics_removed = list(),

    #' @field rest_site_choices The rest site choices (and which was picked).
    rest_site_choices = list(),

    #' @field upgraded_cards The cards upgraded during the floor.
    upgraded_cards = list(),


    #' @description
    #' Create a new mid-run player object from player data.
    #'
    #' @param playerstats The individual player_stats output from jsonlite, usually passed in via [STS2Player].
    #' @param floor The [STS2Floor] object this midrun object refers to.
    #' @param player The [STS2Player] object this midrun object refers to.
    #' @returns A new [STS2PlayerMidrun] object.
    #'
    initialize = function(playerstats, floor = NULL, player = NULL) {
      # browser()
      self$floor <- floor
      self$player <- player
      # Consistent player stats
      continuous_player_stats <- c("current_gold", "current_hp", "damage_taken",
        "gold_gained", "gold_lost", "gold_spent", "gold_stolen", "hp_healed",
        "max_hp", "max_hp_gained", "max_hp_lost", "player_id")
      for (x in continuous_player_stats) {
        self[[x]] <- playerstats[[x]]
      }

      # Variable player stats
      # TODO: Temporary until custom parsers can be implemented
      variable_player_stats <- c("ancient_choice", "bought_colorless", "bought_potions", "bought_relics",
        "card_choices", "cards_enchanted", "cards_gained", "cards_removed",
        "cards_transformed", "completed_quests", "event_choices", "potion_choices",
        "potion_discarded", "potion_used", "relic_choices", "relics_removed",
        "rest_site_choices", "upgraded_cards")
      for (x in variable_player_stats) {
        if (!is.null(playerstats[[x]])) {
          self[[x]] <- playerstats[[x]]
        }
      }

      # if (!is.null(playerstats$ancient_choice)) {
      #   self$ancient_choice <- playerstats$ancient_choice
      # }
      #
      # if (!is.null(playerstats$bought_colorless)) {
      #   self$bought_colorless <- playerstats$bought_colorless
      # }
      #
      # if (!is.null(playerstats$bought_potions)) {
      #   self$bought_potions <- playerstats$bought_potions
      # }
      #
      # if (!is.null(playerstats$bought_relics)) {
      #   self$bought_relics <- playerstats$bought_relics
      # }
      #
      # if (!is.null(playerstats$card_choices)) {
      #   self$card_choices <- playerstats$card_choices
      # }
      #
      # if (!is.null(playerstats$cards_enchanted)) {
      #   self$cards_enchanted <- playerstats$cards_enchanted
      # }
      #
      # if (!is.null(playerstats$cards_gained)) {
      #   self$cards_gained <- playerstats$cards_gained
      # }
      #
      # if (!is.null(playerstats$cards_removed)) {
      #   self$cards_removed <- playerstats$cards_removed
      # }
      #
      # if (!is.null(playerstats$cards_transformed)) {
      #   self$cards_transformed <- playerstats$cards_transformed
      # }
      #
      # if (!is.null(playerstats$completed_quests)) {
      #   self$completed_quests <- playerstats$completed_quests
      # }
      #
      # if (!is.null(playerstats$event_choices)) {
      #   self$event_choices <- playerstats$event_choices
      # }
      #
      # if (!is.null(playerstats$potion_choices)) {
      #   self$potion_choices <- playerstats$potion_choices
      # }
      #
      # if (!is.null(playerstats$potion_discarded)) {
      #   self$potion_discarded <- playerstats$potion_discarded
      # }
      #
      # if (!is.null(playerstats$potion_used)) {
      #   self$potion_used <- playerstats$potion_used
      # }
      #
      # if (!is.null(playerstats$relic_choices)) {
      #   self$relic_choices <- playerstats$relic_choices
      # }
      #
      # if (!is.null(playerstats$relics_removed)) {
      #   self$relics_removed <- playerstats$relics_removed
      # }
      #
      # if (!is.null(playerstats$rest_site_choices)) {
      #   self$rest_site_choices <- playerstats$rest_site_choices
      # }
      #
      # if (!is.null(playerstats$upgraded_cards)) {
      #   self$upgraded_cards <- playerstats$upgraded_cards
      # }
    }
  ),
  private = list())
