# encoding: utf-8

#────────────────────────────────────────────────────────────────────────────
# ▶ MUI::ListBox
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2015. 02. 18
# --------------------------------------------------------------------------
# Description
# 
#    리스트박스 컨트롤을 담당하는 클래스입니다.
#────────────────────────────────────────────────────────────────────────────
class MUI
  class ListBox < Control
    def initialize(x, y, w, h)
      super(x, y, w, h)
      @name = Config::FONT[0]
      @size = Config::FONT_NORMAL_SIZE
      @color = [Color.gray, Color.system]
      @visible = true
      @opacity = 255
      @list = []
      @vsc = MUI::VScroll.new(@x + @width - 13, @y, 13, @height)
    end
    
    def getItemPerPage
      @lbl = []
      # 페이지에 보이는 요소 갯수 구하기
      @itemPerPage = @height / (@size + 2)# + 1
      @itemPerPage += 1 if @height % (@size + 2) != 0
      # (갯수+1)만큼 레이블 생성
      @vsc.x = @x + @width - @vsc.width
      @vsc.y = @y
      @itemPerPage.times do |n|
        next if @list[n] == nil
        @lbl[n] = MUI::Label.new(@x, @y + n * @size, @width - @vsc.width, @size)
        #@lbl[n].text = @list[n].to_s
        @parent.addControl(@lbl[n])
      end
      @vsc.max = @list.size - @itemPerPage
      @vsc.min = 0
    end
    
    def refresh
      @baseSprite.bitmap.clear
      @baseSprite.bitmap.fill_rect(0, 0, @width, @height, Color.white)
      @baseSprite.visible = @visible
      @baseSprite.opacity = @opacity
    end
    
    def update
      super
      # 스크롤바 포커스
      @vsc.focus = @vsc.id if Mouse.trigger? and isSelected
      @itemPerPage.times do |n|
        @lbl[n].text = @list[n + @vsc.value].to_s
        if @lbl[n].click
          #@lbl[n].color = @color[1]
          @focus = n + @vsc.value
        end
      end
    end
    
    def focus; @focus end
    def focus=(value)
      @focus = value
    end
    
    def addItem(*args)
      # 요소 추가
      @list.push(args)
      # 1차원 배열화
      @list.flatten!
    end
    
    def clear
      @list = []
      @vsc.max = @vsc.min
    end
    
    def removeItem(value)
      @list.delete_at(value)
    end
    
    def list(value); @list[value] end
    def listIndex; @focus; end
    
    def visible=(value)
      super
      @vsc.visible = value
      @lbl.each_index { |n| @lbl[n].visible = value }
    end
    
    def setParent(form)
      @parent = form
      @baseSprite = Sprite.new(form.getViewport)
      @baseSprite.bitmap = Bitmap.new(@width, @height)
      @baseSprite.x = @x
      @baseSprite.y = @y
      @realX = @x + form.getViewport.rect.x
      @realY = @y + form.getViewport.rect.y
      @parent.addControl(@vsc)
      getItemPerPage
      refresh
    end
  end
end