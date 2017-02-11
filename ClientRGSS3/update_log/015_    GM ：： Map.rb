#────────────────────────────────────────────────────────────────────────────

# ▶ Map

# --------------------------------------------------------------------------

# Author    EnterBrain

# Modify    뮤 (mu29gl@gmail.com)

# Date      2015. 1. 7

#────────────────────────────────────────────────────────────────────────────

class Map

  attr_accessor :tileset_name             # 타일 세트 파일명

  attr_accessor :autotile_names           # 오토 타일 파일명

  attr_accessor :panorama_name            # 파노라마 파일명

  attr_accessor :panorama_hue             # 파노라마 색상

  attr_accessor :fog_name                 # 포그 파일명

  attr_accessor :fog_hue                  # 포그 색상

  attr_accessor :fog_opacity              # 포그 불투명도

  attr_accessor :fog_blend_type           # 포그 브랜드 방법

  attr_accessor :fog_zoom                 # 포그 확대율

  attr_accessor :fog_sx                   # 포그 SX

  attr_accessor :fog_sy                   # 포그 SY

  attr_accessor :battleback_name          # 배틀 백 파일명

  attr_accessor :display_x                # 표시 X 좌표 * 128

  attr_accessor :display_y                # 표시 Y 좌표 * 128

  attr_accessor :need_refresh             # 리프레쉬 요구 플래그

  attr_reader   :passages                 # 통행 테이블

  attr_reader   :priorities               # priority 테이블

  attr_reader   :terrain_tags             # 지형 태그 테이블

  attr_reader   :fog_ox                   # 포그 원점 X 좌표

  attr_reader   :fog_oy                   # 포그 원점 Y 좌표

  attr_reader   :fog_tone                 # 포그 색조

  attr_reader   :events                   # 이벤트

  attr_reader   :netplayers               # 넷플레이어

  attr_reader   :npcs                     # NPC

  attr_reader   :enemies                   # 에너미



  def initialize

    @map_id = 0

    @display_x = 0

    @display_y = 0

  end



  def setup(map_id)

    @map_id = map_id

    @map = load_data(sprintf("Data/Map%03d.rxdata", @map_id))

    tileset = $data_tilesets[@map.tileset_id]

    @tileset_name = tileset.tileset_name

    @autotile_names = tileset.autotile_names

    @panorama_name = tileset.panorama_name

    @panorama_hue = tileset.panorama_hue

    @fog_name = tileset.fog_name

    @fog_hue = tileset.fog_hue

    @fog_opacity = tileset.fog_opacity

    @fog_blend_type = tileset.fog_blend_type

    @fog_zoom = tileset.fog_zoom

    @fog_sx = tileset.fog_sx

    @fog_sy = tileset.fog_sy

    @battleback_name = tileset.battleback_name

    @passages = tileset.passages

    @priorities = tileset.priorities

    @terrain_tags = tileset.terrain_tags

    @display_x = 0

    @display_y = 0

    @need_refresh = false

    @events = {}

    for i in @map.events.keys

      @events[i] = Event.new(@map_id, @map.events[i])

    end

    @netplayers = {}

    @npcs = {}

    @enemies = {}

    @items = {}

    @fog_ox = 0

    @fog_oy = 0

    @fog_tone = Tone.new(0, 0, 0, 0)

    @fog_tone_target = Tone.new(0, 0, 0, 0)

    @fog_tone_duration = 0

    @fog_opacity_duration = 0

    @fog_opacity_target = 0

    @scroll_direction = 2

    @scroll_rest = 0

    @scroll_speed = 4

  end



  def map_id

    return @map_id

  end



  def width

    return @map.width

  end



  def height

    return @map.height

  end



  def data

    return @map.data

  end



  def autoplay

    if @map.autoplay_bgm

      Game.system.bgm_play(@map.bgm)

    end

    if @map.autoplay_bgs

      Game.system.bgs_play(@map.bgs)

    end

  end



  def refresh

    if @map_id > 0

      for netplayer in @netplayers.values

        netplayer.refresh

      end

      for npc in @npcs.values

        npc.refresh

      end

      for enemy in @enemies.values

        enemy.refresh

      end

      for event in @events.values

        event.refresh

      end

    end

    @need_refresh = false

  end



  def scroll_down(distance)

    @display_y = [@display_y + distance, (self.height - 15) * 128].min

  end



  def scroll_left(distance)

    @display_x = [@display_x - distance, 0].max

  end



  def scroll_right(distance)

    @display_x = [@display_x + distance, (self.width - 20) * 128].min

  end



  def scroll_up(distance)

    @display_y = [@display_y - distance, 0].max

  end



  def valid?(x, y)

    return (x >= 0 and x < width and y >= 0 and y < height)

  end



  def passable?(x, y, d, self_event = nil)

    unless valid?(x, y)

      return false

    end

    bit = (1 << (d / 2 - 1)) & 0x0f

    for event in events.values

      if event.tile_id >= 0 and event != self_event and

         event.x == x and event.y == y and not event.through

        if @passages[event.tile_id] & bit != 0

          return false

        elsif @passages[event.tile_id] & 0x0f == 0x0f

          return false

        elsif @priorities[event.tile_id] == 0

          return true

        end

      end

    end

    for i in [2, 1, 0]

      tile_id = data[x, y, i]

      if tile_id == nil

        return false

      elsif @passages[tile_id] & bit != 0

        return false

      elsif @passages[tile_id] & 0x0f == 0x0f

        return false

      elsif @priorities[tile_id] == 0

        return true

      end

    end

    return true

  end



  def bush?(x, y)

    if @map_id != 0

      for i in [2, 1, 0]

        tile_id = data[x, y, i]

        if tile_id == nil

          return false

        elsif @passages[tile_id] & 0x40 == 0x40

          return true

        end

      end

    end

    return false

  end



  def counter?(x, y)

    if @map_id != 0

      for i in [2, 1, 0]

        tile_id = data[x, y, i]

        if tile_id == nil

          return false

        elsif @passages[tile_id] & 0x80 == 0x80

          return true

        end

      end

    end

    return false

  end



  def terrain_tag(x, y)

    if @map_id != 0

      for i in [2, 1, 0]

        tile_id = data[x, y, i]

        if tile_id == nil

          return 0

        elsif @terrain_tags[tile_id] > 0

          return @terrain_tags[tile_id]

        end

      end

    end

    return 0

  end



  def check_event(x, y)

    for event in Game.map.events.values

      if event.x == x and event.y == y

        return event.id

      end

    end

  end



  def start_scroll(direction, distance, speed)

    @scroll_direction = direction

    @scroll_rest = distance * 128

    @scroll_speed = speed

  end



  def scrolling?

    return @scroll_rest > 0

  end



  def start_fog_tone_change(tone, duration)

    @fog_tone_target = tone.clone

    @fog_tone_duration = duration

    if @fog_tone_duration == 0

      @fog_tone = @fog_tone_target.clone

    end

  end



  def start_fog_opacity_change(opacity, duration)

    @fog_opacity_target = opacity * 1.0

    @fog_opacity_duration = duration

    if @fog_opacity_duration == 0

      @fog_opacity = @fog_opacity_target

    end

  end

  

  def addNetplayer(id, netplayer)

    return if @netplayers.has_key?(id)

    @netplayers[id] = netplayer

    return @netplayers[id]

  end

  

  def getNetplayer(id)

    return @netplayers[id]

  end

  

  def removeNetplayer(id)

    return if not @netplayers.has_key?(id)

    @netplayers.delete(id)

  end

  

  def addNPC(id, npc)

    return if @npcs.has_key?(id)

    @npcs[id] = npc

    return @npcs[id]

  end

  

  def getNPC(id)

    return @npcs[id]

  end

  

  def removeNPC(id)

    return if not @npcs.has_key?(id)

    @npcs.delete(id)

  end

  

  def addEnemy(id, enemy)

    return if @enemies.has_key?(id)

    @enemies[id] = enemy

    return @enemies[id]

  end

  

  def getEnemy(id)

    return @enemies[id]

  end

  

  def removeEnemy(id)

    return if not @enemies.has_key?(id)

    @enemies.delete(id)

  end

  

  def addItem(id, item)

    return if @items.has_key?(id)

    @items[id] = item

    return @items[id]

  end

  

  def getItem(id)

    return @items[id]

  end

  

  def removeItem(id)

    return if not @items.has_key?(id)

    @items.delete(id)

  end



  def update

    if Game.map.need_refresh

      refresh

    end

    if @scroll_rest > 0

      distance = 2 ** @scroll_speed

      case @scroll_direction

      when 2  # 하

        scroll_down(distance)

      when 4  # 왼쪽

        scroll_left(distance)

      when 6  # 오른쪽

        scroll_right(distance)

      when 8  # 상

        scroll_up(distance)

      end

      @scroll_rest -= distance

    end

    for netplayer in @netplayers.values

      netplayer.update

    end

    for npc in @npcs.values

      npc.update

    end

    for enemy in @enemies.values

      enemy.update

    end

    for event in @events.values

      event.update

    end

    @fog_ox -= @fog_sx / 8.0

    @fog_oy -= @fog_sy / 8.0

    if @fog_tone_duration >= 1

      d = @fog_tone_duration

      target = @fog_tone_target

      @fog_tone.red = (@fog_tone.red * (d - 1) + target.red) / d

      @fog_tone.green = (@fog_tone.green * (d - 1) + target.green) / d

      @fog_tone.blue = (@fog_tone.blue * (d - 1) + target.blue) / d

      @fog_tone.gray = (@fog_tone.gray * (d - 1) + target.gray) / d

      @fog_tone_duration -= 1

    end

    if @fog_opacity_duration >= 1

      d = @fog_opacity_duration

      @fog_opacity = (@fog_opacity * (d - 1) + @fog_opacity_target) / d

      @fog_opacity_duration -= 1

    end

  end

end