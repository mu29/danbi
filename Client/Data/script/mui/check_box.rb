# encoding: utf-8

#────────────────────────────────────────────────────────────────────────────
# ▶ MUI::CheckBox
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2014
# --------------------------------------------------------------------------
# Description
# 
#    체크박스 컨트롤을 담당하는 클래스입니다.
#────────────────────────────────────────────────────────────────────────────
class MUI
  class CheckBox < Control    
    def initialize(x, y, w, h)
      super(x, y, w, h)
      @value = false
      @style = "White"
      loadCache(@style)
    end
    
    def style; @style; end
    def style=(value)
      loadCache(@style = value)
      return if @baseSprite.nil?
      refresh
    end
    
    def loadCache(style)
      @@cache = {}
      @@cache['false'] = RPG::Cache.checkBox(style + "/" + "0.png")
      @@cache['true']  = RPG::Cache.checkBox(style + "/" + "1.png")
      @bitmap = @@cache[@value.to_s]
    end
    
    def value; @value end
    def value=(value)
      return unless value.is_a?(TrueClass) or value.is_a?(FalseClass)
      @value = value
      @bitmap = @@cache[@value.to_s]
      return if @baseSprite.nil?
      refresh
    end
    
    def enable=(value)
      if value
        @enable = true
        @baseSprite.tone.set(0, 0, 0)
      else
        @enable = false
        @baseSprite.tone.set(-20, -20, -20, 255)
      end
    end
    
    def refresh
      @baseSprite.bitmap.clear
      @baseSprite.bitmap.blt(0, 0, @bitmap, Rect.new(0, 0, @bitmap.width, @bitmap.height))
    end
    
    def update
      super
      if Mouse.trigger? && isSelected
        Game.system.se_play(Config::DECISION_SE)
        self.value = @value ? false : true
      end
    end
  end
end