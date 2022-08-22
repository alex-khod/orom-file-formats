meta:
  id: rage_of_mages_2_alm
  title: Rage Of Mages Seal Of Mystery map files
  file-extension: alm
  application: Rage Of Mages Seal Of Mystery
  license: CC0-1.0
  endian: le
seq:
  - id: alm_header
    type: alm_header
    size: 0x14
  - id: header
    type: section_header
    size: 0x14
  - id: general    
    type: general_sec
  - id: sections
    type: alm_section
    repeat: expr
    repeat-expr: alm_header.section_count-1
types:
  alm_header:
    seq:
      - id: magic
        contents: ["M7R", 0]
      - id: header_size
        type: u4
      - id: mysterious_size
        type: u4
        doc: 0x48 + H * W * 0x04
      - id: section_count
        type: u4
      - id: random_seed
        type: u4
        doc: this number is the same for all headers
  section_header:
    seq:
      - id: some_number
        type: u4
        doc: Number 7 or 5 with unknown purpose
      - id: header_size
        type: u4
      - id: data_size
        type: u4
      - id: section_kind
        type: u4
        enum: section_kind_e
      - id: random_seed
        type: u4
        doc: this number is the same for all headers
  alm_section:
    seq:
      - id: header
        type: section_header
        size: 0x14
      - id: body
        size: header.data_size
        type:
          switch-on: header.section_kind
          cases:
            section_kind_e::tiles: tiles_sec
            section_kind_e::heights: heights_sec
            section_kind_e::objects: objects_sec
            section_kind_e::structures: structures_sec
            section_kind_e::players: players_sec
            section_kind_e::units: units_sec
            section_kind_e::triggers: triggers_sec
            section_kind_e::sacks: sacks_sec
            section_kind_e::effects: effects_sec
  general_sec:
    seq:
      - id: width
        type: u4
      - id: height
        type: u4
      - id: negative_sun_angle
        type: f4
      - id: time_in_minutes
        type: u4
      - id: darkness
        type: u4
      - id: contrast
        type: u4
      - id: use_tiles
        type: u4
      - id: player_count
        type: u4
      - id: structure_count
        type: u4
      - id: unit_count
        type: u4
      - id: logic_count
        type: u4
      - id: sack_count
        type: u4
      - id: group_count
        type: u4
      - id: tavern_count
        type: u4
      - id: store_count
        type: u4
      - id: pointer_count
        type: u4
      - id: music_count
        type: u4      
      - id: map_name        
        size: 0x40        
      - id: rec_player_count
        type: u4
      - id: map_level
        type: u4
      - id: junk
        size: 8
      - id: author
        size: 0x200

  tiles_sec:
    seq:
      - id: tiles
        type: tile_entry
        size: 0x02
        repeat: expr
        repeat-expr: _root.general.width * _root.general.height
  tile_entry:
    seq:
      - id: tile_id
        type: u2
        doc: |
          Tile Id is, in fact, a composite identifier, which consists of
          terrainId, tileColumnId, and tileRowId. In addition, it also
          contains a passability flag.

          bool IsPassable   => (((tile_id & 0xFF00) / 0x100) & 0x20) != 0;
          byte TerrainId    => (byte) (((tile_id & 0xFF00) / 0x100) & 0x03);
          byte TileColumnId => (byte) ((tile_id & 0x00F0) / 0x10);
          byte TileRowId    => (byte) Math.Min(tile_id & 0x0F, TerrainId != 2 ? 13 : 7);

          Alternative way to calculate stuff

          bool IsPassable   => (tile_id >> 8) & 0x20;
          byte TerrainId    => (tile_id >> 8) & 0x03;
          byte TileColumnId => tile_id >> 4;
          byte TileRowId    => tile_id & 0x0F

  heights_sec:
    seq:
      - id: heights
        type: u1
        repeat: expr
        repeat-expr: _root.general.width * _root.general.height

  objects_sec:
    seq:
      - id: objects
        type: u1
        repeat: expr
        repeat-expr: _root.general.width * _root.general.height

  structures_sec:
    seq:
      - id: structures
        type: structure_entry
        repeat: expr
        repeat-expr: _root.general.structure_count

  structure_entry:
    seq:
      - id: x
        type: u4
        doc: (X * 0x100) + 0x80 (sort of a fixed point value)
      - id: y
        type: u4
        doc: (Y * 0x100) + 0x80 (sort of a fixed point value)
      - id: type_id
        type: u4
      - id: health
        type: u2
        doc: Condition of a structure in a range [0..100]
      - id: player_id
        type: u4
        doc: Value in a range [1..16] points to a player this structure belongs
      - id: id
        type: u2
      - id: bridge_details
        type: bridge_info
        if: (type_id == 33)

  bridge_info:
    seq:
      - id: width
        type: u4
      - id: height
        type: u4

  players_sec:
    seq:
      - id: players
        type: player_entry
        repeat: expr
        repeat-expr: _root.general.player_count

  player_entry:
    seq:
      - id: color_id
        type: u4
      - id: flags
        type: u4
        doc: Zero bit => Is Computer, First bit => Is Quest For Kill
      - id: money
        type: u4
      - id: name
        type: str
        size: 0x20
        encoding: ASCII
        terminator: 0
        doc: Player name. Ends with terminal zero
      - id: diplomacy_states
        type: u2
        repeat: expr
        repeat-expr: 0x10

  units_sec:
    seq:
      - id: units
        type: unit_entry
        repeat: expr
        repeat-expr: _root.general.unit_count
  unit_entry:
    seq:
      - id: x
        type: u4
        doc: (X * 0x100) + 0x80 (sort of a fixed point value)
      - id: y
        type: u4
        doc: (Y * 0x100) + 0x80 (sort of a fixed point value)
      - id: type_id
        type: u2
        doc: |
          In case of Server Id == 0 this id points to a Monster Kind, otherwise
          it is part of a composite identifier in humans declaration
      - id: face_id
        type: u2
        doc: |
          This identifier points to a portrait of a unit, and, in case of a
          monster, additionally describes its level (from 1 to 4)
      - id: flags
        type: u4
      - id: flags2
        type: u4
        doc: |  
          This value contains set of flags such as Is VIP(zero bit),
          Is Quest For Intercept(first bit), Is Quest For Escort(second bit),
          Is No XP For Kill(third bit). This knowledge was directly adapted
          from the ALM format for the ROM II and should be tested.
      - id: server_id
        type: u4
        doc: Helps to find a right entry in a humans declaration
      - id: player_id
        type: u4
        doc: Value in a range [1..16] points to a player this unit belongs
      - id: sack_id
        type: u4
        doc: |
          If not storing a zero value, points to an identifier of a sacks section
          entry, where the connected Sack(think about it as of a units inventory)
          described.
      - id: direction
        type: u4
        doc: |
          Storing value in a range [0..15] with a meaning of angle of view of a
          unit (where it looks at map start).
          Angle In Degrees = View Angle * 22.5f
      - id: hp
        type: s2
      - id: max_hp
        type: s2
      - id: unit_id
        type: u4
        doc: Identifier of a unit entry in units section
      - id: group_id
        type: u4
        doc: Giving the knowledge for which group this unit belongs

  triggers_sec:
    seq:
      - id: instance_count
        type: u4
      - id: instances
        type: instance_entry
        repeat: expr
        repeat-expr: instance_count
      - id: check_count
        type: u4
      - id: checks
        type: check_entry
        repeat: expr
        repeat-expr: check_count
      - id: trigger_count
        type: u4
      - id: triggers
        type: trigger_entry
        repeat: expr
        repeat-expr: trigger_count

  instance_entry:
    seq:
      - id: name
        type: str
        size: 0x40
        encoding: ASCII
        terminator: 0
      - id: type
        type: u4
        enum: instance_type
      - id: id
        type: u4
      - id: run_once_flag
        type: u4
      - id: argument_values
        type: u4
        repeat: expr
        repeat-expr: 10
      - id: argument_types
        type: u4
        enum: argument_type
        repeat: expr
        repeat-expr: 10
      - id: argument_names
        type: str
        size: 0x40
        encoding: ASCII
        terminator: 0
        repeat: expr
        repeat-expr: 10
  check_entry:
    seq:
      - id: name
        type: str
        size: 0x40
        encoding: ASCII
        terminator: 0
      - id: type
        type: u4
        enum: check_type
      - id: id
        type: u4
      - id: run_once_flag
        type: u4
      - id: argument_values
        type: u4
        repeat: expr
        repeat-expr: 10
      - id: argument_types
        type: u4
        enum: argument_type
        repeat: expr
        repeat-expr: 10
      - id: argument_names
        type: str
        size: 0x40
        encoding: ASCII
        terminator: 0
        repeat: expr
        repeat-expr: 10
  trigger_entry:
    seq:
      - id: name
        type: str
        size: 0x80
        encoding: ASCII
        terminator: 0
      - id: check_ids
        type: u4
        repeat: expr
        repeat-expr: 6
      - id: instance_ids
        type: u4
        repeat: expr
        repeat-expr: 4
      - id: check_operators
        type: u4
        repeat: expr
        repeat-expr: 3
        doc: 0,1,2 operators between 0 and 1, 2 and 3, 4 and 5 operand pairs
      - id: run_once_flag
        type: u4

  sacks_sec:
    seq:
      - id: sacks
        type: sack_entry
        repeat: expr
        repeat-expr: _root.general.sack_count
  sack_entry:
    seq:
      - id: item_count
        type: u4
      - id: unit_id
        type: u4
        doc: Id of a Unit connected to this sack
      - id: x
        type: u4
        doc: (X * 0x100) + 0x80 (sort of a fixed point value)
      - id: y
        type: u4
        doc: (Y * 0x100) + 0x80 (sort of a fixed point value)
      - id: money
        type: u4
      - id: items
        type: item_entry
        repeat: expr
        repeat-expr: item_count
  item_entry:
    seq:
      - id: item_id
        type: u4
      - id: wielded
        type: u2
      - id: effect_id
        type: u4

  effects_sec:
    seq:
      - id: effect_count
        type: u4
      - id: entries
        type: effect_entry
        repeat: expr
        repeat-expr: effect_count
  effect_entry:
    seq:
      - id: corrupt_effect_id
        type: u4
        doc: Not used. The real Effect Id is just order number in a table
      - id: trap_x
        type: u4
      - id: trap_y
        type: u4
      - id: flags_or_magic_sphere
        type: u2
        doc: For flags it's Zero bit => From Structure, First Bit => To Unit
      - id: service_data
        type: u8
      - id: modifier_count
        type: u4
      - id: modifiers
        type: effect_modifier
        repeat: expr
        repeat-expr: modifier_count

  effect_modifier:
    seq:
      - id: modifier_type
        type: u2
      - id: modifier_value
        type: u4

enums:
  section_kind_e:
    0: general
    1: tiles
    2: heights
    3: objects
    4: structures
    5: players
    6: units
    7: triggers
    8: sacks
    9: effects

  argument_type:
    0x01: number
    0x02: group
    0x03: player
    0x04: unit
    0x05: x
    0x06: y
    0x07: constant
    0x08: item
    0x09: structure

  check_type:
    0x00: unknown
    0x01: group_unit_count
    0x02: is_unit_in_a_box
    0x03: is_unit_in_a_circle
    0x04: get_unit_parameter
    0x05: is_unit_alive
    0x06: get_distance_between_units
    0x07: get_distance_from_point_to_unit
    0x08: how_many_units_player_have
    0x09: is_unit_attacked
    0x0A: get_diplomacy
    0x0B: check_sack
    0x0F: get_distance_to_nearest_player_unit
    0x10: get_distance_from_point_to_unit_with_item
    0x11: is_item_in_sack
    0x12: vip
    0x13: check_variable
    0x14: how_many_structures_player_have
    0x15: get_structure_health
    0x16: teleport
    0x17: check_scenario_variable
    0x18: check_sub_objective
    0x19: spell_in_area
    0x1A: spell_on_unit
    0x1B: is_unit_in_point
    0x10002: constant

  instance_type:
    0x00: unknown
    0x01: increment_mission_stage
    0x02: send_message
    0x03: set_variable_value
    0x04: force_mission_complete
    0x05: force_mission_failed
    0x06: command
    0x07: keep_formation
    0x08: increment_variable
    0x0A: set_diplomacy
    0x0B: give_item
    0x0C: add_item_in_units_sack
    0x0D: remove_item_from_units_sack
    0x10: hide_unit
    0x11: show_unit
    0x12: metamorph_unit
    0x13: change_units_owner
    0x14: drop_all
    0x15: magic_on_area
    0x16: change_groups_owner
    0x17: give_money_to_player
    0x18: magic_on_unit
    0x19: create_magic_trigger
    0x1A: set_structure_health
    0x1B: move_unit_immediate
    0x1C: give_all_items_from_unit_to_unit
    0x1E: timed_spell_on_ground
    0x1F: change_respawn_time
    0x20: hide_group
    0x21: show_group
    0x22: set_units_parameter
    0x23: set_scenario_variable
    0x24: set_sub_objective
    0x25: set_music_order
    0x26: remove_item_from_all
    0x27: stop_group
    0x10002: start_here
    0x10003: respawn_group
    0x10004: change_music_to

  check_operator:
    0x00: equals
    0x01: not_equals
    0x02: greater_than
    0x03: lower_than
    0x04: greater_than_equals
    0x05: lower_than_equals
