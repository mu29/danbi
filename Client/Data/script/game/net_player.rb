# encoding: utf-8

#────────────────────────────────────────────────────────────────────────────
# ▶ Netplayer
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com)
# Date      2015. 1. 11
#────────────────────────────────────────────────────────────────────────────
class Netplayer < Character
  attr_accessor :no
  attr_accessor :name
  attr_accessor :job
  attr_accessor :title
  attr_accessor :level
  attr_accessor :guild
  attr_accessor :image
  attr_accessor :hp
  attr_accessor :maxHp
  attr_accessor :x
  attr_accessor :y
  attr_accessor :finalX
  attr_accessor :finalY
  attr_accessor :startSync
  attr_accessor :direction
  
  attr_accessor :chatBalloonText
  attr_accessor :chatBalloonVisible
  
  def initialize
    super
    @moveQueue = []
    @title = 0
    @guild = ""
    @startSync = false
    @erased = false
    @through = false
    @original_speed = 0
    refresh
    @chatBalloonText = ""
    @chatBalloonVisible = false
  end
  
  def erase
    @erased = true
    refresh
  end
  
  def addMove(value)
    @moveQueue.push(value)
  end
  
  def move_down(turn_enabled = true)
    turn_down
    @y += 1
  end

  def move_left(turn_enabled = true)
    turn_left
    @x -= 1
  end

  def move_right(turn_enabled = true)
    turn_right
    @x += 1
  end

  def move_up(turn_enabled = true)
    turn_up
    @y -= 1
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
  
  def do_coordinate_sync
    if @startSync
      @startSync = false
      if @x != @finalX or @y != @finalY
        moveto(@finalX, @finalY)
        refresh
      end
    end
  end

  def moveto(x, y)
    @x = x % Game.map.width
    @y = y % Game.map.height
    @real_x = @x * 128
    @real_y = @y * 128
    @prelock_direction = 0
    @finalX = @x
    @finalY = @y
  end

  def refresh
    @character_name = @image
    @character_hue = 0
    @opacity = 255
    @blend_type = 0
  end
  
  def update
    super
    return if moving?
    dir = @moveQueue.shift
    if @moveQueue.size > 2 && @original_speed == 0
      @original_speed = @move_speed
      @move_speed += 1
    elsif @moveQueue.size <= 2 && @original_speed > 0
      @move_speed = @original_speed
      @original_speed = 0
    end
    case dir
    when 2
      move_down
    when 4
      move_left
    when 6
      move_right
    when 8
      move_up
    end
    do_coordinate_sync if @moveQueue.empty?
  end
end