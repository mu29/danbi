# encoding: utf-8

#────────────────────────────────────────────────────────────────────────────
# ▶ FlashMessage
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com)
# Date      2011. 9. 29
# --------------------------------------------------------------------------
# Description
# 
#    플래시 메시지를 표시합니다. 페이드 인 / 아웃 기능이 있습니다.
#    스크립트 : 메시지("내용", Color.new())
#    색을 지정하지 않으면 디폴트 색 (검정색) 으로 출력됩니다.
#────────────────────────────────────────────────────────────────────────────
class FlashMessage
  attr_accessor :text
  
  def initialize
    @sprite = Sprite.new
    @sprite.bitmap = Bitmap.new(Graphics.getRect[0], 20)
    @sprite.x = 0
    @sprite.y = 100
    @sprite.z = 999999
    @sprite.opacity = 0
    @text = ""
    @fade_in = false
    @fade_out = false
    @wait_count = 40
  end
  
  def change_color(new_color)
    @sprite.bitmap.font.color = new_color
  end
  
  def refresh
    @sprite.bitmap.clear
    @sprite.bitmap.fill_rect(Rect.new(0,0,Graphics.getRect[0],20), Color.new(0, 0, 0, 100))
    @sprite.bitmap.draw_text(1, 3, Graphics.getRect[0], 12, @text, 1)
    @sprite.bitmap.draw_text(1, 4, Graphics.getRect[0], 12, @text, 1)
    @sprite.bitmap.draw_text(1, 5, Graphics.getRect[0], 12, @text, 1)
    @sprite.bitmap.draw_text(-1, 3, Graphics.getRect[0], 12, @text, 1)
    @sprite.bitmap.draw_text(-1, 4, Graphics.getRect[0], 12, @text, 1)
    @sprite.bitmap.draw_text(-1, 5, Graphics.getRect[0], 12, @text, 1)
    @sprite.bitmap.draw_text(0, 3, Graphics.getRect[0], 12, @text, 1)
    @sprite.bitmap.draw_text(0, 5, Graphics.getRect[0], 12, @text, 1)
    @sprite.bitmap.font.color = Color.new(255, 255, 255)
    @sprite.bitmap.draw_text(0, 4, Graphics.getRect[0], 12, @text, 1)
    @sprite.visible = true
    @fade_in = true
  end
  
  def update
    if @fade_in
      if @sprite.opacity < 255
        @sprite.opacity += 10
        return
      elsif @wait_count > 0
        @wait_count -= 1
        return
      else
        @fade_out = true
        @fade_in = false
      end
    end
    if @fade_out
      if @sprite.opacity > 0
        @sprite.opacity -= 10
        return
      else
        @wait_count = 40
        @fade_out = false
        @fade_in = false
        @text = ""
        @sprite.visible = false
      end
    end
  end
  
  def write(msg, new_color = Color.new(0, 0, 0))
    @text = msg
    change_color(new_color)
    refresh
  end
end