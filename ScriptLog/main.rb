# filename main.rb
#────────────────────────────────────────────────────────────────────────────
# ▶ Main
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2014
# --------------------------------------------------------------------------
# Description
#
#    각 클래스의 정의가 끝난 후, 여기로부터 실제의 처리가 시작됩니다.
#────────────────────────────────────────────────────────────────────────────

begin
  Key.init
  MUI.init
  Game.init
  Game.load
  Network.call
  Socket.init
  Win32API::NoF1.call(1)
  Win32API::NoF12.call(1)
  Win32API::ShowCursor.call(0)
  Font.default_outline = false
  Font.default_name = Config::FONT[0]
  Font.default_size = Config::FONT_NORMAL_SIZE
  Graphics.frame_rate = 60
  $scene = Scene_Server.new
  Graphics.freeze
  while $scene != nil
    $scene.main
  end
  Graphics.transition(20)
rescue Errno::ENOENT
  filename = $!.message.sub("No such file or directory - ", "")
  print("파일 '#{filename}' 가 존재하지 않습니다.")
ensure
  Socket.close
end