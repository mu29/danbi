# encoding: utf-8

#────────────────────────────────────────────────────────────────────────────
# ▶ MUI::Form::SetWhisperNickname
# --------------------------------------------------------------------------
# Author    jubin-park
# Date      2017. 8. 7
# --------------------------------------------------------------------------
# Description
# 
#    채팅창에서 귓속말 상대의 닉네임을 정하는 폼 윈도우입니다.
#────────────────────────────────────────────────────────────────────────────

class MUI::Form
  class SetWhisperNickname < self
    
    @@disposed = true
    @@text = ""
    
    def initialize
      super(Mouse.x, Mouse.y, 170, 80)
      @@disposed = false
      
      @tb_name = MUI::TextBox.new(12, 8, 96, 28)
      @tb_name.helpText = "닉네임"
      if @@text != ""
        @tb_name.text = @@text
      end
      addControl(@tb_name)
      @btn_apply = MUI::Button.new(112, 8, 48, 28)
      @btn_apply.text = "적용"
      addControl(@btn_apply)
    end

    def refresh
      super
      setTitle("닉네임 설정")
    end
    
    def update
      super
      if @btn_apply.click
        @@text = @tb_name.text.force_encoding("UTF-8")
        if @@text != ""
          MUI::Console.write("귓속말 상대의 닉네임이 `" + @@text + "`로 설정됐습니다.")
        end
        self.dispose
      end
    end
      
    def textNickName=(text)
      @@text = text
    end
    
    def textNickName
      @@text
    end
    
    def dispose
      @@disposed = true
      super
    end
    
    def disposed?
      @@disposed
    end
  end
end