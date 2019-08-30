# encoding: utf-8

#────────────────────────────────────────────────────────────────────────────
# ▶ Scene::Logo
# --------------------------------------------------------------------------
# Author    RedPudding
# Date      2010. 1. 17
# --------------------------------------------------------------------------
# Description
# 
#    서버 접속 후 로고를 표시합니다. (시간 좀 늘렸습니다^^.)
#────────────────────────────────────────────────────────────────────────────
class Scene
  class Logo
    LOGOS =
    [
      ["unis_logo", ""],
      #["게임 로고 이름", "효과음 이름"],
    ]
    
    def main
      @logo_index = 0
      @wait_count = 240
      @sprite = Sprite.new
      @sprite.opacity = 0
      Graphics.transition
      loop do
        MUI.update
        Graphics.update
        update
        if $scene != self
          break
        end
      end
      Graphics.freeze
      @sprite.bitmap.dispose
      @sprite.dispose
    end
    
    def update
      @sprite.bitmap = RPG::Cache.picture(LOGOS[@logo_index][0])
      if @wait_count > 0
        if @wait_count == 240
          se = LOGOS[@logo_index][1]
          if se != ""
            Audio.se_play("Audio/SE/" + se)
          end
        elsif @wait_count > 180
          @sprite.opacity += 255 / 50
        elsif @wait_count > 60
          @sprite.opacity = 255
        else
          @sprite.opacity -= 255 / 50
        end
        @wait_count -= 1
        return
      end
      @logo_index += 1
      @wait_count = 240
      if @logo_index >= LOGOS.size
        $scene = Scene::Server.new
      end
    end
  end
end