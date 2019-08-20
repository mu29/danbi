# encoding: utf-8

class MUI
  class Console
    include Config
    def self.init
      viewport = Viewport.new(RECT_CHATBOX)
      viewport.z = 2000
      @backSprite = Sprite.new(viewport)
      @backSprite.bitmap = Bitmap.new(RECT_CHATBOX.width, RECT_CHATBOX.height)
      @backSprite.bitmap.fill_rect(RECT_CHATBOX.src_rect, Color.black(100))
      @sprite = Sprite.new(viewport)
      @sprite.z = 1
      @sprite.bitmap = Bitmap.new(RECT_CHATBOX.width, RECT_CHATBOX.height)
      @sprite.bitmap.font.name = FONT
      @sprite.bitmap.font.size = FONT_NORMAL_SIZE
      @message = []
    end
    
    def self.write(msg, color1 = Color.white, color2 = Color.black)
      @sprite.bitmap.clear
      x = 5
      y = 5
      w = @sprite.viewport.rect.width - x * 2
      h = @sprite.bitmap.font.size
      text = @sprite.bitmap.get_divided_text(w, msg)
      for t in text
        msg = Message.new
        msg.text = t
        msg.color1 = color1
        msg.color2 = color2
        @message.shift if @message.size > 5
        @message.push(msg)
      end
      for i in (@message.size - 6)...@message.size
        next if i < 0
        break if not @message[i]
        @sprite.bitmap.draw_outline_text(x, y + i * h, w, h, 
          @message[i].text, @message[i].color1, @message[i].color2)
      end
    end
  end
  
  class Message
    attr_accessor :text
    attr_accessor :color1
    attr_accessor :color2
  end
end