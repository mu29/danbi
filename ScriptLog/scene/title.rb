# filename scene/title.rb
#────────────────────────────────────────────────────────────────────────────
# ▶ Scene_Title
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com)
# Date      2015. 2
#────────────────────────────────────────────────────────────────────────────
class Scene_Title
  def main
    $data_tilesets      = load_data("Data/Tilesets.rxdata")
    @sprite = Sprite.new
    @sprite.bitmap = RPG::Cache.title("001-Title01")
    # 타이틀 BGM 를 연주
    #$game_system.bgm_play($data_system.title_bgm)
    Audio.me_stop
    Audio.bgs_stop
    Graphics.transition
    loop do
      Graphics.update
      MUI.update
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
    if Input.trigger?(Input::C)
      Audio.bgm_stop
      Graphics.frame_count = 0
      Game.map.setup(2)
      # 플레이어를 초기 위치에 이동
      Game.player.moveto(9, 7)
      # 플레이어를 리프레쉬
      Game.player.refresh
      # 맵으로 설정되어 있는 BGM 와 BGS 의 자동 변환을 실행
      Game.map.autoplay
      # 맵을 갱신 (병렬 이벤트 실행)
      Game.map.update
      # 맵 화면으로 전환해
      $scene = Scene_Map.new
    end
  end
end