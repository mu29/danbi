# encoding: utf-8

#────────────────────────────────────────────────────────────────────────────
# * Kernel, jubin, 2015. 03. 15
#────────────────────────────────────────────────────────────────────────────

module Kernel
  
  module MB
    OK                = 0
    OKCANCEL          = 1
    ABORTRETRYIGNORE  = 2
    YESNOCANCEL       = 3
    YESNO             = 4
    RETRYCANCEL       = 5
    CANCELTRYCONTINUE = 6
    HELP              = 0x00004000
  
    ICONSTOP          = 16
    ICONQUESTION      = 32
    ICONEXCLAMATION   = 48
    ICONINFORMATION   = 64
  
    DEFBUTTON1        = 0x00000000
    DEFBUTTON2        = 0x00000100
    DEFBUTTON3        = 0x00000200
    DEFBUTTON4        = 0x00000300
    RIGHT             = 0x00080000
    RTLREADING        = 0x00100000
    TOPMOST           = 0x00040000
  
    IDOK              = 1
    IDCANCEL          = 2
    IDABORT           = 3
    IDRETRY           = 4
    IDIGNORE          = 5
    IDYES             = 6
    IDNO              = 7
    IDTRYAGAIN        = 10
    IDCONTINUE        = 11
  end
  
  alias :_puts_ :puts if !$@
  alias :_msgbox_p_ :msgbox_p if !$@
  
  def puts(*args)
    args.collect {|arg| _puts_(arg.inspect + "\n") }
  end
  
  def msgbox(*args)
    arg = String.new
    args.each{ |a| arg << (a.nil? ? "nil" : a.to_s) + "\n" }
    puts(*args)
    Win32API::ShowCursor.call(1)
    Win32API::MessageBox.call(GameWindow::HWND, arg.to_m, GameWindow::CAPTION, 0)
    Win32API::ShowCursor.call(0)
  end
  
  def msgbox_p(*args)
    puts(*args)
    Win32API::ShowCursor.call(1)
    _msgbox_p_(*args)
    Win32API::ShowCursor.call(0)
  end
  
  # Custom msgbox
  def msgbox_c(arg, type=0, caption=GameWindow::CAPTION)
    puts(arg)
    Win32API::ShowCursor.call(1)
    id = Win32API::MessageBox.call(GameWindow::HWND, arg.to_s.to_m, caption.to_s.to_m, type)
    Win32API::ShowCursor.call(0)
    return id
  end
  
  def print(*args)
    msgbox(*args)
  end
  
  def p(*args)
    msgbox_p(*args)
  end
end