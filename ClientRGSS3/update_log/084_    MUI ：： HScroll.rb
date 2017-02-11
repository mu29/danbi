#────────────────────────────────────────────────────────────────────────────

# ▶ MUI::HScroll

# --------------------------------------------------------------------------

# Author    뮤 (mu29gl@gmail.com), jubin

# Date      2015. 02. 15

# --------------------------------------------------------------------------

# Description

# 

#    수평 스크롤바 컨트롤을 담당하는 클래스입니다.

#    바 드래그, 마우스 휠, 버튼 등을 사용할 수 있습니다.

#────────────────────────────────────────────────────────────────────────────

class MUI

  class HScroll < Control

    def initialize(x, y, w, h)

      super(x, y, w, h)

      loadCache(@style = "White")

      @barWidth = @width - (@@cache['VL'].width + @@cache['VR'].width + @@cache['VBL'].width + @@cache['VBR'].width)

      @max = 9

      @min = 0

      @num = @max - @min + 1

      @dw = @barWidth / @num.to_f

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

      # Base Horizontal

      @@cache['VL'] = RPG::Cache.hScroll(style + "/" + "VL")

      @@cache['VM'] = RPG::Cache.hScroll(style + "/" + "VM")

      @@cache['VR'] = RPG::Cache.hScroll(style + "/" + "VR")

      # Bar

      @@cache['VBL'] = RPG::Cache.hScroll(style + "/" + "VBL")

      @@cache['VBM'] = RPG::Cache.hScroll(style + "/" + "VBM")

      @@cache['VBR'] = RPG::Cache.hScroll(style + "/" + "VBR")

      @barWidth = @width - (@@cache['VL'].width + @@cache['VR'].width + @@cache['VBL'].width + @@cache['VBR'].width)

      @dw = @barWidth / @num.to_f

    end



    def setParent(form)

      @parent = form

      @baseSprite = Sprite.new(form.getViewport)

      @baseSprite.bitmap = Bitmap.new(@width, @height)

      @barSprite = Sprite.new(form.getViewport)

      @barSprite.bitmap = Bitmap.new(@width, @height)

      @baseSprite.x = @x

      @baseSprite.y = @y

      @barSprite.x = @x + @@cache['VL'].width

      @barSprite.y = @y

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

        if @focus and isSelected and not isBarSelected and not isLeftSelected and not isRightSelected

          self.value = (Mouse.x - @realX - @@cache['VL'].width) / @dw

          Game.system.se_play(Config::BUZZER_SE)

        end

      end

      

      # 키보드로 조작

      if @focus == self.object_id

        # 아래, 오른쪽 키를 눌렀을 때

        if Key.repeat?(KEY_DOWN) or Key.repeat?(KEY_RIGHT)

          # 값 +1

          self.value += 1

        # 위, 왼쪽 키를 눌렀을 때

        elsif Key.repeat?(KEY_UP) or Key.repeat?(KEY_LEFT)

          # 값 -1

          self.value -= 1

        end

      end

      

      # [<], [>] 버튼

      if Mouse.repeat?

        # [<]

        if isLeftSelected

          return if @scrolling

          self.value -= 1

          Game.system.se_play(Config::DECISION_SE) if Mouse.trigger?

        # [>]

        elsif isRightSelected

          return if @scrolling

          self.value += 1

          Game.system.se_play(Config::DECISION_SE) if Mouse.trigger?

        end

      end

      

      # 마우스 휠

      if @focus == self.object_id # 포커스가 잡힐 때

        if !Mouse.wheel.nil? and Mouse.wheel != 0 

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

          self.value += dx / @dw

          # 마우스 포지션이 [<] 나 [>] 을 넘어가면 돌아올 때까지 최소, 최대값 적용

          if Mouse.x <= @realX + @@cache['VL'].width

            self.value = @min

          elsif Mouse.x > @realX + @@cache['VL'].width + @barWidth

            self.value = @max

          end

        end

      else

        # 폼 드래그 허용

        @parent.drag = true

      end

    end

    

    # [<]

    def isLeftSelected

      if Mouse.x >= @realX and

        Mouse.x <= @realX + @@cache['VL'].width and

        Mouse.y >= @realY and

        Mouse.y <= @realY + @@cache['VL'].height

        return true

      else

        return false

      end

    end

    

    # [>]

    def isRightSelected

      if Mouse.x >= @realX + @width - @@cache['VR'].width and

        Mouse.x <= @realX + @width and

        Mouse.y >= @realY and

        Mouse.y <= @realY + @@cache['VR'].height

        return true

      else

        return false

      end

    end

    

    # 스크롤바

    def isBarSelected

      if Mouse.x >= @barSprite.x + @realX - @x and

        Mouse.x <= @barSprite.x + @realX - @x + @dw.to_i + @@cache['VBL'].width + @@cache['VBR'].width and

        Mouse.y >= @realY and

        Mouse.y < @realY + @height

        return true

      else

        return false

      end

    end

    

    # 리프레시

    def refresh

      baseRefresh

      barRefresh

      @barSprite.x = @x + @@cache['VL'].width + @value * @dw

      @barSprite.visible = !(@max == @min)

    end

    

    # 바 리프레시

    def barRefresh

      @barSprite.bitmap.clear

      # Up

      @barSprite.bitmap.blt(0, 0, @@cache['VBL'], Rect.new(0, 0, @@cache['VBL'].width, @@cache['VBL'].height))

      # Middle

      @barSprite.bitmap.stretch_blt(

      Rect.new(@@cache['VBL'].width, 0, @dw.round, @@cache['VBM'].height),

      @@cache['VBM'],

      Rect.new(0, 0, @@cache['VBM'].width, @@cache['VBM'].height))

      # Down

      @barSprite.bitmap.blt(@dw.round + @@cache['VBR'].width, 0, @@cache['VBR'], Rect.new(0, 0, @@cache['VBR'].width, @@cache['VBR'].height))

    end

    

    # 베이스 리프레시

    def baseRefresh

      @baseSprite.bitmap.clear

      # Up

      @baseSprite.bitmap.blt(0, 0, @@cache['VL'], Rect.new(0, 0, @@cache['VL'].width, @@cache['VL'].height))

      # Middle

      @baseSprite.bitmap.stretch_blt(

      Rect.new(@@cache['VL'].width, 0, @width - (@@cache['VL'].width + @@cache['VR'].width), @@cache['VM'].height),

      @@cache['VM'],

      Rect.new(0, 0, @@cache['VM'].width, @@cache['VM'].height))

      # Down

      @baseSprite.bitmap.blt(@width - @@cache['VR'].height, 0, @@cache['VR'], Rect.new(0, 0, @@cache['VR'].width, @@cache['VR'].height))

    end

    

    # 최대값

    def max; @max end

    def max=(value)

      return if @max == value

      @max = value

      @num = @max - @min + 1

      @dw = @barWidth / @num.to_f

      return if @barSprite.nil?

      refresh

    end

    

    # 최소값 (0 권장)

    def min; @min end

    def min=(value)

      return if @min == value

      @min = value

      @num = @max - @min + 1

      @dw = @barWidth / @num.to_f

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