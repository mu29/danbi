# encoding: utf-8

class MUI
  class ChatBox
    include Config
    SWAP_SE = RPG::AudioFile.new("032-Switch01.ogg", 100, 100)
    
    @button = %w{일반 귓말 파티 길드 전체}
    @btn_type = 0
    
    def self.initButtons
      ft = Font.new
      ft.outline = false
      ft.name = Config::FONT[0]
      ft.size = Config::FONT_NORMAL_SIZE
      ft.color = Color.white
      ft.bold = false
      ft.italic = false
      
      src = RPG::Cache.hud("btn_chat_type.png")
      @btn_width = src.width / 2
      @btn_height = src.height
      
      @bmp_button = Bitmap.new(@btn_width * 2, @btn_height * @button.size)
      @bmp_button.font = ft
      @button.size.times { |i|
        @bmp_button.blt(0, @btn_height * i, src, src.rect)
        2.times { |x|
          @bmp_button.draw_text(x * @btn_width, i * @btn_height, @btn_width, @btn_height, @button[i], 1)
        }
      }
            
      @spr_button = Sprite.new
      @spr_button.z = 9999
      @spr_button.x = RECT_INPUT.x + 4
      @spr_button.y = RECT_INPUT.y + 4
      @spr_button.bitmap = @bmp_button
      @spr_button.src_rect = Rect.new(0, 0, @btn_width, @btn_height)
      
      # target icon
      @nicknameSprite = Sprite.new
      @nicknameSprite.bitmap = RPG::Cache.hud("target.png")
      @nicknameSprite.ox = @nicknameSprite.src_rect.width / 2
      @nicknameSprite.oy = @nicknameSprite.src_rect.height / 2
      @nicknameSprite.x = RECT_INPUT.x
      @nicknameSprite.y = RECT_INPUT.y
      @nicknameSprite.z = @spr_button.z + 1
      @nicknameSprite.visible = false
    end
          
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
      
      @textBitmap.draw_outline_text(55, 0, 
        RECT_INPUT.width, RECT_INPUT.height, @helpText)
      @textSprite.bitmap = @textBitmap
      
      initButtons()
      
      @muiFrm = MUI_SetWhisperNickname.new
      @muiFrm.dispose()
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
      # 닉네임 설정 아이콘
      if @nicknameSprite.isPointInRect?(Mouse.x, Mouse.y)
        @nicknameSprite.color = Color.red
        if Mouse.trigger?(0)
          if @muiFrm.disposed?
            @muiFrm = MUI_SetWhisperNickname.new
          else
            @muiFrm.x = Mouse.x
            @muiFrm.y = Mouse.y
          end
        end
      else
        @nicknameSprite.color = Color.white
      end
      # 채팅 타입 버튼
      if @spr_button.isPointInRect?(Mouse.x, Mouse.y)
        @spr_button.src_rect = Rect.new(@btn_width, @btn_type * @btn_height, @btn_width, @btn_height)
        if Mouse.trigger?(0)
          unless @nicknameSprite.isPointInRect?(Mouse.x, Mouse.y)
            @btn_type += 1
            @btn_type %= @button.size
            @nicknameSprite.visible = (@btn_type == 1)
            Game.system.se_play(SWAP_SE)
          end
        elsif Mouse.trigger?(1)
          @btn_type -= 1
          @btn_type %= @button.size
          @nicknameSprite.visible = (@btn_type == 1)
          Game.system.se_play(SWAP_SE)
        end
      else
        @spr_button.src_rect = Rect.new(0, @btn_type * @btn_height, @btn_width, @btn_height)
      end
      # 입력 부분
      if Key.trigger?(Key::KB_RETURN)
        if @focus
          if @text != ""
            case @btn_type
            # 일반
            when 0
              Socket.send({'header' => CTSHeader::CHAT_NORMAL, 'message' => @text})
            # 귓말
            when 1
              param = Hash.new
              param['header']  = CTSHeader::CHAT_WHISPER
              param['to']      = @muiFrm.textNickName
              param['message'] = @text
              Socket.send(param)
            # 파티
            when 2
              param = Hash.new
              param['header']  = CTSHeader::CHAT_PARTY
              param['message'] = @text
              Socket.send(param)
            # 길드
            when 3
              param = Hash.new
              param['header']  = CTSHeader::CHAT_GUILD
              param['message'] = @text
              Socket.send(param)
            # 전체
            when 4
              param = Hash.new
              param['header']  = CTSHeader::CHAT_ALL
              param['message'] = @text
              Socket.send(param)
              #Socket.send(Hash['header', CTSHeader::CHAT_BALLOON_START, 'no', Game.player.no])
            else
            end
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
        if Key.trigger?(Key::KB_TAB)
          if Key.press?(Key::KB_SHIFT)
            @btn_type -= 1
          else
            @btn_type += 1
          end
          @btn_type %= @button.size
          @spr_button.src_rect = Rect.new(0, @btn_type * @btn_height, @btn_width, @btn_height)
          @nicknameSprite.visible = (@btn_type == 1)
        end
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
        @textBitmap.draw_outline_text(55, 0,
          RECT_INPUT.width, RECT_INPUT.height, @text + "_")
        @textSprite.bitmap = @textBitmap
      elsif @helpText != "" and @helpText != nil
        @textBitmap.draw_outline_text(55, 0, 
          RECT_INPUT.width, RECT_INPUT.height, @helpText)
      end
    end
    
    def self.muiFrm
      @muiFrm
    end
    
  end
end