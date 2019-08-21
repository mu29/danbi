# encoding: utf-8

#────────────────────────────────────────────────────────────────────────────
# * Game, jubin
#────────────────────────────────────────────────────────────────────────────

module Game
  
  module_function
  
  def getHwnd
    buffer = "\0" * 1024
    Win32API::GetPrivateProfileString.call('Game', 'Title', '', buffer, buffer.size, './Game.ini')
    hwnd = Win32API::FindWindow.call('RGSS Player', buffer)
    hwnd = Win32API::GetActiveWindow.call if hwnd == 0
    return hwnd
  end

  def getCaption
    length = Win32API::GetWindowTextLength.call(HWND)
    str = "\0" * (length)
    Win32API::GetWindowText.call(HWND, str, length + 1)
    return str.to_u
  end
  
  def getRect
    rect = [0, 0, 0, 0].pack('l4')
    Win32API::GetWindowRect.call(Game::HWND, rect)
    return rect.unpack('l4')
  end
  
  def getClientRect
    rect = [0, 0, 0, 0].pack('l4')
    Win32API::GetClientRect.call(Game::HWND, rect)
    return rect.unpack('l4')
  end
  
  def openDebugWindow
    if $DEBUG || $TEST
      Win32API::AllocConsole.call
      $stdout.reopen('CONOUT$')
      Win32API::SetForegroundWindow.call(Game::HWND)
      title = Game::CAPTION + " - " + Config::CONSOLE_TITLE
      Win32API::SetConsoleTitle.call(title.to_m)
      Win32API::SetWindowPos.call(Win32API::GetConsoleWindow.call, 0, *Config::CONSOLE_RECT.to_a, 1)
    end
    undef openDebugWindow
  end
  
  def set_debug_mode
    if Win32API::GetCommandLine.call =~ /Game.exe (.*)/
      $DEBUG = $TEST = if $1 == "debug"
        true
      else
        false
      end
    end
  end  

  # 핸들
  HWND = Game.getHwnd()
  # 게임 타이틀
  CAPTION = Game.getCaption()

  Game.set_debug_mode
  Game.openDebugWindow()
end