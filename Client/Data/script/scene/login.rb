# encoding: utf-8

#────────────────────────────────────────────────────────────────────────────
# ▶ Scene::Login
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com)
# Date      2014. 1. 18
#────────────────────────────────────────────────────────────────────────────
class Scene
  class Login
    def main
      @sprite = Sprite.new
      @sprite.bitmap = RPG::Cache.title("Title")
      Graphics.transition
      MUI::Form::Login.new
      loop do
        MUI.update
        Graphics.update
        update
        if $scene != self
          break
        end
      end
      MUI.getForm(MUI::Form::Login).dispose if MUI.include?(MUI::Form::Login)
      MUI.getForm(MUI::Form::Register).dispose if MUI.include?(MUI::Form::Register)
      Graphics.freeze    
      @sprite.bitmap.dispose
      @sprite.dispose
    end
    
    def update
      Socket.update
    end
  end
end