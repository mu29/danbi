# encoding: utf-8

#────────────────────────────────────────────────────────────────────────────
# ▶ Event
# --------------------------------------------------------------------------
# Author    EnterBrain
# Modify    뮤(mu29gl@gmail.com)
# Date      2015. 1. 7
#────────────────────────────────────────────────────────────────────────────
class Event < Character
  attr_reader   :trigger
  attr_reader   :list
  attr_reader   :starting
  attr_reader   :page
  attr_accessor :erased

  def initialize(map_id, event)
    super()
    @map_id = map_id
    @event = event
    @id = @event.id
    @erased = false
    @starting = false
    # 초기 위치에 이동
    moveto(@event.x, @event.y)
    refresh
  end

  def clear_starting
    @starting = false
  end

  def over_trigger?
    if @character_name != "" and not @through
      return false
    end
    unless Game.map.passable?(@x, @y, 0)
      return false
    end
    return true
  end

  def start
    if @list.size > 1
      @starting = true
    end
  end

  def erase
    @erased = true
    refresh
  end

  def refresh
    new_page = nil
    unless @erased
      for page in @event.pages.reverse
        c = page.condition
        if c.switch1_valid
          if Game.switches[c.switch1_id] == false
            next
          end
        end
        if c.switch2_valid
          if Game.switches[c.switch2_id] == false
            next
          end
        end
        if c.variable_valid
          if Game.variables[c.variable_id] < c.variable_value
            next
          end
        end
        if c.self_switch_valid
          key = [@map_id, @event.id, c.self_switch_ch]
          if Game.self_switches[key] != true
            next
          end
        end
        new_page = page
        break
      end
    end
    if new_page == @page
      return
    end
    @page = new_page
    clear_starting
    if @page == nil
      @tile_id = 0
      @character_name = ""
      @character_hue = 0
      @move_type = 0
      @trigger = nil
      @list = nil
      @interpreter = nil
      return
    end
    @tile_id = @page.graphic.tile_id
    @character_name = @page.graphic.character_name
    @character_hue = @page.graphic.character_hue
    if @original_direction != @page.graphic.direction
      @direction = @page.graphic.direction
      @original_direction = @direction
      @prelock_direction = 0
    end
    if @original_pattern != @page.graphic.pattern
      @pattern = @page.graphic.pattern
      @original_pattern = @pattern
    end
    @opacity = @page.graphic.opacity
    @blend_type = @page.graphic.blend_type
    @move_type = @page.move_type
    @move_speed = @page.move_speed
    @move_frequency = @page.move_frequency
    @move_route = @page.move_route
    @move_route_index = 0
    @move_route_forcing = false
    @walk_anime = @page.walk_anime
    @step_anime = @page.step_anime
    @direction_fix = @page.direction_fix
    @through = @page.through
    @always_on_top = @page.always_on_top
    @trigger = @page.trigger
    @list = @page.list
    @interpreter = nil
    if @trigger == 4
      @interpreter = Interpreter.new
    end
    check_event_trigger_auto
  end

  def check_event_trigger_touch(x, y)
    if Game.system.map_interpreter.running?
      return
    end
    if @trigger == 2 and x == Game.player.x and y == Game.player.y
      unless over_trigger?
        start
      end
    end
  end

  def check_event_trigger_auto
    if @trigger == 2
      if @x == Game.player.x and @y == Game.player.y and over_trigger?
        start
      end
    end
    if @trigger == 3
      start
    end
  end

  def update
    super
    check_event_trigger_auto
    if @interpreter != nil
      unless @interpreter.running?
        @interpreter.setup(@list, @event.id)
      end
      @interpreter.update
    end
  end
end
