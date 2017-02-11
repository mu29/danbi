#────────────────────────────────────────────────────────────────────────────

# ▶ Mouse Input (7.0) 

# --------------------------------------------------------------------------

# Author    Near Fantastica, SephirothSpawn

# Modify    

# Date      2014. . 

# --------------------------------------------------------------------------

# Description

#

#   0:Left, 1:Right, 2:Center

#────────────────────────────────────────────────────────────────────────────



module Mouse

  Mouse_to_Input_Triggers = {0 => Input::C, 1 => Input::B, 2 => Input::A} 

  

  @@frame = [GetSystemMetrics.call(32), GetSystemMetrics.call(33), GetSystemMetrics.call(4)]  

  @triggers     =   [0, 1], [0, 2], [0, 4]

  @old_pos      =   0

  @pos_i        =   0

    

  def self.grid    

    return nil if @pos.nil?

    x = (@pos[0] + Game.map.display_x / 4) / 32

    y = (@pos[1] + Game.map.display_y / 4) / 32

    return [x, y]

  end



  def self.position

    return @pos == nil ? [0, 0] : @pos

  end



  def self.global_pos

    pos = [0, 0].pack('ll')

    return GetCursorPos.call(pos) == 0 ? nil : pos.unpack('ll')

  end



  def self.screen_to_client(x=0, y=0)

    pos = [x, y].pack('ll')

    return ScreenToClient.call(Game::hWnd, pos) == 0 ? nil : pos.unpack('ll')

  end  



  def self.pos

    global_pos = [0, 0].pack('ll')    

    gx, gy = GetCursorPos.call(global_pos) == 0 ? nil : global_pos.unpack('ll')

    local_pos = [gx, gy].pack('ll')

    x, y = ScreenToClient.call(Game::hWnd, local_pos) == 0 ? nil : local_pos.unpack('ll')

    begin

      if (x >= -@@frame[0] && y >= -@@frame[2] && x <= Graphics.getRect[0] + @@frame[0] && y <= Graphics.getRect[1] + @@frame[1])

        return x, y

      end

    rescue

      return 0, 0

    end

  end  

    

  def self.update

    return unless Graphics.focus

    old_pos = @pos

    @pos = self.pos

    for i in @triggers

      n = GetAsyncKeyState.call(i[1])

      if [0, 1].include?(n)

        i[0] = (i[0] > 0 ? i[0] * -1 : 0)

      else

        i[0] = (i[0] > 0 ? i[0] + 1 : 1)

      end

    end

    

    x, y = @pos

    (x == nil or y == nil) ? return : 0

    if self.press?

      @ox = x; @oy = y

    else

      @x = x; @y = y

    end

  end

  

  def self.pos_y

    y = (@pos[1])

    return y

  end

  

  def self.pos_x

    x = (@pos[0])

    return x

  end



  def self.trigger?(id = 0)

    return unless Graphics.focus

    if @triggers[id][0] == 1

      return true

    end

  end



  def self.repeat?(id = 0)

    return unless Graphics.focus

    if @triggers[id][0] <= 0

      return false

    else

      return @triggers[id][0] % 5 == 1 && @triggers[id][0] % 5 != 2

    end

  end



  def self.press?(id = 0)

    return unless Graphics.focus

    return @triggers[id][0] > 0

  end



  WHEEL_DELTA = 120

  def self.on_wheel(delta, keys, x, y)

    return unless Graphics.focus

    @@delta += delta

    if @@delta.abs >= WHEEL_DELTA

      delta_idx = - @@delta / WHEEL_DELTA

      @@delta %= WHEEL_DELTA

    end

    @wheel = delta_idx

  end

  if defined? Wheel

    Wheel.Call

    @@delta = 0

  end

  

  def self.screen_to_client(x=0, y=0)

    pos = [x, y].pack('ll')

    return ScreenToClient.call(Game::hWnd, pos) == 0 ? nil : pos.unpack('ll')

  end

  

  module_function

  

  def x

    return @x

  end

  

  def y

    return @y

  end



  def ox

    return @ox

  end



  def oy

    return @oy

  end



  def x=(x)

    @x = x

  end



  def y=(y)

    @y = y

  end



  def ox=(x)

    @ox = x

  end



  def oy=(y)

    @oy = y

  end

  

  def wheel

    @wheel

  end

  

  def wheel=(w)

    @wheel = w

  end

  

  @x = 0

  @y = 0

  @ox = 0

  @oy = 0

  @wheel = 0

  

  def arrive_rect?(x = 0, y = 0, width = 1, height = 1)

    if x.rect?

      y = x.y

      width = x.width

      height = x.height

      x = x.x

    end

    return (@x > x and @x < x + width and @y > y and @y < y + height)

  end

  

  def arrive_sprite_rect?(sprite)

    x = sprite.viewport.x + sprite.x - sprite.viewport.ox

    y = sprite.viewport.y + sprite.y - sprite.viewport.oy

    return self.arrive_rect?(x, y, sprite.bitmap.width, sprite.bitmap.height)

  end

  

  def arrive_sprite?(sprite)

    x = sprite.viewport.x + sprite.x - sprite.viewport.ox

    y = sprite.viewport.y + sprite.y - sprite.viewport.oy

    self.arrive_rect?(x, y, sprite.bitmap.width, sprite.bitmap.height) ? 0 : return

    color = sprite.bitmap.get_pixel(@x - x, @y - y)

    return ((color.red != 0 and color.green != 0 and color.blue != 0 and color.alpha != 0) ? true : false)

  end

  

  def map_x

    return (((Game.map.display_x.to_f/4.0).floor + @x.to_f)/32.0).floor

  end



  def map_y

    return (((Game.map.display_y.to_f/4.0).floor + @y.to_f)/32.0).floor

  end

end



class << Input

  unless self.method_defined?(:seph_mouse_input_update)

    alias_method :seph_mouse_input_update,   :update

    alias_method :seph_mouse_input_trigger?, :trigger?

    alias_method :seph_mouse_input_repeat?,  :repeat?

  end



  def update

    seph_mouse_input_update

  end



  def trigger?(constant)

    return true if seph_mouse_input_trigger?(constant)

    unless Mouse.pos.nil?

      if Mouse::Mouse_to_Input_Triggers.has_value?(constant)

        mouse_trigger = Mouse::Mouse_to_Input_Triggers.index(constant)

        return true if Mouse.trigger?(mouse_trigger)      

      end

    end

    return false

  end



  def repeat?(constant)

    return true if seph_mouse_input_repeat?(constant)

    unless Mouse.pos.nil?

      if Mouse::Mouse_to_Input_Triggers.has_value?(constant)

        mouse_trigger = Mouse::Mouse_to_Input_Triggers.index(constant)     

        return true if Mouse.repeat?(mouse_trigger)

      end

    end

    return false

  end

end