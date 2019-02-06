# filename game/character.rb
#────────────────────────────────────────────────────────────────────────────
# ▶ Character
# --------------------------------------------------------------------------
# Author    EnterBrain
# Modify    뮤 (mu29gl@gmail.com)
# Date      2015. 1. 7
#────────────────────────────────────────────────────────────────────────────
class Character
  attr_reader   :id                       # ID
  attr_reader   :x                        # 맵 X 좌표 (논리 좌표)
  attr_reader   :y                        # 맵 Y 좌표 (논리 좌표)
  attr_reader   :real_x                   # 맵 X 좌표 (실좌표 * 128)
  attr_reader   :real_y                   # 맵 Y 좌표 (실좌표 * 128)
  attr_reader   :tile_id                  # 타일 ID  (0 이라면 무효)
  attr_reader   :character_name           # 캐릭터 파일명
  attr_reader   :character_hue            # 캐릭터 색상
  attr_reader   :opacity                  # 불투명도
  attr_reader   :blend_type               # 합성 방법
  attr_reader   :direction                # 방향
  attr_reader   :pattern                  # 패턴
  attr_reader   :through                  # 통행 가능
  attr_accessor :animation_id             # 애니메이션 ID
  attr_accessor :transparent              # 투명상태
  attr_accessor :move_speed
  attr_accessor :damages
  attr_accessor :isIcon

  def initialize
    @id = 0
    @x = 0
    @y = 0
    @real_x = 0
    @real_y = 0
    @tile_id = 0
    @character_name = ""
    @character_hue = 0
    @opacity = 255
    @blend_type = 0
    @direction = 2
    @pattern = 0
    @through = false
    @animation_id = 0
    @transparent = false
    @original_direction = 2
    @original_pattern = 0
    @move_type = 0
    @move_speed = 4
    @move_frequency = 6
    @move_route = nil
    @move_route_index = 0
    @original_move_route = nil
    @original_move_route_index = 0
    @walk_anime = true
    @step_anime = false
    @direction_fix = false
    @always_on_top = false
    @anime_count = 0
    @stop_count = 0
    @jump_count = 0
    @jump_peak = 0
    @wait_count = 0
    @locked = false
    @prelock_direction = 0
    @damages = []
    @isIcon = false
  end
  
  def setGraphic(character_name, character_hue)
    @image = character_name
    @character_name = character_name
    @character_hue = character_hue
  end

  def moving?
    return (@real_x != @x * 128 or @real_y != @y * 128)
  end

  def jumping?
    return @jump_count > 0
  end

  def straighten
    if @walk_anime or @step_anime
      @pattern = 0
    end
    @anime_count = 0
    @prelock_direction = 0
  end

  def passable?(x, y, d)
    new_x = x + (d == 6 ? 1 : d == 4 ? -1 : 0)
    new_y = y + (d == 2 ? 1 : d == 8 ? -1 : 0)
    unless Game.map.valid?(new_x, new_y)
      return false
    end
    if @through
      return true
    end
    unless Game.map.passable?(x, y, d, self)
      return false
    end
    unless Game.map.passable?(new_x, new_y, 10 - d)
      return false
    end
    for netplayer in Game.map.netplayers.values
      if netplayer.x == new_x and netplayer.y == new_y
        unless netplayer.through
          if self != Game.player
            return false
          end
          if netplayer.character_name != ""
            return false
          end
        end
      end
    end
    for npc in Game.map.npcs.values
      if npc.x == new_x and npc.y == new_y
        unless npc.through
          if self != Game.player
            return false
          end
          if npc.character_name != ""
            return false
          end
        end
      end
    end
    for enemy in Game.map.enemies.values
      if enemy.x == new_x and enemy.y == new_y
        unless enemy.through
          if self != Game.player
            return false
          end
          if enemy.character_name != ""
            return false
          end
        end
      end
    end
    for event in Game.map.events.values
      if event.x == new_x and event.y == new_y
        unless event.through
          if self != Game.player
            return false
          end
          if event.character_name != ""
            return false
          end
        end
      end
    end
    if Game.player.x == new_x and Game.player.y == new_y
      unless Game.player.through
        if @character_name != ""
          return false
        end
      end
    end
    return true
  end

  def lock
    if @locked
      return
    end
    @prelock_direction = @direction
    turn_toward_player
    @locked = true
  end

  def lock?
    return @locked
  end

  def unlock
    unless @locked
      return
    end
    @locked = false
    unless @direction_fix
      if @prelock_direction != 0
        @direction = @prelock_direction
      end
    end
  end

  def moveto(x, y)
    @x = x % Game.map.width
    @y = y % Game.map.height
    @real_x = @x * 128
    @real_y = @y * 128
    @prelock_direction = 0
  end

  def screen_x
    return (@real_x - Game.map.display_x + 3) / 4 + 16
  end

  def screen_y
    y = (@real_y - Game.map.display_y + 3) / 4 + 32
    if @jump_count >= @jump_peak
      n = @jump_count - @jump_peak
    else
      n = @jump_peak - @jump_count
    end
    return y - (@jump_peak * @jump_peak - n * n) / 2
  end

  def screen_z(height = 0)
    if @always_on_top
      return 999
    end
    z = (@real_y - Game.map.display_y + 3) / 4 + 32
    if @tile_id > 0
      return z + Game.map.priorities[@tile_id] * 32
    else
      return z + ((height > 32) ? 31 : 0)
    end
  end

  def bush_depth
    if @tile_id > 0 or @always_on_top
      return 0
    end
    if @jump_count == 0 and Game.map.bush?(@x, @y)
      return 12
    else
      return 0
    end
  end

  def terrain_tag
    return Game.map.terrain_tag(@x, @y)
  end
  
  def update
    if jumping?
      update_jump
    elsif moving?
      update_move
    else
      update_stop
    end
    if @anime_count > 18 - @move_speed * 2
      if not @step_anime and @stop_count > 0
        @pattern = @original_pattern
      else
        @pattern = (@pattern + 1) % 4
      end
      @anime_count = 0
    end
    if @wait_count > 0
      @wait_count -= 1
      return
    end
    if @starting or lock?
      return
    end
    if @stop_count > (40 - @move_frequency * 2) * (6 - @move_frequency)
      case @move_type
      when 1  # 랜덤
        move_type_random
      when 2  # 가까워진다
        move_type_toward_player
      when 3  # 커스텀
        move_type_custom
      end
    end
  end

  def update_jump
    @jump_count -= 1
    @real_x = (@real_x * @jump_count + @x * 128) / (@jump_count + 1)
    @real_y = (@real_y * @jump_count + @y * 128) / (@jump_count + 1)
  end

  def update_move
    distance = 2 ** @move_speed
    if @y * 128 > @real_y
      @real_y = [@real_y + distance, @y * 128].min
    end
    if @x * 128 < @real_x
      @real_x = [@real_x - distance, @x * 128].max
    end
    if @x * 128 > @real_x
      @real_x = [@real_x + distance, @x * 128].min
    end
    if @y * 128 < @real_y
      @real_y = [@real_y - distance, @y * 128].max
    end
    if @walk_anime
      @anime_count += 1.5
    elsif @step_anime
      @anime_count += 1
    end
  end

  def update_stop
    if @step_anime
      @anime_count += 1
    elsif @pattern != @original_pattern
      @anime_count += 1.5
    end
    unless @starting or lock?
      @stop_count += 1
    end
  end

  def move_type_random
    case rand(6)
    when 0..3  # 랜덤
      move_random
    when 4  # 한 걸음 전진
      move_forward
    when 5  # 일시정지
      @stop_count = 0
    end
  end

  def move_type_toward_player
    sx = @x - Game.player.x
    sy = @y - Game.player.y
    abs_sx = sx > 0 ? sx : -sx
    abs_sy = sy > 0 ? sy : -sy
    if sx + sy >= 20
      move_random
      return
    end
    case rand(6)
    when 0..3  # 플레이어에 가까워진다
      move_toward_player
    when 4  # 랜덤
      move_random
    when 5  # 한 걸음 전진
      move_forward
    end
  end

  def move_type_custom
    if jumping? or moving?
      return
    end
    while @move_route_index < @move_route.list.size
      command = @move_route.list[@move_route_index]
      if command.code == 0
        if @move_route.repeat
          @move_route_index = 0
        end
        unless @move_route.repeat
          if @move_route_forcing and not @move_route.repeat
            @move_route_forcing = false
            @move_route = @original_move_route
            @move_route_index = @original_move_route_index
            @original_move_route = nil
          end
          @stop_count = 0
        end
        return
      end
      if command.code <= 14
        case command.code
        when 1  # 하에 이동
          move_down
        when 2  # 왼쪽으로 이동
          move_left
        when 3  # 오른쪽으로 이동
          move_right
        when 4  # 상에 이동
          move_up
        when 5  # 좌하에 이동
          move_lower_left
        when 6  # 우하에 이동
          move_lower_right
        when 7  # 좌상에 이동
          move_upper_left
        when 8  # 우상에 이동
          move_upper_right
        when 9  # 랜덤에 이동
          move_random
        when 10  # 플레이어에 가까워진다
          move_toward_player
        when 11  # 플레이어로부터 멀어진다
          move_away_from_player
        when 12  # 한 걸음 전진
          move_forward
        when 13  # 한 걸음 후퇴
          move_backward
        when 14  # 점프
          jump(command.parameters[0], command.parameters[1])
        end
        if not @move_route.skippable and not moving? and not jumping?
          return
        end
        @move_route_index += 1
        return
      end
      if command.code == 15
        @wait_count = command.parameters[0] * 2 - 1
        @move_route_index += 1
        return
      end
      if command.code >= 16 and command.code <= 26
        case command.code
        when 16  # 아래를 향한다
          turn_down
        when 17  # 왼쪽을 향한다
          turn_left
        when 18  # 오른쪽을 향한다
          turn_right
        when 19  # 위를 향한다
          turn_up
        when 20  # 오른쪽으로 90 도 회전
          turn_right_90
        when 21  # 왼쪽으로 90 도 회전
          turn_left_90
        when 22  # 180 도 회전
          turn_180
        when 23  # 오른쪽이나 왼쪽으로 90 도 회전
          turn_right_or_left_90
        when 24  # 랜덤에 방향 전환
          turn_random
        when 25  # 플레이어의 분을 향한다
          turn_toward_player
        when 26  # 플레이어의 역을 향한다
          turn_away_from_player
        end
        @move_route_index += 1
        return
      end
      if command.code >= 27
        case command.code
        when 27  # 스윗치 ON
          Game.switches[command.parameters[0]] = true
          Game.map.need_refresh = true
        when 28  # 스윗치 OFF
          Game.switches[command.parameters[0]] = false
          Game.map.need_refresh = true
        when 29  # 이동 속도의 변경
          @move_speed = command.parameters[0]
        when 30  # 이동 빈도의 변경
          @move_frequency = command.parameters[0]
        when 31  # 이동시 애니메이션 ON
          @walk_anime = true
        when 32  # 이동시 애니메이션 OFF
          @walk_anime = false
        when 33  # 정지시 애니메이션 ON
          @step_anime = true
        when 34  # 정지시 애니메이션 OFF
          @step_anime = false
        when 35  # 방향 고정 ON
          @direction_fix = true
        when 36  # 방향 고정 OFF
          @direction_fix = false
        when 37  # 빠져나가 ON
          @through = true
        when 38  # 빠져나가 OFF
          @through = false
        when 39  # 맨 앞면에 표시 ON
          @always_on_top = true
        when 40  # 맨 앞면에 표시 OFF
          @always_on_top = false
        when 41  # 그래픽 변경
          @tile_id = 0
          @character_name = command.parameters[0]
          @character_hue = command.parameters[1]
          if @original_direction != command.parameters[2]
            @direction = command.parameters[2]
            @original_direction = @direction
            @prelock_direction = 0
          end
          if @original_pattern != command.parameters[3]
            @pattern = command.parameters[3]
            @original_pattern = @pattern
          end
        when 42  # 불투명도의 변경
          @opacity = command.parameters[0]
        when 43  # 합성 방법의 변경
          @blend_type = command.parameters[0]
        when 44  # SE 의 연주
          Game.system.se_play(command.parameters[0])
        when 45  # 스크립트
          result = eval(command.parameters[0])
        end
        @move_route_index += 1
      end
    end
  end

  def increase_steps
    @stop_count = 0
  end
  
  def move_down(turn_enabled = true)
    if turn_enabled
      turn_down
    end
    if passable?(@x, @y, 2)
      turn_down
      @y += 1
      increase_steps
    end
  end

  def move_left(turn_enabled = true)
    if turn_enabled
      turn_left
    end
    if passable?(@x, @y, 4)
      turn_left
      @x -= 1
      increase_steps
    end
  end

  def move_right(turn_enabled = true)
    if turn_enabled
      turn_right
    end
    if passable?(@x, @y, 6)
      turn_right
      @x += 1
      increase_steps
    end
  end

  def move_up(turn_enabled = true)
    if turn_enabled
      turn_up
    end
    if passable?(@x, @y, 8)
      turn_up
      @y -= 1
      increase_steps
    end
  end

  def move_lower_left
    unless @direction_fix
      @direction = (@direction == 6 ? 4 : @direction == 8 ? 2 : @direction)
    end
    if (passable?(@x, @y, 2) and passable?(@x, @y + 1, 4)) or
       (passable?(@x, @y, 4) and passable?(@x - 1, @y, 2))
      @x -= 1
      @y += 1
      increase_steps
    end
  end

  def move_lower_right
    unless @direction_fix
      @direction = (@direction == 4 ? 6 : @direction == 8 ? 2 : @direction)
    end
    if (passable?(@x, @y, 2) and passable?(@x, @y + 1, 6)) or
       (passable?(@x, @y, 6) and passable?(@x + 1, @y, 2))
      @x += 1
      @y += 1
      increase_steps
    end
  end

  def move_upper_left
    unless @direction_fix
      @direction = (@direction == 6 ? 4 : @direction == 2 ? 8 : @direction)
    end
    if (passable?(@x, @y, 8) and passable?(@x, @y - 1, 4)) or
       (passable?(@x, @y, 4) and passable?(@x - 1, @y, 8))
      @x -= 1
      @y -= 1
      increase_steps
    end
  end

  def move_upper_right
    unless @direction_fix
      @direction = (@direction == 4 ? 6 : @direction == 2 ? 8 : @direction)
    end
    if (passable?(@x, @y, 8) and passable?(@x, @y - 1, 6)) or
       (passable?(@x, @y, 6) and passable?(@x + 1, @y, 8))
      @x += 1
      @y -= 1
      increase_steps
    end
  end

  def move_random
    case rand(4)
    when 0  # 하에 이동
      move_down(false)
    when 1  # 왼쪽으로 이동
      move_left(false)
    when 2  # 오른쪽으로 이동
      move_right(false)
    when 3  # 상에 이동
      move_up(false)
    end
  end

  def move_toward_player
    sx = @x - Game.player.x
    sy = @y - Game.player.y
    if sx == 0 and sy == 0
      return
    end
    abs_sx = sx.abs
    abs_sy = sy.abs
    if abs_sx == abs_sy
      rand(2) == 0 ? abs_sx += 1 : abs_sy += 1
    end
    if abs_sx > abs_sy
      sx > 0 ? move_left : move_right
      if not moving? and sy != 0
        sy > 0 ? move_up : move_down
      end
    else
      sy > 0 ? move_up : move_down
      if not moving? and sx != 0
        sx > 0 ? move_left : move_right
      end
    end
  end

  def move_away_from_player
    sx = @x - Game.player.x
    sy = @y - Game.player.y
    if sx == 0 and sy == 0
      return
    end
    abs_sx = sx.abs
    abs_sy = sy.abs
    if abs_sx == abs_sy
      rand(2) == 0 ? abs_sx += 1 : abs_sy += 1
    end
    if abs_sx > abs_sy
      sx > 0 ? move_right : move_left
      if not moving? and sy != 0
        sy > 0 ? move_down : move_up
      end
    else
      sy > 0 ? move_down : move_up
      if not moving? and sx != 0
        sx > 0 ? move_right : move_left
      end
    end
  end

  def move_forward
    case @direction
    when 2
      move_down(false)
    when 4
      move_left(false)
    when 6
      move_right(false)
    when 8
      move_up(false)
    end
  end

  def move_backward
    last_direction_fix = @direction_fix
    @direction_fix = true
    case @direction
    when 2  # 하
      move_up(false)
    when 4  # 왼쪽
      move_right(false)
    when 6  # 오른쪽
      move_left(false)
    when 8  # 상
      move_down(false)
    end
    @direction_fix = last_direction_fix
  end

  def jump(x_plus, y_plus)
    if x_plus != 0 or y_plus != 0
      if x_plus.abs > y_plus.abs
        x_plus < 0 ? turn_left : turn_right
      else
        y_plus < 0 ? turn_up : turn_down
      end
    end
    new_x = @x + x_plus
    new_y = @y + y_plus
    if (x_plus == 0 and y_plus == 0) or passable?(new_x, new_y, 0)
      straighten
      @x = new_x
      @y = new_y
      distance = Math.sqrt(x_plus * x_plus + y_plus * y_plus).round
      @jump_peak = 10 + distance - @move_speed
      @jump_count = @jump_peak * 2
      @stop_count = 0
    end
  end
  
  def jumpTo(x, y)
    x_plus = x - @x
    y_plus = y - @y
    if (x_plus == 0 and y_plus == 0) or passable?(x, y, 0)
      straighten
      @x = x
      @y = y
      distance = Math.sqrt(x_plus * x_plus + y_plus * y_plus).round
      @jump_peak = 10 + distance - @move_speed
      @jump_count = @jump_peak * 2
      @stop_count = 0
    end
  end

  def turn_down
    unless @direction_fix
      @direction = 2
      @stop_count = 0
    end
  end

  def turn_left
    unless @direction_fix
      @direction = 4
      @stop_count = 0
    end
  end

  def turn_right
    unless @direction_fix
      @direction = 6
      @stop_count = 0
    end
  end

  def turn_up
    unless @direction_fix
      @direction = 8
      @stop_count = 0
    end
  end

  def turn_right_90
    case @direction
    when 2
      turn_left
    when 4
      turn_up
    when 6
      turn_down
    when 8
      turn_right
    end
  end

  def turn_left_90
    case @direction
    when 2
      turn_right
    when 4
      turn_down
    when 6
      turn_up
    when 8
      turn_left
    end
  end

  def turn_180
    case @direction
    when 2
      turn_up
    when 4
      turn_right
    when 6
      turn_left
    when 8
      turn_down
    end
  end

  def turn_right_or_left_90
    if rand(2) == 0
      turn_right_90
    else
      turn_left_90
    end
  end

  def turn_random
    case rand(4)
    when 0
      turn_up
    when 1
      turn_right
    when 2
      turn_left
    when 3
      turn_down
    end
  end

  def turn_toward_player
    sx = @x - Game.player.x
    sy = @y - Game.player.y
    if sx == 0 and sy == 0
      return
    end
    if sx.abs > sy.abs
      sx > 0 ? turn_left : turn_right
    else
      sy > 0 ? turn_up : turn_down
    end
  end
  def turn_away_from_player
    sx = @x - Game.player.x
    sy = @y - Game.player.y
    if sx == 0 and sy == 0
      return
    end
    if sx.abs > sy.abs
      sx > 0 ? turn_right : turn_left
    else
      sy > 0 ? turn_down : turn_up
    end
  end
end
