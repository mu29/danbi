#────────────────────────────────────────────────────────────────────────────

# ▶ MUI::Label

# --------------------------------------------------------------------------

# Author    뮤 (mu29gl@gmail.com), jubin

# Date      2014

# --------------------------------------------------------------------------

# Description

# 

#    레이블 컨트롤을 담당하는 클래스입니다.

#────────────────────────────────────────────────────────────────────────────

class MUI

  class Label < Control

    def initialize(x, y, w, h)

      super(x, y, w, h)

      @align = 0

      @bold = false

      @italic = false

      @color = [Color.black, nil]

      @name = Config::FONT[0]

      @size = Config::FONT_NORMAL_SIZE

      @underLine = false

      @middleLine = false

      @text = ""

    end

      

    # 정렬 // 왼쪽 0, 가운데 1, 오른쪽 2

    def align; @align end

    def align=(value)

      return if @align == value

      @align = value

      return if @baseSprite.nil?

      refresh

    end

    

    # 굵게

    def bold; @bold end

    def bold=(value)

      return if @bold == value

      @bold = value

      return if @baseSprite.nil?

      @baseSprite.bitmap.font.bold = @bold

      refresh

    end

    

    # 기울기

    def italic; @italic end

    def italic=(value)

      return if @italic == value

      @italic = value

      return if @baseSprite.nil?

      @baseSprite.bitmap.font.italic = @italic

      refresh

    end

    

    # 안쪽 색깔

    def color; @color[0] end

    def color=(value)

      return if @color[0] == value

      @color[0] = value

      return if @baseSprite.nil?

      @baseSprite.bitmap.font.color = @color[0]

      refresh

    end

    

    # 바깥쪽 색깔

    def color2; @color[1] end

    def color2=(value)

      return if @color[1] == value

      @color[1] = value

      return if @baseSprite.nil?

      return unless @color[1].is_a?(Color)

      refresh

    end

    

    # 폰트명

    def name; @name end

    def name=(value)

      return if @name == value

      @name = value

      return if @baseSprite.nil?

      @baseSprite.bitmap.font.name = @name

      refresh

    end

    

    # 크기

    def size; @size end

    def size=(value)

      return if @size == value

      @size = value

      return if @baseSprite.nil?

      @baseSprite.bitmap.font.size = @size

      refresh

    end

    

    # 취소선

    def middleLine; @middleLine end

    def middleLine=(value)

      return if @middleLine == value

      @middleLine = value

      return if @baseSprite.nil?

      refresh

    end

    

    # 밑줄

    def underLine; @underLine end

    def underLine=(value)

      return if @underLine == value

      @underLine = value

      return if @baseSprite.nil?

      refresh

    end

    

    # 텍스트

    def text; @text end

    def text=(value)

      return if @text == value

      @text = value

      return if @baseSprite.nil?

      refresh

    end

    

    # 자동 크기

    def autoSize

      return if @text.nil? or @text == ""

      return if @baseSprite.nil?

      @esn = true

      str = @text.split "\n"

      for i in 0...str.size

        width ||= Array.new

        width.push(@baseSprite.bitmap.text_size(str[i]).width)

        width = width.max if i == str.size - 1

      end

      height = @baseSprite.bitmap.get_divided_text(width, @text, @esn).size * @baseSprite.bitmap.font.size

      self.width = width

      self.height = height

    end

    

    # 리프레시

    def refresh

      @baseSprite.bitmap.clear

      @baseSprite.bitmap.font.name = @name

      @baseSprite.bitmap.font.size = @size

      @baseSprite.bitmap.font.bold = @bold

      @baseSprite.bitmap.font.italic = @italic

      @baseSprite.bitmap.font.color = @color[0]

      @baseSprite.visible = @visible

      @baseSprite.opacity = @opacity

      if @color[1].is_a?(Color)

        @baseSprite.bitmap.draw_multi_outline_text(0, 0, @width, @height, @text, @color[0], @color[1], @align)

      else

        @baseSprite.bitmap.draw_multi_text(0, 0, @width, @height, @text, @align, @esn)

      end

      @baseSprite.bitmap.fill_line(@text, @color[1].is_a?(Color) ? @color[1] : @color[0], @align, 1, @esn) if @middleLine

      @baseSprite.bitmap.fill_line(@text, @color[1].is_a?(Color) ? @color[1] : @color[0], @align, 2, @esn) if @underLine

    end

    

    # 클릭

    def click(id = 0)

      super

      id = 0 if not id.between?(0,2)

      if isSelected && Mouse.trigger?(id) && @visible

        Game.system.se_play(Config::DECISION_SE)

        return true

      else

        return false

      end

    end

    

    # 꾹 클릭

    def repeat(id = 0)

      super

      id = 0 if not id.between?(0,2)

      if isSelected && Mouse.repeat?(id) && @visible

        Game.system.se_play(Config::DECISION_SE)

        return true

      else

        return false

      end

    end

  end

end