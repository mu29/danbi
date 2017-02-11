#────────────────────────────────────────────────────────────────────────────

# ▶ MUI::TextBox

# --------------------------------------------------------------------------

# Author    뮤 (mu29gl@gmail.com), jubin

# Date      2014

# --------------------------------------------------------------------------

# Description

# 

#    IME을 사용하는, 텍스트박스 컨트롤을 담당하는 클래스입니다.

#────────────────────────────────────────────────────────────────────────────

class MUI

  class TextBox < Control    

    def initialize(x, y, w, h)

      super(x, y, w, h)

      @align = 0

      @bold = false

      @color = Color.black

      @name = Config::FONT[0]

      @size = Config::FONT_NORMAL_SIZE

      @focus = false

      @italic = false

      @passwordChar = false

      @text = ""

      @helpText = ""

      @style = "White"

      @ime = IME.new

      loadCache(@style)

    end

      

    def loadCache(style)

      @@cache = {}

      @@cache['UL'] = RPG::Cache.textBox(style + "/" + "UL")

      @@cache['UM'] = RPG::Cache.textBox(style + "/" + "UM")

      @@cache['UR'] = RPG::Cache.textBox(style + "/" + "UR")

      @@cache['ML'] = RPG::Cache.textBox(style + "/" + "ML")

      @@cache['MM'] = RPG::Cache.textBox(style + "/" + "MM")

      @@cache['MR'] = RPG::Cache.textBox(style + "/" + "MR")

      @@cache['DL'] = RPG::Cache.textBox(style + "/" + "DL")

      @@cache['DM'] = RPG::Cache.textBox(style + "/" + "DM")

      @@cache['DR'] = RPG::Cache.textBox(style + "/" + "DR")

      

      @@cache['UL2'] = RPG::Cache.textBox(style + "/" + "UL2")

      @@cache['UM2'] = RPG::Cache.textBox(style + "/" + "UM2")

      @@cache['UR2'] = RPG::Cache.textBox(style + "/" + "UR2")

      @@cache['ML2'] = RPG::Cache.textBox(style + "/" + "ML2")

      @@cache['MM2'] = RPG::Cache.textBox(style + "/" + "MM2")

      @@cache['MR2'] = RPG::Cache.textBox(style + "/" + "MR2")

      @@cache['DL2'] = RPG::Cache.textBox(style + "/" + "DL2")

      @@cache['DM2'] = RPG::Cache.textBox(style + "/" + "DM2")

      @@cache['DR2'] = RPG::Cache.textBox(style + "/" + "DR2")

      @baseBitmap = []

    end

    

    def setParent(form)

      @parent = form

      @baseSprite = Sprite.new(form.getViewport)

      @textSprite = Sprite.new(form.getViewport)

      @textSprite.z = @baseSprite.z + 1

      @textBitmap = Bitmap.new(@width, @height)

      @baseSprite.x = @x

      @baseSprite.y = @y

      @textSprite.x = @x

      @textSprite.y = @y

      @realX = @x + form.getViewport.rect.x
      @realY = @y + form.getViewport.rect.y

      refresh

    end


    def setTitleParent(form)
      @parent = form

      @baseSprite = Sprite.new(form.getTitleViewport)

      @textSprite = Sprite.new(form.getTitleViewport)

      @textBitmap = Bitmap.new(@width, @height)

      @baseSprite.x = @x

      @baseSprite.y = @y

      @textSprite.x = @x

      @textSprite.y = @y

      @realX = @x + form.getViewport.rect.x
      @realY = @y + form.getViewport.rect.y

      refresh

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

      refresh

    end

    

    def color; @color; end

    def color=(value)

      return if @color == value

      @color = value

      return if @baseSprite.nil?

      refresh

    end

    

    def name; @name; end

    def name=(value)

      return if @name == value

      @name = value

      return if @baseSprite.nil?

      refresh

    end

    

    def size; @size; end

    def size=(value)

      return if @size == value

      @size = value

      return if @baseSprite.nil?

      refresh

    end

    

    def italic; @italic; end

    def italic=(value)

      return if @italic == value

      @italic = value

      return if @baseSprite.nil?

      refresh

    end



    def enable; @enable; end

    def enable=(value)

      return if @enable == value

      return unless value.is_a?(TrueClass) or value.is_a?(FalseClass)

      @enable = value

      return if @baseSprite.nil?

      if @enable

        @textBitmap.font.color = Color.gray

        @baseSprite.tone.set(0, 0, 0) if @baseSprite.tone != Tone.new(0, 0, 0)

      else

        @textBitmap.font.color = Color.gray(128)

        @baseSprite.tone.set(-20, -20, -20, 100) if @baseSprite.tone != Tone.new(-20, -20, -20, 100)

      end

      refresh

    end



    def visible; @visible; end

    def visible=(value)

      return if @visible == value

      return unless value.is_a?(TrueClass) or value.is_a?(FalseClass)

      @visible = value

      return if @baseSprite.nil?

      refresh

    end

    

    def style; @style end

    def style=(value)

      return if @style == value

      @style = value

      loadCache(@style)

      return if @baseSprite.nil?

      refresh

    end

    

    def passwordChar; @passwordChar; end

    def passwordChar=(value)

      return if @passwordChar == value

      @passwordChar = value

      return if @baseSprite.nil?

      refresh

    end

    

    def helpText; @helpText; end

    def helpText=(value)

      return if @helpText == value

      @helpText = value

      return if @textBitmap.nil?

      textRefresh

    end

    

    def text; @text end

    def text=(value)

      return if @text == value

      @text = value

      @ime.text = @text.split(//)

      @ime.setText

      return if @textBitmap.nil?

      textRefresh

    end

    

    def focus; @focus end

    def focus=(value)

      return if @focus == value

      return unless value.is_a?(TrueClass) or value.is_a?(FalseClass)

      @focus = value

      return if @textBitmap.nil?

      refresh

    end

    

    def update

      super

      if Mouse.trigger?

        if isSelected

          if not self.focus

            self.focus = true

            @ime.choice = false

            @ime.focus = true

            @baseSprite.bitmap = @baseBitmap[1]

            @ime.setIMEMode = @passwordChar ? 0 : 1

          end

        elsif self.focus

          self.focus = false

          @ime.choice = true

          @ime.focus = false

          @baseSprite.bitmap = @baseBitmap[0]

        end

      end

      if self.focus

        @ime.update

        textRefresh if @text != @ime.getText

      end

    end

        

    def refresh

      @gap = ((@height - @textBitmap.font.size) / 2.0).round

      @textSprite.y = @baseSprite.y - @gap

      @baseSprite.visible = @visible

      @baseSprite.opacity = @opacity

      baseRefresh

      @baseSprite.bitmap = @baseBitmap[self.focus ? 1 : 0].dup

      @textBitmap.font.name = @name

      @textBitmap.font.size = @size

      @textBitmap.font.bold = @bold

      @textBitmap.font.italic = @italic

      @textBitmap.font.color = @color

      @textSprite.visible = @visible

      @textSprite.opacity = @opacity

      @textSprite.bitmap = @textBitmap

      textRefresh

    end

    

    def baseRefresh

      # non-focus

      @baseBitmap[0] = Bitmap.new(@width, @height)

      @baseBitmap[0].clear

      @baseBitmap[0].blt(0, 0, @@cache['UL'], Rect.new(0, 0, @@cache['UL'].width, @@cache['UL'].height))

      @baseBitmap[0].blt(@width - @@cache['UR'].width, 0, @@cache['UR'], Rect.new(0, 0, @@cache['UR'].width, @@cache['UR'].height))

      @baseBitmap[0].stretch_blt(Rect.new(@@cache['UL'].width, 0, @width - (@@cache['UR'].width + @@cache['UL'].width), @@cache['UM'].height), @@cache['UM'], Rect.new(0, 0, @@cache['UM'].width, @@cache['UM'].height))

      @baseBitmap[0].stretch_blt(Rect.new(0, @@cache['UL'].height, @@cache['ML'].width, @height - (@@cache['UL'].height + @@cache['DL'].height)), @@cache['ML'], Rect.new(0, 0, @@cache['ML'].width, @@cache['ML'].height))

      @baseBitmap[0].stretch_blt(Rect.new(@width - @@cache['MR'].width, @@cache['UR'].height, @@cache['MR'].width, @height - (@@cache['UR'].height + @@cache['DR'].height)), @@cache['MR'], Rect.new(0, 0, @@cache['MR'].width, @@cache['MR'].height))

      @baseBitmap[0].stretch_blt(Rect.new(@@cache['ML'].width, @@cache['UL'].height, @width - (@@cache['ML'].width + @@cache['MR'].width), @height - (@@cache['UM'].height + @@cache['DM'].height)), @@cache['MM'], Rect.new(0, 0, @@cache['MM'].width, @@cache['MM'].height))

      @baseBitmap[0].blt(0, @height - @@cache['DL'].height, @@cache['DL'], Rect.new(0, 0, @@cache['DL'].width, @@cache['DL'].height))

      @baseBitmap[0].blt(@width - @@cache['DR'].width, @height - @@cache['DR'].height, @@cache['DR'], Rect.new(0, 0, @@cache['DR'].width, @@cache['DR'].height))

      @baseBitmap[0].stretch_blt(Rect.new(@@cache['DL'].width, @height - @@cache['DM'].height, @width - (@@cache['DR'].width + @@cache['DL'].width), @@cache['DM'].height), @@cache['DM'], Rect.new(0, 0, @@cache['DM'].width, @@cache['DM'].height))

      # focus

      @baseBitmap[1] = Bitmap.new(@width, @height)

      @baseBitmap[1].clear

      @baseBitmap[1].blt(0, 0, @@cache['UL2'], Rect.new(0, 0, @@cache['UL2'].width, @@cache['UL2'].height))

      @baseBitmap[1].blt(@width - @@cache['UR2'].width, 0, @@cache['UR2'], Rect.new(0, 0, @@cache['UR2'].width, @@cache['UR2'].height))

      @baseBitmap[1].stretch_blt(Rect.new(@@cache['UL2'].width, 0, @width - (@@cache['UR2'].width + @@cache['UL2'].width), @@cache['UM2'].height), @@cache['UM2'], Rect.new(0, 0, @@cache['UM2'].width, @@cache['UM2'].height))

      @baseBitmap[1].stretch_blt(Rect.new(0, @@cache['UL2'].height, @@cache['ML2'].width, @height - (@@cache['UL2'].height + @@cache['DL2'].height)), @@cache['ML2'], Rect.new(0, 0, @@cache['ML2'].width, @@cache['ML2'].height))

      @baseBitmap[1].stretch_blt(Rect.new(@width - @@cache['MR2'].width, @@cache['UR2'].height, @@cache['MR2'].width, @height - (@@cache['UR2'].height + @@cache['DR2'].height)), @@cache['MR2'], Rect.new(0, 0, @@cache['MR2'].width, @@cache['MR2'].height))

      @baseBitmap[1].stretch_blt(Rect.new(@@cache['ML2'].width, @@cache['UL2'].height, @width - (@@cache['ML2'].width + @@cache['MR2'].width), @height - (@@cache['UM2'].height + @@cache['DM2'].height)), @@cache['MM2'], Rect.new(0, 0, @@cache['MM2'].width, @@cache['MM2'].height))

      @baseBitmap[1].blt(0, @height - @@cache['DL2'].height, @@cache['DL2'], Rect.new(0, 0, @@cache['DL2'].width, @@cache['DL2'].height))

      @baseBitmap[1].blt(@width - @@cache['DR2'].width, @height - @@cache['DR2'].height, @@cache['DR2'], Rect.new(0, 0, @@cache['DR2'].width, @@cache['DR2'].height))

      @baseBitmap[1].stretch_blt(Rect.new(@@cache['DL2'].width, @height - @@cache['DM2'].height, @width - (@@cache['DR2'].width + @@cache['DL2'].width), @@cache['DM2'].height), @@cache['DM2'], Rect.new(0, 0, @@cache['DM2'].width, @@cache['DM2'].height))

    end

    

    def textRefresh

      @text = @ime.getText

      @textBitmap.clear

      if @text == ""

        if @helpText != "" and @helpText != nil

          @textBitmap.font.color = Color.gray(128)

          @textBitmap.draw_text(@gap, @gap * 2, 

          @textBitmap.text_size(@helpText).width,

          @textBitmap.text_size(@helpText).height, @helpText.to_s)

          @textBitmap.font.color = @color

        end

      else

        @textBitmap.draw_text(@gap, @gap, @width, @height, (@passwordChar ? @passwordChar * @text.size : @text))

        @textSprite.bitmap = @textBitmap

      end

    end



    def dispose

      super

      @text = ""

      @ime.dispose

    end

  end

end