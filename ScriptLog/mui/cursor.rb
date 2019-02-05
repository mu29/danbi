# filename mui/cursor.rb
#────────────────────────────────────────────────────────────────────────────
# ▶ MUI::Cursor
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com)
# Date      2015
# --------------------------------------------------------------------------
# Description
# 
#    마우스 커서를 담당하는 클래스입니다.
#────────────────────────────────────────────────────────────────────────────
class MUI
  class Cursor < Sprite
    def initialize
      @viewport = Viewport.new(0, 0, Graphics.getRect[0], Graphics.getRect[1])
      @viewport.z = 9999999
      super(@viewport)
      @route = "Graphics/Icons/"
      @x = Mouse.x
      @y = Mouse.y
      self.bitmap = RPG::Cache.icon(Config::MOUSE)
      self.x = @x
      self.y = @y
      self.z = 1
    end
    
    def setImage(value)
      self.bitmap = value
    end
    
    def setDefaultImage
      self.bitmap = RPG::Cache.icon(Config::MOUSE)
    end
    
    def update
      super
      if Mouse.press?
        if @x != Mouse.ox or @y != Mouse.oy
          @x = Mouse.ox
          @y = Mouse.oy
          self.x = @x
          self.y = @y
        end
      else
        if @x != Mouse.x or @y != Mouse.y
          @x = Mouse.x
          @y = Mouse.y
          self.x = @x
          self.y = @y
        end
      end
    end
  end
end