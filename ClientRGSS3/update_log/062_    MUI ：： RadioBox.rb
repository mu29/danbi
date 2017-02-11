#────────────────────────────────────────────────────────────────────────────

# ▶ MUI::RadioBox

# --------------------------------------------------------------------------

# Author    뮤 (mu29gl@gmail.com), jubin

# Date      2014

# --------------------------------------------------------------------------

# Description

# 

#    라디오박스 컨트롤을 담당하는 클래스입니다.

#────────────────────────────────────────────────────────────────────────────

class MUI

  class RadioBox < Control    

    @@group = {}

    def initialize(x, y, w, h)

      super(x, y, w, h)

      @value = false

      @group = nil

      @style = "White"

      loadCache(@style)

      @bitmap = @@cache[@value.to_s]

    end

    

    def style; @style; end

    def style=(value)

      loadCache(@style = value)

      return if @baseSprite.nil?

      refresh

    end

    

    def loadCache(style)

      @@cache = {}

      @@cache['false'] = RPG::Cache.radioBox(style + "/" + "0.png")

      @@cache['true']  = RPG::Cache.radioBox(style + "/" + "1.png")

    end

    

    def value; @value end

    def value=(value)

      return if @value == value

      for others in @@group[@group]

        next if others == self

        others.valueProc = false

        others.bitmapProc = @@cache[false.to_s]

        others.refresh

      end

      @value = value

      @bitmap = @@cache[@value.to_s]

      return if @baseSprite.nil?

      refresh

    end

        

    def group; @group end

    def group=(value)

      return if @group == value

      @@group[@group] ||= []

      @@group[@group].delete(self) if @@group[@group].include?(self) and @@group[@group].is_a?(Array)

      @group = value

      @@group[@group] ||= []

      @@group[@group].push(self) unless @@group[@group].include?(self)

      @@group[@group][0].valueProc = true if @@group[@group].size <= 1

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

    

    def bitmapProc=(value); @bitmap = value end

    def valueProc=(value); @value = value end

    

    def refresh

      @baseSprite.bitmap.clear

      @baseSprite.bitmap.blt(0, 0, @bitmap, Rect.new(0, 0, @bitmap.width, @bitmap.height))

    end



    def update

      super

      if click && isSelected

        Game.system.se_play(Config::DECISION_SE)

        self.value = true

      end

    end

    

    def dispose

      super

      @@group[@group].delete(self) if @@group[@group].include?(self)

    end

  end

end