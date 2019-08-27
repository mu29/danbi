# encoding: utf-8

#────────────────────────────────────────────────────────────────────────────
# * GameWindow, jubin
#────────────────────────────────────────────────────────────────────────────

module GameWindow
  
  module_function
  
  def init
    @@state_active = true
    # 핸들
    const_set(:HWND, get_hwnd)
    # 게임 타이틀
    const_set(:CAPTION, get_caption)
    # 디버그 상태 설정
    set_debug_state
    # 디버그 콘솔
    open_debug_window
    # F1 금지
    Win32API::NoF1.call(1)
    # F12 금지
    Win32API::NoF12.call(1)
    # 윈도우 커서 숨기기
    Win32API::ShowCursor.call(0)
    # 비활성화 방지
    Win32API::StarInputStart.call(GameWindow::HWND)
    # 기존 ALT + ENTER 금지
    Win32API::RegisterHotKey.call(GameWindow::HWND, 0, Graphics::MOD_ALT, Graphics::VK_RETURN)
  end

  def get_hwnd
    buffer = "\0" * 1024
    Win32API::GetPrivateProfileString.call('Game', 'Title', '', buffer, buffer.size, './Game.ini')
    hwnd = Win32API::FindWindow.call('RGSS Player', buffer)
    hwnd = Win32API::GetActiveWindow.call if hwnd == 0
    return hwnd
  end

  def get_caption
    length = Win32API::GetWindowTextLength.call(GameWindow::HWND)
    str = "\0" * (length)
    Win32API::GetWindowText.call(GameWindow::HWND, str, length + 1)
    return str.to_u
  end
  
  def get_window_rect
    rect = [0, 0, 0, 0].pack('l4')
    Win32API::GetWindowRect.call(GameWindow::HWND, rect)
    return rect.unpack('l4')
  end
  
  def get_client_rect
    rect = [0, 0, 0, 0].pack('l4')
    Win32API::GetClientRect.call(GameWindow::HWND, rect)
    return rect.unpack('l4')
  end
  
  def set_debug_state
    $DEBUG = $TEST = (Win32API::GetCommandLine.call =~ /(.*) debug/ ? true : false)
  end

  def open_debug_window
    if $DEBUG || $TEST
      Win32API::AllocConsole.call
      $stdout.reopen('CONOUT$')
      Win32API::SetForegroundWindow.call(GameWindow::HWND)
      title = GameWindow::CAPTION + " - " + Config::CONSOLE_TITLE
      Win32API::SetConsoleTitle.call(title.to_m)
      Win32API::SetWindowPos.call(Win32API::GetConsoleWindow.call, 0, *Config::CONSOLE_RECT.to_a, 1)
    end
    undef open_debug_window
  end

  def set_focus_state
    @@state_active = (Win32API::GetForegroundWindow.call == GameWindow::HWND)
  end

  def is_active?
    return @@state_active ? true : false
  end
end