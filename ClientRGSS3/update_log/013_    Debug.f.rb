#────────────────────────────────────────────────────────────────────────────

# * Debug, ForeverZer0

#────────────────────────────────────────────────────────────────────────────



def setDebugMode

  text = ['게임 테스트', 'Now Playtesting']

  hdlg = []

  for i in 0...text.size

    hdlg.push(FindWindow.call('#32770', text[i].to_m))

    hdlg.delete(0)

  end

  $TEST = $DEBUG = GetParent.call(hdlg[0].nil? ? 0 : hdlg[0]) == FindWindow.call(0, (Game::Caption + " - RPG Maker XP").to_m)

  if $DEBUG || $TEST
    AllocConsole.call
    $stdout.reopen('CONOUT$')
    SetForegroundWindow.call(Game::hWnd)
    title = Game::Caption + " - " + Config::CONSOLE_TITLE

    SetConsoleTitle.call(title.to_m)
    SetWindowPos.call(GetConsoleWindow.call, 0, *Config::CONSOLE_RECT.to_a, 1)

  end

  undef setDebugMode

end; setDebugMode