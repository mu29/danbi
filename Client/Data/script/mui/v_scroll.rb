# encoding: utf-8

#────────────────────────────────────────────────────────────────────────────
# ▶ MUI::VScroll
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2015. 02. 11
# --------------------------------------------------------------------------
# Description
# 
#    수직 스크롤바 컨트롤을 담당하는 클래스입니다.
#    바 드래그, 마우스 휠, 버튼 등을 사용할 수 있습니다.
#────────────────────────────────────────────────────────────────────────────
class MUI
  class VScroll < Control
    def initialize(x, y, w, h)
      super(x, y, w, h)
      loadCache(@style = "White")
      @barHeight = @height - (@@cache['VU'].height + @@cache['VD'].height + @@cache['VBU'].height + @@cache['VBD'].height)
      @max = 9
      @min = 0
      @num = @max - @min + 1
      @dh = @barHeight / @num.to_f
      @value = 0
      @scrolling = false
      @focus = nil
    end
    
    def style; @style; end
    def style=(value)
      loadCache(@style = value)
      return if @baseSprite.nil?
      refresh
    end

    def loadCache(style)
      @@cache = {}
      # Base Vertical
      @@cache['VU'] = RPG::Cache.vScroll(style + "/" + "VU")
      @@cache['VM'] = RPG::Cache.vScroll(style + "/" + "VM")
      @@cache['VD'] = RPG::Cache.vScroll(style + "/" + "VD")
      # Bar
      @@cache['VBU'] = RPG::Cache.vScroll(style + "/" + "VBU")
      @@cache['VBM'] = RPG::Cache.vScroll(style + "/" + "VBM")
      @@cache['VBD'] = RPG::Cache.vScroll(style + "/" + "VBD")
      @barHeight = @height - (@@cache['VU'].height + @@cache['VD'].height + @@cache['VBU'].height + @@cache['VBD'].height)
      @dh = @barHeight / @num.to_f
    end

    def setParent(form)
      @parent = form
      @baseSprite = Sprite.new(form.getViewport)
      @baseSprite.bitmap = Bitmap.new(@width, @height)
      @barSprite = Sprite.new(form.getViewport)
      @barSprite.bitmap = Bitmap.new(@width, @height)
      @baseSprite.x = @x
      @baseSprite.y = @y
      @barSprite.x = @x
      @barSprite.y = @y + @@cache['VU'].height
      @realX = @x + form.getViewport.rect.x
      @realY = @y + form.getViewport.rect.y
      refresh
    end
    
    def update
      super
      # 백그라운드 클릭
      if Mouse.trigger? and @visible
        # 포커스 등록
        @focus = isSelected ? self.object_id : nil
        # 클릭으로 조작
        if @focus and isSelected and not isBarSelected and not isUpSelected and not isDownSelected
          self.value = (Mouse.y - @realY - @@cache['VU'].height) / @dh
          Game.system.se_play(Config::BUZZER_SE)
        end
      end
      
      # 키보드로 조작
      if @focus == self.object_id
        # 아래, 오른쪽 키를 눌렀을 때
        if Key.repeat?(Key::KB_DOWN) or Key.repeat?(Key::KB_RIGHT)
          # 값 +1
          self.value += 1
        # 위, 왼쪽 키를 눌렀을 때
        elsif Key.repeat?(Key::KB_UP) or Key.repeat?(Key::KB_LEFT)
          # 값 -1
          self.value -= 1
        end
      end
      
      # [^], [v] 버튼
      if Mouse.repeat?
        # [^]
        if isUpSelected
          return if @scrolling
          self.value -= 1
          Game.system.se_play(Config::DECISION_SE) if Mouse.trigger?
        # [v]
        elsif isDownSelected
          return if @scrolling
          self.value += 1
          Game.system.se_play(Config::DECISION_SE) if Mouse.trigger?
        end
      end
      
      # 마우스 휠
      if @focus == self.object_id # 포커스가 잡힐 때
        if Mouse.wheel != 0 and not Mouse.wheel.nil?
          self.value += Mouse.wheel
          Mouse.wheel = 0
        end
      end
      
      # 바 드래그
      if isSelected
        @scrolling = Mouse.press? if isBarSelected
      else
        @scrolling = false unless Mouse.press?
      end
      if Mouse.press?
        if @scrolling
          # 폼 드래그 비허용
          @parent.drag = false
          # 증가분 구한 뒤
          dx, dy = Mouse.ox - Mouse.x, Mouse.oy - Mouse.y
          Mouse.x += dx
          Mouse.y += dy
          # 벨류에 더함
          self.value += dy / @dh
          # 마우스 포지션이 [^] 나 [v] 을 넘어가면 돌아올 때까지 최소, 최대값 적용
          if Mouse.y < @realY + @@cache['VU'].height
            self.value = @min
          elsif Mouse.y > @realY + @@cache['VU'].height + @barHeight
            self.value = @max
          end
        end
      else
        # 폼 드래그 허용
        @parent.drag = true
      end
    end
    
    # [^]
    def isUpSelected
      if Mouse.x >= @realX and
        Mouse.x <= @realX + @@cache['VU'].width and
        Mouse.y >= @realY and
        Mouse.y <= @realY + @@cache['VU'].height
        return true
      else
        return false
      end
    end
    
    # [v]
    def isDownSelected
      if Mouse.x >= @realX and
        Mouse.x <= @realX + @@cache['VD'].width and
        Mouse.y >= @realY + @height - @@cache['VD'].height and
        Mouse.y <= @realY + @height
        return true
      else
        return false
      end
    end
    
    # 스크롤바
    def isBarSelected
      if Mouse.x >= @realX and
        Mouse.x <= @realX + @width and
        Mouse.y >= @barSprite.y + @realY - @y and
        Mouse.y < @barSprite.y + @realY - @y + @dh.to_i + @@cache['VBU'].height + @@cache['VBD'].height
        return true
      else
        return false
      end
    end
    
    # 리프레시
    def refresh
      baseRefresh
      barRefresh
      @barSprite.y = @y + @@cache['VU'].height + @value * @dh
      @barSprite.visible = !(@max == @min)
    end
    
    # 바 리프레시
    def barRefresh
      @barSprite.bitmap.clear
      # Up
      @barSprite.bitmap.blt(0, 0, @@cache['VBU'], Rect.new(0, 0, @@cache['VBU'].width, @@cache['VBU'].height))
      # Middle
      @barSprite.bitmap.stretch_blt(
      Rect.new(0, @@cache['VBU'].height, @@cache['VBM'].width, @dh.round),
      @@cache['VBM'],
      Rect.new(0, 0, @@cache['VBM'].width, @@cache['VBM'].height))
      # Down
      @barSprite.bitmap.blt(0, @dh.round + @@cache['VBD'].height, @@cache['VBD'], Rect.new(0, 0, @@cache['VBD'].width, @@cache['VBD'].height))
    end
    
    # 베이스 리프레시
    def baseRefresh
      @baseSprite.bitmap.clear
      # Up
      @baseSprite.bitmap.blt(0, 0, @@cache['VU'], Rect.new(0, 0, @@cache['VU'].width, @@cache['VU'].height))
      # Middle
      @baseSprite.bitmap.stretch_blt(
      Rect.new(0, @@cache['VU'].height, @@cache['VM'].width, @height - (@@cache['VD'].height + @@cache['VU'].height)),
      @@cache['VM'],
      Rect.new(0, 0, @@cache['VM'].width, @@cache['VM'].height))      
      # Down
      @baseSprite.bitmap.blt(0, @height - @@cache['VD'].height, @@cache['VD'], Rect.new(0, 0, @@cache['VD'].width, @@cache['VD'].height))
    end

    # 최대값
    def max; @max end
    def max=(value)
      return if @max == value
      @max = value
      @num = @max - @min + 1
      @dh = @barHeight / @num.to_f
      return if @barSprite.nil?
      refresh
    end
    
    # 최소값 (0 권장)
    def min; @min end
    def min=(value)
      return if @min == value
      @min = value
      @num = @max - @min + 1
      @dh = @barHeight / @num.to_f
      return if @barSprite.nil?
      refresh
    end
    
    # 현재값
    def value; @value end
    def value=(value)
      return if @value == value
      @value = [[@min, value].max, @max].min
      return if @barSprite.nil?
      refresh
    end
    
    # 표시
    def visible; @visible end
    def visible=(value)
      super
      @barSprite.visible = value
      @barSprite.visible = !(@max == @min) if value
    end
    
    # 포커스
    def focus; @focus end
    def focus=(value)
      @focus = value
    end
  end
end