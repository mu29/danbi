#────────────────────────────────────────────────────────────────────────────

# ▶ MUI::Form

# --------------------------------------------------------------------------

# Author    뮤 (mu29gl@gmail.com), jubin

# Date      2014

# --------------------------------------------------------------------------

# Description

# 

#    폼을 담당하는 클래스입니다.

#────────────────────────────────────────────────────────────────────────────

class MUI

  class Form

    def initialize(x, y, w, h)

      @x = (x == 'center' ? (Graphics.getRect[0] - w) / 2 : x)

      @y = (y == 'center' ? (Graphics.getRect[1] - h) / 2 : y)

      @width = w

      @height = h

      @opacity = 255

      @captionText = nil

      @drag = true

      @close = true

      @controls = []

      @@cache = {}

      @style = "White"

      loadCache(@style)

      # 뷰포트, 스프라이트, 비트맵 생성

      titleHeight = @@cache['TM'].height

      @titleViewport = Viewport.new(@x, @y, @width, titleHeight)

      @baseViewport = Viewport.new(@x, @y + titleHeight, @width, @height - titleHeight)

      @titleSprite = Sprite.new(@titleViewport)

      @captionSprite = Sprite.new(@titleViewport)

      @baseSprite = Sprite.new(@baseViewport)

      @titleSprite.bitmap = Bitmap.new(@width, titleHeight)

      @captionSprite.bitmap = Bitmap.new(@width, titleHeight)

      @baseSprite.bitmap = Bitmap.new(@width, @height - titleHeight)

      # 닫기 버튼

      @pic_close = MUI::PictureBox.new(@width - @@cache['X'].width * 1.5, (@titleViewport.rect.height - @@cache['X'].height).abs / 2, @@cache['X'].width, @@cache['X'].height)

      @pic_close.picture = @@cache['X']

      addTitleControl(@pic_close)

      @pic_close.visible = @close

      # 툴팁

      @tipSprite = Sprite.new

      @tipSprite.bitmap = Bitmap.new(1, 1)

      @tipSprite.z = 9999999

      @toolTip = ""

      refresh

      MUI.addForm(self)

    end

    

    def refresh

      @titleSprite.bitmap.clear

      @baseSprite.bitmap.clear

      @titleSprite.bitmap.blt(0, 0, @@cache['TL'], Rect.new(0, 0, @@cache['TL'].width, @@cache['TL'].height))

      @titleSprite.bitmap.stretch_blt(Rect.new(@@cache['TL'].width, 0, @width - (@@cache['TR'].width + @@cache['TL'].width), @@cache['TM'].height), @@cache['TM'], Rect.new(0, 0, @@cache['TM'].width, @@cache['TM'].height))

      @titleSprite.bitmap.blt(@width - @@cache['TR'].width, 0, @@cache['TR'], Rect.new(0, 0, @@cache['TR'].width, @@cache['TR'].height))

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

    end

    

    def titleRefresh(align = 1)

      return if @captionText.nil?

      @captionSprite.x = case align

      when 0

        @captionSprite.bitmap.font.size

      when 1

        (@width - @captionSprite.bitmap.text_size(@captionText).width) / 2

      when 2

        @width - @captionSprite.bitmap.text_size(@captionText).width - @captionSprite.bitmap.font.size

      end

      @captionSprite.y = (@titleViewport.rect.height - @captionSprite.bitmap.font.size) / 2

    end

    

    def x; @x end

    def x=(value)

      return if @x == value

      delta = value - @x

      @x = value

      @titleViewport.rect.x += delta

      @baseViewport.rect.x += delta

      for con in @controls

        con.realX += delta

      end

    end

    

    # y

    def y; @y end

    def y=(value)

      return if @y == value

      delta = value - @y

      @y = value      

      @titleViewport.rect.y += delta

      @baseViewport.rect.y += delta

      for con in @controls

        con.realY += delta

      end

    end

    

    def z=(value)

      @titleViewport.z = value

      @baseViewport.z = value

    end

    

    # 너비

    def width; @width end

    def width=(value)

      return if @width == value

      @width = value

      @titleViewport.rect.width = @width

      @baseViewport.rect.width = @width

      @titleSprite.bitmap.dispose

      @captionSprite.bitmap.dispose

      @baseSprite.bitmap.dispose

      @titleSprite.bitmap   = Bitmap.new(@titleViewport.rect.width, @titleViewport.rect.height)

      @captionSprite.bitmap = Bitmap.new(@titleViewport.rect.width, @titleViewport.rect.height)

      @baseSprite.bitmap    = Bitmap.new(@baseViewport.rect.width, @height - @titleViewport.rect.height)

      @pic_close.x = @width - @@cache['X'].width * 1.5

      refresh

      titleRefresh

    end

      

    # 높이

    def height; @height end

    def height=(value)

      return if @height == value

      @height = value

      @baseViewport.rect.height = @height - @titleViewport.rect.height

      @titleSprite.bitmap.dispose

      @captionSprite.bitmap.dispose

      @baseSprite.bitmap.dispose

      @titleSprite.bitmap   = Bitmap.new(@titleViewport.rect.width, @titleViewport.rect.height)

      @captionSprite.bitmap = Bitmap.new(@titleViewport.rect.width, @titleViewport.rect.height)

      @baseSprite.bitmap    = Bitmap.new(@baseViewport.rect.width, @height - @titleViewport.rect.height)

      refresh

    end

    

    # 드래그

    def drag; @drag end

    def drag=(value)

      return if @drag == value

      return unless value.is_a?(TrueClass) or value.is_a?(FalseClass)

      @drag = value

    end

    

    # 닫기

    def close; @close end

    def close=(value)

      return if @close == value

      return unless value.is_a?(TrueClass) or value.is_a?(FalseClass)

      @pic_close.visible = @close = value

    end

    

    # 폼 스타일

    def style; @style end

    def style=(value)

      return if @style == value

      loadCache(@style = value)

      @titleViewport.rect = Rect.new(@x, @y, @width, @@cache['TM'].height)

      @baseViewport.rect  = Rect.new(@x, @y + @titleViewport.rect.height, @width, @height - @titleViewport.rect.height)

      refresh

    end

    

    # 투명도

    def opacity; @opacity end

    def opacity=(value)

      return if @opacity == value

      if value.between?(0, 255)

        @opacity = value

        @titleSprite.opacity = @opacity

        @captionSprite.opacity = @opacity

        @baseSprite.opacity = @opacity

      end

    end



    # 타이틀

    def getTitle; @captionText end

    def setTitle(text, align = 1, color = (@style == "Black" ? Color.white : (@style == "White" ? Color.gray : Color.black)), font = Config::FONT[0], size = Config::FONT_NORMAL_SIZE + 1)

      #return if @captionText == text

      @captionText = text

      @captionSprite.bitmap.clear

      @captionSprite.bitmap.font.name = font

      @captionSprite.bitmap.font.size = size      

      @captionSprite.bitmap.font.color = color

      @captionSprite.bitmap.font.bold = true

      @captionSprite.bitmap.draw_text(0, 0, @captionSprite.bitmap.text_size(text).width + 1, size, text, 0)

      titleRefresh(align)

    end



    def loadCache(style)

      @@cache['TL'] = RPG::Cache.form(style + "/" + "TL")

      @@cache['TM'] = RPG::Cache.form(style + "/" + "TM")

      @@cache['TR'] = RPG::Cache.form(style + "/" + "TR")

      @@cache['UL'] = RPG::Cache.form(style + "/" + "UL")

      @@cache['UM'] = RPG::Cache.form(style + "/" + "UM")

      @@cache['UR'] = RPG::Cache.form(style + "/" + "UR")

      @@cache['ML'] = RPG::Cache.form(style + "/" + "ML")

      @@cache['MM'] = RPG::Cache.form(style + "/" + "MM")

      @@cache['MR'] = RPG::Cache.form(style + "/" + "MR")

      @@cache['DL'] = RPG::Cache.form(style + "/" + "DL")

      @@cache['DM'] = RPG::Cache.form(style + "/" + "DM")

      @@cache['DR'] = RPG::Cache.form(style + "/" + "DR")

      @@cache['X']  = RPG::Cache.form(style + "/" + "X")

      @@cache['X2'] = RPG::Cache.form(style + "/" + "X2")

    end

    

    # 마우스가 범위에 들어올 때

    def isMouseOver

      x, y = Mouse.x, Mouse.y

      return false if (not x or not y)

      if @x <= x && @x + @width > x && @y <= y && @y + @height > y

        return true

      else

        return false

      end

    end



    # 마우스가 올려질 때

    def isSelected

      if isMouseOver && MUI.getFocus == self

        return true

      end

      return false

    end



    #  폼_뷰포트 취득

    def getViewport

      return @baseViewport

    end

    

    # 폼타이틀_뷰포트 취득

    def getTitleViewport

      return @titleViewport

    end



    # 컨트롤 취득

    def getControls

      return @controls

    end

    

    # 폼_컨트롤 추가

    def addControl(control)

      control.setParent(self)

      @controls.push(control)

    end

    

    # 폼타이틀_컨트롤 추가
    def addTitleControl(control)

      control.setTitleParent(self)
      @controls.push(control)
    end

    

    # 텍스트 라인 수 리턴

    def line(width, str)

      return if @baseSprite.nil?

      return @baseSprite.bitmap.line(width, str)

    end



    # 컨트롤 툴팁

    def drawToolTip(value)

      @tipSprite.x, @tipSprite.y = Mouse.x, Mouse.y

      return if value == @toolTip

      @toolTip = value

      # 텍스트 사이즈 취득

      @tipSprite.bitmap = Bitmap.new(1, 1)

      width = Array.new

      str = @toolTip.split "\n"

      str.each_index { |n| width.push(@tipSprite.bitmap.text_size(str[n]).width) }

      height = str.size * Config::FONT_NORMAL_SIZE

      # 재생성

      @tipSprite.bitmap = Bitmap.new(width.max + 2, height + 2)

      @tipSprite.bitmap.clear

      @tipSprite.bitmap.fill_rect(0, 0, @tipSprite.bitmap.width, @tipSprite.bitmap.height, Color.black(128))

      @tipSprite.bitmap.draw_multi_text(0, 0, @tipSprite.bitmap.width, @tipSprite.bitmap.height, @toolTip)

    end

    

    def disposeToolTip

      @toolTipDraw = false

      @toolTip = ""

      @tipSprite.bitmap.dispose

    end

    

    # 업데이트

    def update

      return if MUI.getFocus != self

      @toolTipDraw = false

      # 컨트롤 업데이트

      for con in @controls

        con.update

        if con.isSelected and con.toolTip != ""

          @toolTipDraw = true

          drawToolTip(con.toolTip)

        end

      end

      if not @toolTipDraw and not @tipSprite.bitmap.disposed?

        @toolTip = ""

        @tipSprite.bitmap.dispose

      end

      # 드래그

      if Mouse.press? and @drag and isMouseOver

        cx = Mouse.x - Mouse.ox

        cy = Mouse.y - Mouse.oy

        self.x -= cx

        self.y -= cy

        Mouse.x -= cx

        Mouse.y -= cy

      end

      # 닫기 버튼

      @pic_close.picture = @pic_close.isSelected ? @@cache['X2'] : @@cache['X']

      if @close && Key.trigger?(KEY_ESCAPE)

        dispose

      end

      if @pic_close.click

        dispose

      end

    end



    # 삭제

    def dispose

      MUI.deleteForm(self)

      # 컨트롤 삭제

      for con in @controls

        con.dispose

      end

      # 메모리 해제

      self.instance_variables.each do |v|

        if instance_variable_get(v).is_a?(Sprite)

          instance_variable_get(v).dispose

          instance_variable_set(v, nil)

        end

      end

      GC.start

    end

  end

end