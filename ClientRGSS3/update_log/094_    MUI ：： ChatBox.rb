class MUI

  class ChatBox

    include Config

    def self.init

      @helpText = "대화하시려면 Enter키를 눌러주세요."

      @text = ""

      @ime = IME.new

      @viewport = Viewport.new(*RECT_INPUT.to_a)

      @viewport.z = 2000

      @baseSprite = Sprite.new(@viewport)

      @baseSprite.bitmap = Bitmap.new(RECT_INPUT.width, RECT_INPUT.height)

      @baseSprite.bitmap.fill_rect(0, 0, RECT_INPUT.width, RECT_INPUT.height, Color.black(128))

      @textSprite = Sprite.new(@viewport)

      @textSprite.y = 1

      @textSprite.z = 1

      @textBitmap = Bitmap.new(RECT_INPUT.width, RECT_INPUT.height)

      @focus = false

    end

    

    def self.focus; @focus end

    def self.focus=(value)

      return if @focus == value

      return unless value.is_a?(TrueClass) or value.is_a?(FalseClass)

      @focus = value

      return if @textBitmap.nil?

      refresh

    end

    

    def self.setFocus

      self.focus = true

      @ime.choice = false

      @ime.focus = true

    end

    

    def self.loseFocus

      self.focus = false

      @ime.choice = true

      @ime.focus = false

    end

    

    def self.update

      if Key.trigger?(KEY_RETURN)

        if @focus

          if @text != ""

            Socket.send({'header' => CTSHeader::CHAT, 'message' => @text})

            @text = ""

            @ime.clear

          else

            loseFocus

          end

          textRefresh

        else

          setFocus

        end

      end

      if @focus

        @ime.update

        textRefresh if @text != @ime.getText

      end

    end

        

    def self.refresh

      @textSprite.bitmap = @textBitmap

      textRefresh

    end

    

    def self.textRefresh

      @text = @ime.getText

      @textBitmap.clear

      if @focus

        @textBitmap.draw_outline_text(5, 0, RECT_INPUT.width, RECT_INPUT.height, @text + "_")

        @textSprite.bitmap = @textBitmap

      elsif @helpText != "" and @helpText != nil

        @textBitmap.draw_outline_text(5, 0, 

        RECT_INPUT.width, RECT_INPUT.height, @helpText)

      end

    end

  end

end