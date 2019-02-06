# filename game/enemy.rb
#────────────────────────────────────────────────────────────────────────────
# ▶ Enemy
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com)
# Date      2015. 1. 23
#────────────────────────────────────────────────────────────────────────────
class Enemy < Character
  attr_accessor :no
  attr_accessor :name
  attr_accessor :image
  attr_accessor :hp
  attr_accessor :maxHp
  attr_accessor :x
  attr_accessor :y
  attr_accessor :finalX
  attr_accessor :finalY
  attr_accessor :direction
  
  def initialize
    super
    @erased = false
    @through = false
    @original_speed = 0
    refresh
  end
  
  def erase
    @erased = true
    refresh
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
  
  def refresh
    @character_name = @image
    @character_hue = 0
    @opacity = 255
    @blend_type = 0
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
  
  def update
    super
  end
end