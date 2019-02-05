# filename mui/picture_box.rb
#────────────────────────────────────────────────────────────────────────────
# ▶ MUI::PictureBox
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2014
# --------------------------------------------------------------------------
# Description
# 
#    픽쳐박스 컨트롤을 담당하는 클래스입니다.
#────────────────────────────────────────────────────────────────────────────
class MUI
  class PictureBox < Control
    def picture; @picture; end
      
    def initialize(x, y, w, h)
      super(x, y, w, h)
    end
    
    def picture=(path)
      return if @picture == path
      clear
      begin
        if path.is_a?(String)
          @picture = Bitmap.new(path)
        elsif path.is_a?(Bitmap)
          @picture = path
        end
      rescue
        @picture = Bitmap.new(1, 1)
      end
      return if @baseSprite.nil?
      refresh
    end
    
    def clear
      return if @baseSprite.nil?
      @picture = nil
      @baseSprite.bitmap.clear
    end
    
    # 자동 크기
    def autoSize
      return unless @picture.is_a?(Bitmap)
      self.width = @picture.width
      self.height = @picture.height
    end
    
    def refresh
      return if @baseSprite.nil?
      @baseSprite.bitmap.clear
      @baseSprite.visible = @visible
      @baseSprite.opacity = @opacity
      return if @picture.nil?
      @baseSprite.bitmap.blt(0, 0, @picture, Rect.new(0, 0, @width, @height))
    end
    
    def update
      super
    end
    
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
  end
end