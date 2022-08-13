meta:
  id: rage_of_mages_1_res
  title: Rage Of Mages Seal Of Mystery record files
  file-extension: res
  application: Rage Of Mages Seal Of Mystery
  license: CC0-1.0
  encoding: IBM866
  endian: le
seq:
  - id: signature
    contents: [0x26, 0x59, 0x41, 0x31]
  - id: resource_header
    type: root_resource_header_t

instances:
  nodes:
    pos: resource_header.fat_offset + _root.resource_header.root_offset * 0x20
    size: resource_header.root_size * 0x20
    type: resource_header_list

types:
  resource_header_list:
    seq:
      - id: header
        type: resource_header
        size: 0x20
        repeat: eos
  resource_record_file:
    seq:
      - id: name
        type: str
        size: 0x10
        terminator: 0
    instances:
      bytes:
        io: _root._io
        pos: _parent.root_offset
        size: _parent.root_size
  resource_record_directory:
    seq:
      - id: name
        type: str
        size: 0x10
        encoding: IBM866
        terminator: 0
    instances:
      nodes:
        io: _root._io
        pos: _root.resource_header.fat_offset + _parent.root_offset * 0x20
        size: _parent.root_size * 0x20
        type: resource_header_list

  resource_header:
    seq:
      - id: junk
        type: u4
      - id: root_offset
        type: u4
      - id: root_size
        type: u4
      - id: rec_type
        type: u4
        enum: e_resource_record_type
      - id: record
        type:
          switch-on: rec_type
          cases:
            e_resource_record_type::file: resource_record_file
            e_resource_record_type::directory: resource_record_directory

  root_resource_header_t:
    seq:
      - id: root_offset
        type: u4
      - id: root_size
        type: u4
      - id: record_flags
        type: u4
        doc: not used???
      - id: fat_offset
        type: u4
      - id: fat_size
        type: u4
        doc: not used???

enums:
  e_resource_record_type:
    0: file
    1: directory
