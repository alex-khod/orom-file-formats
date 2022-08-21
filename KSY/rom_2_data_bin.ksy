meta:
  id: rage_of_mages_2_data_bin
  title: Rage Of Mages data bin
  file-extension: bin
  application: Rage Of Mages
  license: CC0-1.0
  endian: le
seq:  
  - id: item_class_attrnames
    type: attrnames
  - id: item_class_count
    type: u4
  - id: item_classes
    type: t_item_class
    repeat: expr
    repeat-expr: item_class_count     
  - id: material_count
    type: u4
  - id: materials
    type: t_item_class
    repeat: expr
    repeat-expr: material_count
  - id: modifier_attrnames
    type: attrnames  
  - id: modifier_count
    type: u4
  - id: modifiers
    type: t_modifier
    repeat: expr
    repeat-expr: modifier_count
  #
  - id: equipment_attrnames
    type: attrnames
  - id: armor_count
    type: u4
  - id: armors
    type: t_equipment
    repeat: expr
    repeat-expr: armor_count-1
  - id: shield_count
    type: u4
  - id: shields
    type: t_equipment
    repeat: expr
    repeat-expr: shield_count-1
  - id: weapon_count
    type: u4
  - id: weapons
    type: t_equipment
    repeat: expr
    repeat-expr: weapon_count-1
  #
  - id: magic_item_attrnames
    type: attrnames
  - id: magic_item_count
    type: u4
  - id: magic_items
    type: t_magic_item
    repeat : expr
    repeat-expr: magic_item_count-1
  #
  - id: monster_attrnames
    type: attrnames
  - id: monster_count
    type: u4  
  - id: monster_headers
    type: t_monster_header
    repeat : expr
    repeat-expr: monster_count - 1
  #
  - id: human_attrnames
    type: attrnames
  - id: human_count
    type: u4
  - id: human_headers   
    type: t_human_header
    repeat : expr
    repeat-expr: human_count - 1
  #
  - id: structure_attrnames
    type: attrnames
  - id: structure_count
    type: u4
  - id: structures    
    type: t_structure
    repeat : expr
    repeat-expr: structure_count - 1
  #
  - id: spell_attrnames
    type: attrnames
  - id: spell_count
    type: u4
  - id: spell_headers    
    type: t_spell_header
    repeat : expr
    repeat-expr: spell_count - 2
types:    
    u1str:        
        seq:
            - id: length              
              type: u1
            - id: value              
              type: str
              size: length
              encoding: 866            
    attrnames:
        seq:
            - id: header_count
              type: u2
            - id: attrnames
              type: u1str              
              repeat: expr
              repeat-expr: header_count        
    t_item_class:
        seq:
            - id: name
              type: u1str
            - id: abbreviate_and_materials              
              size : 16                           
              doc: unused            
            - id: price
              type: f8            
            - id: weight
              type: f8
            - id: damage
              type: f8
            - id: to_hit
              type: f8
            - id: defence
              type: f8
            - id: absorption
              type: f8
            - id: mag_cap
              type: f8
    t_modifier:
        seq:
            - id: name
              type: u1str
            - id: field_count
              type: u2
            - id : mana_cost
              type: s4
            - id : affect_min
              type: s4
            - id : affect_max
              type: s4
            - id : usable_by
              type: s4
            - id : slots_fighter
              type: s4
              repeat: expr
              repeat-expr: 12
            - id : slots_mage
              type: s4            
              repeat: expr
              repeat-expr: 12
    t_equipment:
        seq:
            - id: name
              type: u1str
            - id: field_count
              type: u2
            - id: shape
              type: s4
            - id: material
              type: s4
            - id: price
              type: s4
            - id: weight
              type: s4
            - id: slot
              type: s4
            - id: attack_type
              type: s4
            - id: physical_min
              type: s4
            - id: physical_max
              type: s4
            - id: to_hit
              type: s4
            - id: defence
              type: s4
            - id: absorption
              type: s4
            - id: range
              type: s4
            - id: charge
              type: s4
            - id: relax
              type: s4
            - id: two_handed
              type: s4
            - id: suitable_for
              type: s4              
            - id: other_parameter
              type: s4
            - id: usable_by_class
              type: u2
              repeat: expr
              repeat-expr: 8
    t_magic_item:
        seq:
            - id: name
              type: u1str
            - id: field_count
              type: u2
            - id: price
              type: s4
            - id: weight
              type: s4
            - id: has_effect
              type: u1
            - id: effect
              type: u1str
              if: has_effect != 0
    t_monster_header:
        seq:
            - id: name
              type: u1str
            - id: field_count
              type: u2
            - id: junk
              size: 2
              if: field_count == 0
            - id: body
              type: t_monster
              if: field_count != 0
    t_monster:
        seq:
            - id: stats
              type: s4
              repeat: expr
              repeat-expr: 4 #body, reaction, mind, spirit
            - id: health_max
              type: s4
            - id: health_regeneration
              type: s4
            - id: mana_max
              type: s4
            - id: mana_regeneration
              type: s4               
            - id: speed
              type: s4               
            - id: rotation_speed
              type: s4               
            - id: scan_range
              type: s4              
            - id: physical_min
              type: s4
            - id: physical_max
              type: s4
            - id: attack_type
              type: s4
            - id: to_hit
              type: s4
            - id: defence
              type: s4
            - id: absorption
              type: s4
            - id: charge
              type: s4
            - id: relax
              type: s4
            - id: protection_magic
              type: s4
              repeat: expr
              repeat-expr: 5 #fire, water, air, earth, astral
            - id: protection_physical
              type: s4
              repeat: expr
              repeat-expr: 5 #blade, axe, bludgeon, pike, shooting
            - id: type_id
              type: s4
            - id: face
              type: s4
            - id: token_size
              type: s4
            - id: movement_type
              type: s4
            - id: dying_time
              type: s4
            - id: withdraw
              type: s4
            - id: wimpy
              type: s4
            - id: see_invisible
              type: s4
            - id: experience
              type: s4
            - id: treasure
              type: s4
              repeat: expr
              repeat-expr: 7
              # gold, goldmin, goldmax
              # item, itemmin, itemmax, itemmask
            - id: junk2
              size: 8
            - id: power
              type: s4
            - id: spells
              type: s4
              repeat: expr
              repeat-expr: 7
            - id: server_id
              type: s4
            - id: known_spells
              type: u4
            - id: spell_skill
              type: u4
              repeat: expr
              repeat-expr: 5
              # fire, water, air, earth, astral
            - id: equipped_item1
              type: u1str
            - id: equipped_item2
              type: u1str
        instances:
            name:
                value: _parent.name              
    t_human_header:
        seq:
            - id: name
              type: u1str
            - id: field_count
              type: u2
            - id: junk
              size: 10
              if: field_count == 0
            - id: body
              type: t_human              
              if: field_count != 0
    t_human:
        seq:            
            - id: stats
              type: s4
              repeat: expr
              repeat-expr: 4 #body, reaction, mind, spirit            
            - id: health_max
              type: s4
            - id: mana_max
              type: s4             
            - id: speed
              type: s4               
            - id: rotation_speed
              type: s4               
            - id: scan_range
              type: s4              
            - id: defence
              type: s4
            - id: skill0
              type: s4
            - id: skills
              type: s4                            
              repeat: expr
              repeat-expr: 5 #fire, water, air, earth, astral
              #or blade, axe, bludgeon, pike, shooting
            - id: type_id
              type: s4                        
            - id: face
              type: s4
            - id: gender
              type: s4
            - id: charge
              type: s4
            - id: relax
              type: s4              
            - id: token_size
              type: s4
            - id: movement_type
              type: s4
            - id: dying_time
              type: s4
            - id: server_id
              type: s4
            - id: known_spells
              type: u4
            - id: equipped_items
              type: u1str
              repeat: expr
              repeat-expr: 10
        instances:
            name:
                value: _parent.name
    t_structure:
        seq:
            - id: name
              type: u1str
            - id: field_count
              type: u2
            - id : width
              type: s4
            - id : height
              type: s4
            - id : scan_range
              type: s4
            - id : health_max
              type: s4
            - id : can_pass
              type: u4
            - id : cant_pass
              type: u4
    t_spell_header:
        seq:
            - id: name
              type: u1str
            - id: field_count
              type: u2
            - id: junk
              size: 2
              if: field_count == 0
            - id: body
              type: t_spell
              if: field_count != 0
    t_spell:
        seq:
            - id: level
              type: s4
            - id: mana_cost
              type: s4
            - id : sphere
              type: s4
            - id : item
              type: s4
            - id : spell_target
              type: s4
            - id : delivery_system
              type: s4
            - id : max_range
              type: s4
            - id : effect_speed
              type: s4 
            - id : distribution
              type: s4
            - id : radius
              type: s4
            - id : area_effect
              type: s4
            - id : area_duration
              type: s4
            - id : area_frequency
              type: s4
            - id : apply_method
              type: s4              
            - id : duration
              type: s4
            - id : frequency
              type: s4 
            - id : min_damage
              type: s4
            - id : max_damage
              type: s4
            - id : defensive
              type: s4
            - id : skill_offset
              type: s4
            - id : scroll_cost
              type: s4
            - id : book_cost
              type: s4               
            - id : effects
              type: u1str 
        instances:
            name:
                value: _parent.name
enums:
    e_stat:
        0 : body
        1 : reaction
        2 : mind
        3 : spirit
    e_magic : 
        0 : fire
        1 : water
        2 : air
        3 : earth
        4 : astral
    e_physical : 
        0 : blade
        1 : axe
        2 : bludgeon
        3 : pike
        4 : shooting
    e_treasure : 
        0 : gold
        1 : goldmin
        2 : goldmax
        3 : item
        4 : itemmin
        5 : itemmax
        6 : itemmask