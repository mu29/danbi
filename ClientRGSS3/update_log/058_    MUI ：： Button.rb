#────────────────────────────────────────────────────────────────────────────

# ▶ MUI::Button

# --------------------------------------------------------------------------

# Author    뮤 (mu29gl@gmail.com), jubin

# Date      2014

# --------------------------------------------------------------------------

# Description

# 

#    버튼 컨트롤을 담당하는 클래스입니다.

#────────────────────────────────────────────────────────────────────────────

class MUI

  class Button < Control

    def initialize(x, y, w, h)

      super(x, y, w, h)      

      @align = 1

      @bold = false

      @color = Color.white

      @name = Config::FONT[0]

      @size = Config::FONT_NORMAL_SIZE

      @italic = false

      @text = ""

      @picture = nil

      @enable = true

      @visible = true

      loadCache(@style = "Blue")

    end

        

    def align; @align; end

    def align=(value)

      return if @align == value

      @align = value

      return if @baseSprite.nil?

      refresh

    end

    

    def bold; @bold; end

    def bold=(value)

      return if @bold == value

      @bold = value

      return if @baseSprite.nil?

      @baseSprite.bitmap.font.bold = @bold

      refresh

    end

    

    def color; @color; end

    def color=(value)

      return if @color == value

      @color = value

      return if @baseSprite.nil?

      @baseSprite.bitmap.font.color = @color

      refresh

    end

      

    def name; @name; end

    def name=(value)

      return if @name == value

      @name = value

      return if @baseSprite.nil?

      @baseSprite.bitmap.font.name = @name

      refresh

    end

    

    def size; @size; end

    def size=(value)

      return if @size == value

      @size = value

      return if @baseSprite.nil?

      @baseSprite.bitmap.font.size = @size

      refresh

    end

    

    def italic; @italic; end

    def italic=(value)

      return if @italic == value

      @italic = value

      return if @baseSprite.nil?

      @baseSprite.bitmap.font.italic = @italic

      refresh

    end



    def text; @text; end

    def text=(text)

      return if @text == text

      @text = text

      return if @baseSprite.nil?

      refresh

    end

    

    def picture; @picture; end

    def picture=(path)

      if path.is_a?(String)

        @picture = Bitmap.new(path)

      elsif path.is_a?(Bitmap)

        @picture = path

      end

      return if @baseSprite.nil?

      refresh

    end

    

    def style; @style; end

    def style=(value)

      loadCache(@style = value)

      return if @baseSprite.nil?

      refresh

    end

    

    def refresh

      @baseSprite.bitmap.clear

      # Proverty

      @baseSprite.bitmap.font.name = @name

      @baseSprite.bitmap.font.size = @size

      @baseSprite.bitmap.font.bold = @bold

      @baseSprite.bitmap.font.italic = @italic

      @baseSprite.bitmap.font.color = @color

      @baseSprite.visible = @visible

      @baseSprite.opacity = @opacity

      # Button

      height = @baseSprite.bitmap.height

      @baseSprite.bitmap.blt(0, 0, @@cache['UL'], Rect.new(0, 0, @@cache['UL'].width, @@cache['UL'].height))

      @baseSprite.bitmap.blt(@width - @@cache['UR'].width, 0, @@cache['UR'], Rect.new(0, 0, @@cache['UR'].width, @@cache['UR'].height))

      @baseSprite.bitmap.stretch_blt(Rect.new(@@cache['UL'].width, 0, @width - (@@cache['UR'].width + @@cache['UL'].width), @@cache['UM'].height), @@cache['UM'], Rect.new(0, 0, @@cache['UM'].width, @@cache['UM'].height))

      @baseSprite.bitmap.stretch_blt(Rect.new(0, @@cache['UL'].height, @@cache['ML'].width, height - (@@cache['UL'].height + @@cache['DL'].height)), @@cache['ML'], Rect.new(0, 0, @@cache['ML'].width, @@cache['ML'].height))

      @baseSprite.bitmap.stretch_blt(Rect.new(@width - @@cache['MR'].width, @@cache['UR'].height, @@cache['MR'].width, height - (@@cache['UR'].height + @@cache['DR'].height)), @@cache['MR'], Rect.new(0, 0, @@cache['MR'].width, @@cache['MR'].height))

      @baseSprite.bitmap.stretch_blt(Rect.new(@@cache['ML'].width, @@cache['UL'].height, @width - (@@cache['ML'].width + @@cache['MR'].width), height - (@@cache['UM'].height + @@cache['DM'].height)), @@cache['MM'], Rect.new(0, 0, @@cache['MM'].width, @@cache['MM'].height))

      @baseSprite.bitmap.blt(0, height - @@cache['DL'].height, @@cache['DL'], Rect.new(0, 0, @@cache['DL'].width, @@cache['DL'].height))

      @baseSprite.bitmap.blt(@width - @@cache['DR'].width, height - @@cache['DR'].height, @@cache['DR'], Rect.new(0, 0, @@cache['DR'].width, @@cache['DR'].height))

      @baseSprite.bitmap.stretch_blt(Rect.new(@@cache['DL'].width, height - @@cache['DM'].height, @width - (@@cache['DR'].width + @@cache['DL'].width), @@cache['DM'].height), @@cache['DM'], Rect.new(0, 0, @@cache['DM'].width, @@cache['DM'].height))

      # Picture

      if @text.nil? or (@text.is_a?(String) and @text.empty?)

        length = 0; @text = ""

      else

        length = @baseSprite.bitmap.get_divided_text(@width, @text).size

      end

      @baseSprite.bitmap.blt((@width - @picture.width) / 2,

        (@height - @picture.height - length * @baseSprite.bitmap.font.size) / 2,

        @picture, Rect.new(0, 0, @picture.width, @picture.height)) if @picture.is_a?(Bitmap)

      # text

      @baseSprite.bitmap.draw_multi_text(0, 

        ((@height - length * @baseSprite.bitmap.font.size) / 2) + (@picture.is_a?(Bitmap) ? @picture.height / 2 : 0),

        @width, @height, @text, @align)

      # enable

      @enable ? @baseSprite.tone.set(0, 0, 0) : @baseSprite.tone.set(-20, -20, -20, 100)

    end

      

    def loadCache(style)

      @@cache = {}

      @@cache['UL'] = RPG::Cache.button(style + "/" + "UL")

      @@cache['UM'] = RPG::Cache.button(style + "/" + "UM")

      @@cache['UR'] = RPG::Cache.button(style + "/" + "UR")

      @@cache['ML'] = RPG::Cache.button(style + "/" + "ML")

      @@cache['MM'] = RPG::Cache.button(style + "/" + "MM")

      @@cache['MR'] = RPG::Cache.button(style + "/" + "MR")

      @@cache['DL'] = RPG::Cache.button(style + "/" + "DL")

      @@cache['DM'] = RPG::Cache.button(style + "/" + "DM")

      @@cache['DR'] = RPG::Cache.button(style + "/" + "DR")

    end



    def update

      super

      if isSelected and @visible and @enable

        @baseSprite.opacity = 150 if @baseSprite.opacity != 150

      else

        @baseSprite.opacity = 255 if @baseSprite.opacity != 255

      end

    end

    

    def click(id = 0)

      super

      id = 0 if not id.between?(0, 2)

      if Mouse.trigger?(id) and isSelected and @visible

        if @enable

          Game.system.se_play(Config::DECISION_SE)

          return true

        else

          Game.system.se_play(Config::BUZZER_SE)

          return false

        end

      else

        return false

      end

    end

    

    def press(id = 0)

      id = 0 if not id.between?(0, 2)

      if isSelected

        @baseSprite.opacity = 150

        return true if Mouse.press?(id) and @visible

      else

        @baseSprite.opacity = 255

        return false

      end

    end

  end

end