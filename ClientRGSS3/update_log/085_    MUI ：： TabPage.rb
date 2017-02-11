#────────────────────────────────────────────────────────────────────────────

# ▶ MUI::TabPage

# --------------------------------------------------------------------------

# Author    뮤 (mu29gl@gmail.com), jubin

# Date      2015. 02. 17

# --------------------------------------------------------------------------

# Description

# 

#    탭 컨트롤을 담당하는 클래스입니다.

#    탭 길이에 오차가 생기면 자동 조정합니다.

#────────────────────────────────────────────────────────────────────────────

class MUI

  class TabPage < Control

    attr_reader :page

    

    def initialize(x, y, w, h)

      super(x, y, w, h)

      loadCache(@style = "White")

      @align = 1

      @bold = false

      @italic = false

      @color = [Color.gray, Color.white]

      @name = Config::FONT[0]

      @size = Config::FONT_NORMAL_SIZE

      @item = [""]

      @tab = []

      @page = 0

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

      @item.each_index { |n| @baseSprite[n].bitmap.font.bold = @bold }

      refresh

    end

    

    # 기울기

    def italic; @italic end

    def italic=(value)

      return if @italic == value

      @italic = value

      return if @baseSprite.nil?

      @item.each_index { |n| @baseSprite[n].bitmap.font.italic = @italic }

      refresh

    end

    

    # 기본 색깔

    def color; @color[0] end

    def color=(value)

      return if @color[0] == value

      @color[0] = value

      return if @baseSprite.nil?

      @item.each_index { |n| @baseSprite[n].bitmap.font.color = @color[0] }

      refresh

    end

    

    # 선택 색깔

    def color2; @color[1] end

    def color2=(value)

      return if @color[1] == value

      @color[1] = value

      return if @baseSprite.nil?

      @item.each_index { |n| @baseSprite[n].bitmap.font.color = @color[1] }

      refresh

    end

    

    # 폰트명

    def name; @name end

    def name=(value)

      return if @name == value

      @name = value

      return if @baseSprite.nil?

      @item.each_index { |n| @baseSprite[n].bitmap.font.name = @name }

      refresh

    end

    

    # 크기

    def size; @size end

    def size=(value)

      return if @size == value

      @size = value

      return if @baseSprite.nil?

      @item.each_index { |n| @baseSprite[n].bitmap.font.size = @size }

      refresh

    end

    

    def item; @item end

    def item=(value)

      return if @item == value

      @item = value

      return if @baseSprite.nil?

      refresh

    end



    def tab; @tab end

    def page; @page end

      

    def style; @style; end

    def style=(value)

      loadCache(@style = value)

      return if @baseSprite.nil?

      refresh

    end

      

    def loadCache(style)

      @@cache = {}

      @@cache['L'] = RPG::Cache.tab(style + "/" + "L")

      @@cache['M'] = RPG::Cache.tab(style + "/" + "M")

      @@cache['R'] = RPG::Cache.tab(style + "/" + "R")

      @@cache['L2'] = RPG::Cache.tab(style + "/" + "L2")

      @@cache['M2'] = RPG::Cache.tab(style + "/" + "M2")

      @@cache['R2'] = RPG::Cache.tab(style + "/" + "R2")

    end

    

    def setParent(form)

      @parent = form

      @tabWidth = @width / @item.size.to_f

      autoSize if @width % @item.size.to_i != 0

      for page in 0...@item.size

        @tab[page] = Tab.new(@parent)

      end

      @baseSprite = []

      for n in 0...@item.size

        @baseSprite[n] = Sprite.new(form.getViewport)

        @baseSprite[n].x = @x + @tabWidth * n

        @baseSprite[n].y = @y

      end

      @realX = @x + form.getViewport.rect.x
      @realY = @y + form.getViewport.rect.y

      refresh

    end



    def set

      for i in 0...@item.size

        next if i == @page

        @tab[i].visible = false

      end

      @tab[@page].visible = true

    end

    

    def refresh

      self.set

      bitmapRefresh

      @item.each_index { |n| baseRefresh(n) }

    end

    

    def baseRefresh(n)

      @baseSprite[n].bitmap = @baseBitmap[@page == n ? 1 : 0].dup

      @baseSprite[n].bitmap.font.color = Color.gray

      @baseSprite[n].bitmap.font.name = @name

      @baseSprite[n].bitmap.font.size = @size

      @baseSprite[n].bitmap.font.bold = @bold

      @baseSprite[n].bitmap.font.italic = @italic

      @baseSprite[n].bitmap.font.color = @color[@page == n ? 1 : 0]

      @baseSprite[n].visible = @visible

      @baseSprite[n].opacity = @opacity

      @baseSprite[n].bitmap.draw_text(0, 0, @baseSprite[n].bitmap.width, @baseSprite[n].bitmap.height, @item[n], @align)

    end

    

    def bitmapRefresh

      @baseBitmap = []

      @baseBitmap[0] = Bitmap.new(@tabWidth, @height)

      @baseBitmap[0].blt(0, 0, @@cache['L'], Rect.new(0, 0, @@cache['L'].width, @@cache['L'].height))

      @baseBitmap[0].blt(@width - @@cache['R'].width, 0, @@cache['R'], Rect.new(0, 0, @@cache['R'].width, @@cache['R'].height))

      @baseBitmap[0].stretch_blt(Rect.new(@@cache['L'].width, 0, width - (@@cache['L'].width + @@cache['R'].width), @@cache['M'].height), @@cache['M'], Rect.new(0, 0, @@cache['M'].width, @@cache['M'].height))

      @baseBitmap[1] = Bitmap.new(@tabWidth, @height)

      @baseBitmap[1].blt(0, 0, @@cache['L2'], Rect.new(0, 0, @@cache['L2'].width, @@cache['L2'].height))

      @baseBitmap[1].blt(@width - @@cache['R2'].width, 0, @@cache['R2'], Rect.new(0, 0, @@cache['R2'].width, @@cache['R2'].height))

      @baseBitmap[1].stretch_blt(Rect.new(@@cache['L2'].width, 0, width - (@@cache['L2'].width + @@cache['R2'].width), @@cache['M2'].height), @@cache['M2'], Rect.new(0, 0, @@cache['M2'].width, @@cache['M2'].height))      

    end

    

    def autoSize

      @tabWidth = @tabWidth.to_i

      self.width = @tabWidth * @item.size

    end

    

    def isSelected?

      for n in 0...@item.size

        if Mouse.x >= @baseSprite[n].x + @realX - @x and

          Mouse.x <= @baseSprite[n].x + @tabWidth + @realX - @x and

          Mouse.y >= @baseSprite[n].y + @realY - @y and

          Mouse.y <= @baseSprite[n].y + @height + @realY - @y and

          select = n

        end

      end

      return select

    end

    

    def update

      super

      if Mouse.trigger?

        if (n = isSelected?) != nil

          @page = n

          refresh

          Game.system.se_play(Config::DECISION_SE)

        end

      end

    end

    

    def dispose

      super

      @baseBitmap[0].dispose

      @baseBitmap[1].dispose

      @baseBitmap = nil

      @item.each_index do |n|

        @baseSprite[n].dispose

      end

    end

    

    # 탭 구성원 컨트롤

    class Tab

      def initialize(form)

        @control = []

        @parent = form

      end

      

      def visible=(value)

        for control in @control

          control.visible = value

        end

      end

      

      def addControl(control)

        @parent.addControl(control)

        @control.push(control)

      end

      

      def dispose

        super

        @control = nil

      end

    end

  end

end