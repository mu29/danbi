# filename scene/login.rb
#────────────────────────────────────────────────────────────────────────────
# ▶ Scene_Login
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com)
# Date      2014. 1. 18
#────────────────────────────────────────────────────────────────────────────
class Scene_Login
  def main
    @sprite = Sprite.new
    @sprite.bitmap = RPG::Cache.title("Title")
    Graphics.transition
    MUI_Login.new
    loop do
      MUI.update
      Graphics.update
      update
      if $scene != self
        break
      end
    end
    MUI.getForm(MUI_Login).dispose if MUI.include?(MUI_Login)
    MUI.getForm(MUI_Register).dispose if MUI.include?(MUI_Register)
    Graphics.freeze    
    @sprite.bitmap.dispose
    @sprite.dispose
  end
  
  def update
    Socket.update
  end
end