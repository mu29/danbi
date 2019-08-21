# encoding: utf-8

#────────────────────────────────────────────────────────────────────────────
# * GameWindow, jubin
#────────────────────────────────────────────────────────────────────────────

module GameWindow
  
  module_function
  
  def getHwnd
    buffer = "\0" * 1024
    Win32API::GetPrivateProfileString.call('Game', 'Title', '', buffer, buffer.size, './Game.ini')
    hwnd = Win32API::FindWindow.call('RGSS Player', buffer)
    hwnd = Win32API::GetActiveWindow.call if hwnd == 0
    return hwnd
  end

  def getCaption
    length = Win32API::GetWindowTextLength.call(GameWindow::HWND)
    str = "\0" * (length)
    Win32API::GetWindowText.call(GameWindow::HWND, str, length + 1)
    return str.to_u
  end
  
  def getRect
    rect = [0, 0, 0, 0].pack('l4')
    Win32API::GetWindowRect.call(GameWindow::HWND, rect)
    return rect.unpack('l4')
  end
  
  def getClientRect
    rect = [0, 0, 0, 0].pack('l4')
    Win32API::GetClientRect.call(GameWindow::HWND, rect)
    return rect.unpack('l4')
  end
  
  def openDebugWindow
    if $DEBUG || $TEST
      Win32API::AllocConsole.call
      $stdout.reopen('CONOUT$')
      Win32API::SetForegroundWindow.call(GameWindow::HWND)
      title = GameWindow::CAPTION + " - " + Config::CONSOLE_TITLE
      Win32API::SetConsoleTitle.call(title.to_m)
      Win32API::SetWindowPos.call(Win32API::GetConsoleWindow.call, 0, *Config::CONSOLE_RECT.to_a, 1)
    end
    undef openDebugWindow
  end
  
  def set_debug_mode
    $DEBUG = $TEST = if Win32API::GetCommandLine.call =~ /(.*) debug/
      true
    else
      false
    end
  end  

  @@state_active = true

  def set_focus_state
    @@state_active = (Win32API::GetForegroundWindow.call == GameWindow::HWND)
  end

  def is_active?
    return @@state_active
  end

  # 핸들
  HWND = GameWindow.getHwnd
  # 게임 타이틀
  CAPTION = GameWindow.getCaption
  # 디버그 모드 설정
  GameWindow.set_debug_mode
  # 디버그 콘솔
  GameWindow.openDebugWindow
end