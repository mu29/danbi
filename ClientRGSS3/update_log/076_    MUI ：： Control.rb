#────────────────────────────────────────────────────────────────────────────

# ▶ MUI::Control

# --------------------------------------------------------------------------

# Author    뮤 (mu29gl@gmail.com), jubin

# Date      2014

# --------------------------------------------------------------------------

# Description

# 

#    컨트롤을 담당하는 클래스입니다.

#────────────────────────────────────────────────────────────────────────────

class MUI

  class Control

    def initialize(x, y, w, h)

      @realX = x

      @realY = y

      @x = x

      @y = y

      @width = w

      @height = h

      @enable = true

      @visible = true

      @opacity = 255

      @toolTip = ""

    end

    

    def setParent(form)

      @parent = form

      @baseSprite = Sprite.new(form.getViewport)

      @baseSprite.bitmap = Bitmap.new(@width, @height)

      @baseSprite.x = @x

      @baseSprite.y = @y

      @realX = @x + form.getViewport.rect.x
      @realY = @y + form.getViewport.rect.y

      refresh

    end


    def setTitleParent(form)
      @parent = form
      @baseSprite = Sprite.new(form.getTitleViewport)
      @baseSprite.bitmap = Bitmap.new(@width, @height)

      @baseSprite.x = @x

      @baseSprite.y = @y
      @realX = @x + form.getTitleViewport.rect.x
      @realY = @y + form.getTitleViewport.rect.y

      refresh
    end



    # 실제 x

    def realX; @realX end

    def realX=(value)

      @realX = value

    end

    

    # 실제 y

    def realY; @realY end

    def realY=(value)

      @realY = value

    end



    # x

    def x; @x end

    def x=(value)

      @x = value

      @baseSprite.x = @x

      @realX = @parent.getViewport.rect.x + @x

    end

    

    # y

    def y; @y end

    def y=(value)

      @y = value

      @baseSprite.y = @y

      @realY = @parent.getViewport.rect.y + @y

    end



    # 너비

    def width; @width end

    def width=(value)

      return if @width == value or value <= 0

      @width = value

      return if @baseSprite.nil?

      @baseSprite.bitmap.dispose

      @baseSprite.bitmap = Bitmap.new(@width, @height)

      refresh

    end



    # 높이

    def height; @height end

    def height=(value)

      return if @height == value or value <= 0

      @height = value

      return if @baseSprite.nil?

      @baseSprite.bitmap.dispose

      @baseSprite.bitmap = Bitmap.new(@width, @height)

      refresh

    end

    

    # 활성화

    def enable; @enable end

    def enable=(value)

      return if @enable == value

      return unless value.is_a?(TrueClass) or value.is_a?(FalseClass)

      @enable = value

      return if @baseSprite.nil?

      if @enable

        @baseSprite.tone.set(0, 0, 0) if @baseSprite.tone != Tone.new(0, 0, 0)

      else

        @baseSprite.tone.set(-20, -20, -20, 100) if @baseSprite.tone != Tone.new(-20, -20, -20, 100)

      end

    end



    # 표시

    def visible; @visible end

    def visible=(value)

      return if @visible == value

      return unless value.is_a?(TrueClass) or value.is_a?(FalseClass)

      @visible = value

      return if @baseSprite.nil?

      @baseSprite.visible = value

    end

    

    # 투명도

    def opacity; @opacity end

    def opacity=(value)

      return if @opacity == value

      return unless value.between?(0, 255)

      @opacity = value

      return if @baseSprite.nil?

      @baseSprite.opacity = value

      refresh

    end

    

    # 텍스트 라인 수 리턴

    def line(width, str)

      return if @baseSprite.nil?

      return @baseSprite.bitmap.line(width, str)

    end

    

    def toolTip; @toolTip end

    def toolTip=(value)

      return if @toolTip == value

      return if @baseSprite.nil?

      @toolTip = value

    end

    

    def baseSprite; @baseSprite end 

    

    # 컨트롤을 한 번 누를 때

    def click(id = 0)

      id = 0 if not id.between?(0,2)

      if isSelected && Mouse.trigger?(id) && @visible

        Game.system.se_play(Config::DECISION_SE)

        return true

      else

        return false

      end

    end

    

    # 컨트롤을 꾹 누를 때

    def press(id = 0)

      id = 0 if not id.between?(0,2)

      if isSelected && Mouse.press?(id) && @visible

        return true

      else

        return false

      end

    end

    

    # 컨트롤을 꾹 누를 때

    def repeat(id)

      return if not @enable or not @visible

    end

    

    # 마우스가 컨트롤의 범위에 들어올 때

    def isMouseOver

      x, y = Mouse.x, Mouse.y

      return false if (not x or not y)

      if @realX <= x && @realX + @width > x && @realY <= y && @realY + @height > y

        return true

      else

        return false

      end

    end

    

    # 컨트롤에 마우스가 올려질 때

    def isSelected

      if isMouseOver && MUI.getFocus == @parent

        viewport1 = @parent.getViewport.rect

        viewport2 = @parent.getTitleViewport.rect

        # 베이스

        ((x >= viewport1.x and x <= viewport1.x + viewport1.width and

          y >= viewport1.y and y <= viewport1.y + viewport1.height) or

        # 타이틀

         (x >= viewport2.x and x <= viewport2.x + viewport2.width and

          y >= viewport2.y and y <= viewport2.y + viewport2.height))

        return true

      end

      return false

    end

    

    # 업데이트

    def update

      return if not @enable or not @visible

      return if @baseSprite.nil?

    end

    

    # 삭제

    def dispose

      if not @baseSprite.nil? and @baseSprite.is_a?(Sprite)

        self.instance_variables.each do |v|

          if instance_variable_get(v).is_a?(Sprite)

            instance_variable_get(v).dispose

            instance_variable_set(v, nil)

          end

        end

      end

    end



    # Recter

    def realTimeEdit(form)

      if $DEBUG

        if Key.press?(KEY_CTRL)

          form.drag = false

          if Mouse.trigger?

            self.x = Mouse.x - form.x

            self.y = Mouse.y - form.y - form.getTitleViewport.rect.height

            puts "#{self.x}, #{self.y}, #{self.width}, #{self.height}"

          end

          if Key.trigger?(KEY_C)

            File.setClipboard(", ", self.x, self.y, self.width, self.height)

          end

        elsif Key.press?(KEY_SHIFT)

          form.drag = false

          if Mouse.trigger?

            x = Mouse.x - form.x - @x

            y = Mouse.y - form.y - form.getTitleViewport.rect.height - @y

            self.width  = (x <= 0 ? 1 : x)

            self.height = (y <= 0 ? 1 : y)

          end

        else

          form.drag = true

        end

      end

    end

  end

end