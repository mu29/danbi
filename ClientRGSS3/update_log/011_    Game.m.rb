#────────────────────────────────────────────────────────────────────────────

# * Game, jubin

#────────────────────────────────────────────────────────────────────────────



module Game

  def self.hWnd

    buffer = "\0" * (2 << 9)

    GetPrivateProfileString.call('Game', 'Title', '', buffer, buffer.size, './Game.ini')

    hwnd = FindWindow.call('RGSS Player', buffer)

    hwnd = GetActiveWindow.call if hwnd == 0

    return hwnd

  end



  def self.Caption

    length = GetWindowTextLength.call(hWnd)

    str = "\0" * (length)

    GetWindowText.call(hWnd, str, length + 1)

    return str.to_u

  end

  

  def self.getRect

    rect = [0, 0, 0, 0].pack('l4')

    GetWindowRect.call(Game::hWnd, rect)

    return rect.unpack('l4')

  end

  

  # 핸들

  hWnd = Game.hWnd()

  # 게임 타이틀

  Caption = Game.Caption()

end