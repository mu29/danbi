=begin

  단비, RPGXP 전용 온라인 게임 엔진
  
  Client Version:
    RGSS3
  
  Wiki:
    github.com/mu29/danbi/wiki
  
  Dev Team:
    tinystar.co.kr
  
=end

#────────────────────────────────────────────────────────────────────────────
# * Config
#────────────────────────────────────────────────────────────────────────────

module Config
  
  # 서버 리스트를 작성해 보세요.
  SERVER = [
    ["127.0.0.1", 50000, "뮤", "1.png"],
    ["58.127.170.60", 50000, "다람쥐", "2.png"],
    ["172.30.1.3", 50000, "서버 3", "3.png"],
    ["172.30.1.4", 50000, "서버 4", "4.png"]
  ]
  
  # 게임 해상도를 설정하세요. (너비, 높이 순)
  WINDOW_WIDTH, WINDOW_HEIGHT = 800, 600
  
  # "Alt + Enter" 키 사용의 허용 여부를 설정하세요.
  USE_ALT_ENTER = true

  # 폰트를 설정하세요.
  FONT = ["나눔고딕", "나눔고딕 ExtraBold"]
  FONT_SMALL_SIZE = 13
  FONT_NORMAL_SIZE = 14
  
  # 마우스 커서의 파일명을 입력하세요.
  # 파일은 Graphics/Icons 폴더에서 불러옵니다.
  MOUSE = "cursor.png"
  
  # 결정 SE(사운드 이펙트)를 설정하세요.
  DECISION_SE = RPG::AudioFile.new("002-System02", 100, 100)#032-Switch01
  # 취소 SE를 설정하세요.
  BUZZER_SE   = RPG::AudioFile.new("004-System04", 100, 100)#021-Dive01
  
  # 디버그 콘솔의 제목과 위치를 설정하세요.
  CONSOLE_TITLE = "Debug"
  CONSOLE_RECT = Rect.new(128, 128, 256, 480)
  
  # 옵션값 저장 경로를 설정하세요.
  OPTION_PATH = "./User.ini"
  # 옵션 키 이름을 입력하세요.
  OPTION_KEY = "Option"
  
  # 외부 라이브러리 경로
  DLL_PATH = './Library/'
  
  # 부활 위치
  ReBirth_ID = 4
  ReBirth_X = 9
  ReBirth_Y = 7
end

module Config # HUD 설정
  
  # 파일명
  FILE_HUD = "HUD.png"
  FILE_HP = "HPBAR.png"
  FILE_MP = "MPBAR.png"
  FILE_EXP = "EXPBAR.png"
  FILE_B_HP = "hp_balloon.png"
  FILE_B_MP = "mp_balloon.png"
  
  # 게이지바 위치
  HP_X = 70; HP_Y = 557
  MP_X = 70; MP_Y = 574
  EXP_X = 0; EXP_Y = 593
  # 왼쪽, 오른쪽 게이지바 굵기
  HP_BORDER = [1, 1]
  MP_BORDER = [1, 1]
  EXP_BORDER = [1, 1]
  # 게이지바 속도
  BAR_SPEED = 5
  
  # 레벨 텍스트 위치
  LV_TEXT_X = 12
  LV_TEXT_Y = 560
  # HP 텍스트 위치
  HP_TEXT_X = 70
  HP_TEXT_Y = 553
  # MP 텍스트 위치
  MP_TEXT_X = 70
  MP_TEXT_Y = 570
  # EXP 텍스트 위치
  EXP_TEXT_X = 0
  EXP_TEXT_Y = 588
  
  # 메뉴 아이콘 위치, 간격
  MENU_ICON_X = 560
  MENU_ICON_Y = 558
  MENU_ICON_GAP = 40

  # 단축키 위치, 크기
  SHORTCUT_RECT = []
  COOLTIME_RECT = []
  for n in 0...10
    SHORTCUT_RECT[n] = Rect.new(214 + n * 30, 558, 24, 24)
    COOLTIME_RECT[n] = Rect.new(214 + n * 30, 557, 24, 25)
  end
end

module Config # 채팅창 설정
  # 채팅창 RECT 설정 (x, y, width, height)
  RECT_CHATBOX = Rect.new(490, 425, 300, 94)
  RECT_INPUT = Rect.new(490, 520, 300, 20)
  # 채팅창 그래픽
  FILE_CHAT = "chatbox.png"
end

module Config # 스위치
  # 맵 파일 추출
  EXTRACT_MAP = false
end



#────────────────────────────────────────────────────────────────────────────
# * Win32API
#────────────────────────────────────────────────────────────────────────────

class Win32API
  NoF1                      = new(Config::DLL_PATH + 'NoInput', 'NoF1', 'l', 'v')
  NoF12                     = new(Config::DLL_PATH + 'NoInput', 'NoF12', 'l', 'v')
  NoAltEnter                = new(Config::DLL_PATH + 'NoInput', 'NoAltEnter', 'l', 'v')
  DrawMapsBitmap            = new(Config::DLL_PATH + 'Tilemap', 'DrawMapsBitmap', 'pppp', 'i')
  DrawMapsBitmap2           = new(Config::DLL_PATH + 'Tilemap', 'DrawMapsBitmap2', 'pppp', 'i')
  UpdateAutotiles           = new(Config::DLL_PATH + 'Tilemap', 'UpdateAutotiles', 'pppp', 'i')
  InitEmptyTile             = new(Config::DLL_PATH + 'Tilemap', 'InitEmptyTile', 'l', 'i')
  Wheel                     = new(Config::DLL_PATH + 'Wheel', 'intercept', 'v', 'l')
  FindFirstFile             = new(Config::DLL_PATH + 'RTP', 'FFF', 'p', 'p')
  RtlMoveMemory             = new('kernel32', 'RtlMoveMemory', 'ppl', '')
  MultiByteToWideChar       = new('kernel32', 'MultiByteToWideChar', 'llplpl', 'l')
  WideCharToMultiByte       = new('kernel32', 'WideCharToMultiByte', 'llplplpp', 'l')
  GetPrivateProfileString   = new('kernel32', 'GetPrivateProfileString', 'pppplp', 'l')
  WritePrivateProfileString = new('kernel32', 'WritePrivateProfileString', 'pppp', 'l')
  DeleteFile                = new('kernel32', 'DeleteFile', 'p', 'l')
  GetActiveWindow           = new('user32', 'GetActiveWindow', 'v', 'l')
  GetForegroundWindow       = new('user32', 'GetForegroundWindow', 'v', 'l')
  GetWindowText             = new('user32', 'GetWindowText', 'lpl', 'l')
  GetWindowTextLength       = new('user32', 'GetWindowTextLength', 'l', 'l')
  MessageBox                = new('user32', 'MessageBox', 'lppl', 'l')
  SendMessage               = new('user32', 'SendMessageA', 'llll', 'l')
  LoadImageA                = new('user32', 'LoadImageA', 'lpllll', 'l')
  LoadImageW                = new('user32', 'LoadImageW', 'lpllll', 'l')
  FlashWindow               = new('user32', 'FlashWindow', 'll', 'l')
  FindWindow                = new('user32', 'FindWindow', 'pp', 'l')
  GetWindowRect             = new('user32', 'GetWindowRect', 'lp', 'l')
  GetSystemMetrics          = new('user32', 'GetSystemMetrics', 'l', 'l')
  GetAsyncKeyState          = new('user32', 'GetAsyncKeyState', 'l', 'l')
  AdjustWindowRect          = new('user32', 'AdjustWindowRect', 'pll', 'l')
  GetClientRect             = new('user32', 'GetClientRect', 'lp','i')
  ChangeDisplaySettings     = new('user32', 'ChangeDisplaySettingsW', 'pl', 'l')
  EnumDisplaySettings       = new('user32', 'EnumDisplaySettings', 'llp', 'l')
  SetWindowLong             = new('user32', 'SetWindowLongA', 'pll', 'l')
  GetWindowLong             = new('user32', 'GetWindowLongA', 'll', 'l')
  SetWindowPos              = new('user32', 'SetWindowPos', 'lllllll', 'l')
  RegisterHotKey            = new('user32', 'RegisterHotKey', 'llll', 'l')
  ScreenToClient            = new('user32', 'ScreenToClient', 'lp', 'i')
  ClientToScreen            = new('user32', 'ClientToScreen', 'lp', 'i')
  ClipCursor                = new('user32', 'ClipCursor', 'p', 'l')
  GetCursorPos              = new('user32', 'GetCursorPos', 'p', 'i')
  SetCursorPos              = new('user32', 'SetCursorPos', 'll', 'l')
  ShowCursor                = new('user32', 'ShowCursor', 'l', 'l')
  ImmGetDefaultIMEWnd       = new('Imm32', 'ImmGetDefaultIMEWnd', 'l', 'l')  
  ImmGetContext             = new('imm32','ImmGetContext', 'l', 'l')
  ImmSetConversionStatus    = new('imm32','ImmSetConversionStatus','lll','l')
  ImmReleaseContext         = new('imm32','ImmReleaseContext','ll','l')
  URLDownloadToFile         = new('urlmon', 'URLDownloadToFile', 'lppll', 'l')
  DeleteUrlCacheEntry       = new('Wininet', 'DeleteUrlCacheEntry', 'p', 'l')
  GetLastError              = new('kernel32', 'GetLastError', 'v', 'l')
  CopyFile                  = new('kernel32', 'CopyFile', 'ppl', 'l')
  ShellExecute              = new('shell32', 'ShellExecute', 'lppppl','l')
  AllocConsole              = new('kernel32', 'AllocConsole', 'v', 'l')
  SetForegroundWindow       = new('user32', 'SetForegroundWindow', 'l', 'l')
  SetConsoleTitle           = new('kernel32','SetConsoleTitleA', 'p', 'l')
  GetConsoleWindow          = new('kernel32', 'GetConsoleWindow', 'v', 'l')
  PathFileExists            = new('Shlwapi', 'PathFileExists', 'p', 'l')
  PathIsDirectory           = new('Shlwapi', 'PathIsDirectory', 'p', 'l')
  CreateFile                = new('kernel32', 'CreateFile', 'pllllll', 'l')
  GetFileSize               = new('kernel32', 'GetFileSize', 'll', 'l')
  CloseHandle               = new('kernel32', 'CloseHandle', 'l', 'l')
  GetOpenFileName           = new('comdlg32', 'GetOpenFileName', 'p', 'l')
  IsWindowEnabled           = new('user32', 'IsWindowEnabled', 'l', 'l')
  IsWindowVisible           = new('user32', 'IsWindowVisible', 'l', 'l')
  GetWindowPlacement        = new('user32', 'GetWindowPlacement', 'lp', 'l')
  GetKeyState               = new('user32', 'GetAsyncKeyState', 'i', 'i')
  GetKeyboardState          = new('user32', 'GetKeyState', 'i', 'i')
  GetSetKeyState            = new('user32', 'SetKeyboardState', 'i', 'i')
  SendNotifyMessage         = new('user32', 'SendNotifyMessage', 'llll', 'l')
  AddFontResource           = new('gdi32', 'AddFontResource', 'p', 'l')
  AddFontResourceEx         = new('gdi32', 'AddFontResourceEx', 'PLL', 'L')
  RemoveFontResource        = new('gdi32', 'RemoveFontResource', 'p', 'l')
  RemoveFontResourceEx      = new('gdi32', 'RemoveFontResourceEx', 'pll', 'l')
  RegCreateKey              = new('advapi32', 'RegCreateKey', 'lpp', '')
  RegSetValueEx             = new('advapi32', 'RegSetValueEx', 'ppllpl', 'l')
  RegCloseKey               = new('advapi32', 'RegCloseKey', 'p', 'l')
  GetParent                 = new('user32', 'GetParent', 'l', 'l')
  GetMenu                   = new('user32', 'GetMenu', 'l', 'l')
  RegOpenKeyEx              = new('advapi32', 'RegOpenKeyEx', 'lpllp', 'l')
  RegQueryValueExW          = new('advapi32', 'RegQueryValueExW', 'lplppp', 'l')
  FindNextFile              = new('kernel32', 'FindNextFileW', 'lp', 'i')
end
Game.SubClassing

#───────────────────────────────────────────────────────────────────────────────
# ▶ Color
# ------------------------------------------------------------------------------
# Author    jubin
# Date      2016. 01. 10
# ------------------------------------------------------------------------------
# Description
# 
#    색깔 클래스입니다. alpha는 투명도 입니다.
#───────────────────────────────────────────────────────────────────────────────

class Color
  def self.black(alpha=255)  new(0, 0, 0, alpha); end
  def self.white(alpha=255)  new(255, 255, 255, alpha); end
  def self.gray(alpha=255)   new(96, 96, 96, alpha); end
  def self.red(alpha=255)    new(255, 0, 0, alpha); end
  def self.system(alpha=255) new(0, 96, 255, alpha); end
  def self.yellow(alpha=255) new(255, 255, 0, alpha); end
end

#───────────────────────────────────────────────────────────────────────────────
# * String, 66rpg, joe59491, 2015. 01. 19
#
#   "가".to_m       => "\260\241"
#   "\260\241".to_u => "가"
#───────────────────────────────────────────────────────────────────────────────

class String
  
  CP_UTF8 = 65001
  
  def to_u
    len = Win32API::MultiByteToWideChar.call(0, 0, self, -1, nil, 0)
    buf = "\0" * (len*2)
    Win32API::MultiByteToWideChar.call(0, 0, self, -1, buf, buf.size/2)
    len = Win32API::WideCharToMultiByte.call(CP_UTF8, 0, buf, -1, nil, 0, nil, nil)
    ret = "\0" * (len*2)
    Win32API::WideCharToMultiByte.call(CP_UTF8, 0, buf, -1, ret, ret.size, nil, nil)
    return ret.unpack('C*').select{|s| s != 0}.pack('C*')
  end
  
  def to_m
    len = Win32API::MultiByteToWideChar.call(CP_UTF8, 0, self, -1, nil, 0)
    buf = "\0" * (len*2)
    Win32API::MultiByteToWideChar.call(CP_UTF8, 0, self, -1, buf, buf.size/2)
    len = Win32API::WideCharToMultiByte.call(0, 0, buf, -1, nil, 0, nil, nil)
    ret = "\0" * len
    Win32API::WideCharToMultiByte.call(0, 0, buf, -1, ret, ret.size, nil, nil)
    return ret
  end

  def to_unicode
    len = Win32API::MultiByteToWideChar.call(CP_UTF8, 0, self, -1, 0, 0) << 1
    buf = "\0" * len
    Win32API::MultiByteToWideChar.call(CP_UTF8, 0, self, -1, buf, len)
    return buf
  end
  
  def to_UTF8
    len = Win32API::WideCharToMultiByte.call(CP_UTF8, 0, self, -1, 0, 0, 0, 0)
    buf = "\0" * len
    Win32API::WideCharToMultiByte.call(CP_UTF8, 0, self, -1, buf, len, 0, 0)
    buf.slice!(-1, 1)
    return buf
  end

  def to_b
    return self == 'true'
  end
end

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
  
  # 핸들
  HWND = Game.getHwnd()
  # 게임 타이틀
  CAPTION = Game.getCaption()
end

#────────────────────────────────────────────────────────────────────────────
# * Rect, jubin
#────────────────────────────────────────────────────────────────────────────

class Rect
  def to_a
    [self.x, self.y, self.width, self.height]
  end
  
  def src_rect
    Rect.new(0, 0, self.width, self.height)
  end
end

#────────────────────────────────────────────────────────────────────────────
# * Debug, ForeverZer0
#────────────────────────────────────────────────────────────────────────────

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
end; openDebugWindow

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
    Win32API::MessageBox.call(Game::HWND, arg.to_m, Game::CAPTION, 0 )
    Win32API::ShowCursor.call(0)
  end
  
  def msgbox_p(*args)
    puts(*args)
    Win32API::ShowCursor.call(1)
    _msgbox_p_(*args)
    Win32API::ShowCursor.call(0)
  end
  
  # Custom msgbox
  def msgbox_c(arg, type=0, caption=Game::CAPTION)
    puts(arg)
    Win32API::ShowCursor.call(1)
    id = Win32API::MessageBox.call(Game::HWND, arg.to_s.to_m, caption.to_s.to_m, type)
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

#────────────────────────────────────────────────────────────────────────────
# * File, jubin, 2014. 12. 29
#────────────────────────────────────────────────────────────────────────────

class File
  def self.download(url, filename)
    value = Win32API::URLDownloadToFile.call(0, url.to_m, filename.to_m, 0, 0)
    if value == 0
      Win32API::DeleteUrlCacheEntry.call(url.to_m)
    else
      msgbox_c "다운로드 에러\n(code : #{Win32API::GetLastError.call})", MB::ICONSTOP
    end
  end
  
  def self.copy(from, to, cover=true)
    Win32API::CopyFile.call(from.to_m, to.to_m, cover == true ? 0 : (1 if cover == false))
  end
  
  def self.execute(filename, sw=1, operation='open')
    filename = filename.to_a
    Win32API::ShellExecute.call(0, operation.to_m, filename[0].to_m, filename[1].nil? ? 0 : filename[1].to_m, 0, sw)
  end
  
  def self.setClipboard(type, *args)
    file = File.new('tmp.txt', 'w')
    file.write args.join(type)
    file.close
    system('clip.exe < tmp.txt')
    File.delete('tmp.txt')
  end
  
  def self.iniGet(lpFileName, lpAppName, lpKeyName, lpDefault, nSize)
    buf = "\0" * nSize
    Win32API::GetPrivateProfileString.call(lpAppName, lpKeyName, lpDefault.to_s, buf, nSize, lpFileName)
    buf.delete!("\0")
    if buf.to_i.to_s == buf # 정수
      buf = buf.to_i
    elsif buf == 'false' # false
      buf = false
    elsif buf == 'true' # true
      buf = true
    end    
    return buf
  end

  def self.iniWrite(lpFileName, lpAppName, lpKeyName, lpString)
    return Win32API::WritePrivateProfileString.call(lpAppName, lpKeyName, lpString.to_s, lpFileName)
  end
end

#────────────────────────────────────────────────────────────────────────────
# * FileTest, jubin, 2014. 12. 29
#────────────────────────────────────────────────────────────────────────────

module FileTest
  module_function
  
  def exist?(filename)
    Win32API::PathFileExists.call(filename.to_m) == 0x1
  end
  
  def directory?(filename)
    Win32API::PathIsDirectory.call(filename.to_m) == 0x10
  end
  
  def file?(filename)
    Win32API::PathIsDirectory.call(filename.to_m) == 0
  end
  
  def size(filename)
    h = Win32API::CreateFile.call(filename.to_m, 0x80000000, 0, 0, 3, 0, 0)
    size = Win32API::GetFileSize.call(h, 0)
    Win32API::CloseHandle.call(h)
    size
  end
end
#────────────────────────────────────────────────────────────────────────────
# * FPS, Zeus81, 2012. 08. 03
#   http://forums.rpgmakerweb.com/index.php?/topic/3738-fps-display-isnt-very-accurate/
#────────────────────────────────────────────────────────────────────────────

module Graphics
  @fps, @fps_tmp = 0, []
  
  class << self
    attr_reader :fps
    alias :fps_update :update unless method_defined?(:fps_update)
    def update
      t = Time.now
      fps_update
      @fps_tmp[frame_count % frame_rate] = Time.now != t
      @fps = 0
      frame_rate.times {|i| @fps += 1 if @fps_tmp[i]}
      fps_sprite.src_rect.y = @fps * 16
    end
    
    def fps_sprite
      if !@fps_sprite or @fps_sprite.disposed?
        @fps_sprite = Sprite.new
        @fps_sprite.z = 0x7FFFFFFF
        @fps_sprite.bitmap = Bitmap.new(24, 16*120)
        @fps_sprite.bitmap.font.name = "Arial"
        @fps_sprite.bitmap.font.size = 16
        @fps_sprite.bitmap.font.color.set(255, 255, 255)
        @fps_sprite.bitmap.fill_rect(@fps_sprite.bitmap.rect, Color.new(0, 0, 0, 128))
        120.times {|i|
          case i
          when 0..24
            @fps_sprite.bitmap.font.color = Color.red
          when 25..39
            @fps_sprite.bitmap.font.color = Color.new(255, 128, 0)
          else
            @fps_sprite.bitmap.font.color = Color.white
          end
          @fps_sprite.bitmap.draw_text(0, i*16, 24, 16, "% 3d"%i, 1)
        }
        @fps_sprite.src_rect.height = 16
      end
      return @fps_sprite
    end
  end
end

#────────────────────────────────────────────────────────────────────────────
# * Regedit, joe59491
#────────────────────────────────────────────────────────────────────────────

module Regedit
  module_function
  
  Wow6432Node            = 0x0200
  HKEY_LOCAL_MACHINE     = 0x80000002
  STANDARD_RIGHTS_READ   = 0x00020000
  KEY_QUERY_VALUE        = 0x0001
  KEY_ENUMERATE_SUB_KEYS = 0x0008
  KEY_NOTIFY             = 0x0010
  KEY_READ               = STANDARD_RIGHTS_READ | KEY_QUERY_VALUE |
                           KEY_ENUMERATE_SUB_KEYS | KEY_NOTIFY
  KEY_EXECUTE            = KEY_READ | Wow6432Node
  
  # 맨 위로
  def OpenKey(hkey, name, opt, desired)
    result = packdw(0)
    check Win32API::RegOpenKeyEx.call(hkey, name, opt, desired, result)
    @reg_jb = unpackdw(result)
  end
  
  def QueryValue(hkey, name)
    size = [256].pack('l')
    data = "\0" * 256
    Win32API::RegQueryValueExW.call(hkey, name.to_unicode, 0, 0, data, size)
    check(data, name)
    data = data.to_UTF8
    return data
  end
  
  def check(data, name="")
    if data == "\0" * 256
      p "RTP：#{name}를 찾을 수 없습니다."
      exit
    end
  end
  
  def packdw(dw)
    [dw].pack("V")
  end
  
  def unpackdw(dw)
    dw += [0].pack("V")
    dw.unpack("V")[0]
  end
  
  def get_jb
    return @reg_jb if @reg_jb != nil
  end
  
  def getRTPPath(rtpname)
    return "" if rtpname == "" || rtpname == nil
    Regedit.OpenKey(HKEY_LOCAL_MACHINE, "SOFTWARE\\Enterbrain\\RGSS\\RTP", 0, KEY_EXECUTE)
    rp = Regedit.QueryValue(Regedit.get_jb, rtpname)
    return "" if rp == "" || rp == nil
    rp = File.expand_path(rp) + "/"
    return rp
  end
  
  $RTP ||= []
  for i in 0...3
    $RTP[i] = Regedit::getRTPPath(File.iniGet("./Game.ini", "Game", "RTP#{i+1}", "", 256))
  end
end

#────────────────────────────────────────────────────────────────────────────
# ▶ Bitmap
# --------------------------------------------------------------------------
# Author    jubin
# Date      2016. 01. 10
# --------------------------------------------------------------------------
# Description
# 
#    확장된 함수가 추가된 비트맵 클래스입니다.
#────────────────────────────────────────────────────────────────────────────

class Bitmap
  alias :_initialize_ :initialize if !$@
  def initialize(*args)
    if args.size == 1 && args[0].is_a?(String)
      args[0] = RPG::Path::RTP(args[0])
    end
    _initialize_(*args)
  end
  
  # 테두리 텍스트
  def draw_outline_text(x, y, width, height, str,
                       color = Color.white, color2 = Color.black, align = 0, multi = false)
    font.color = color2
    str = str.to_s if !str.is_a?(String)
    for i in -1..1
      for j in -1..1
        if i*j == 0 and i+j != 0
          multi ? draw_multi_text(x + i, y + j, width, height, str, align) : 
            draw_text(x + i, y + j, width, height, str, align)
        end
      end
    end
    font.color = color
    multi ? draw_multi_text(x, y, width, height, str, align) : draw_text(x, y, width, height, str, align)
  end
  
  # 멀티라인(\n) 테두리 텍스트
  def draw_multi_outline_text(x, y, width, height, str, color = Color.white, color2 = Color.black, align = 0)
    draw_outline_text(x, y, width, height, str, color, color2, align, true)
  end
  
  # 텍스트 덩어리
  # esn : Escape Sequence '\n' 으로 나누거나(true), 혹은 width에 맞추거나(false)
  def get_divided_text(width, str, esn = false)
    line, text, x = Array.new, String.new, 0
    return line if not str
    for char in str.split(//)
      # \n은 문자열에 더하고, 사이즈는 더하지 않는다.
      text += char
      if char != "\n"
        rect = text_size(char)
        x += rect.width
      end
      if esn
        if char == "\n"
          text.gsub!("\n", "")
          line.push(text)
          text = ""
          x = 0
        end
      elsif !esn
        if x + rect.width > width or char == "\n"
          text.gsub!("\n", "")
          line.push(text)
          text = ""
          x = 0
        end
      end      
    end
    line.push(text)
    return line
  end
  
  # 멀티라인(\n) 텍스트
  def draw_multi_text(x, y, width, height, str, align = 0, esn = false)
    text = get_divided_text(width, str, esn)
    text.each_index do |n|
      next if text[n] == ""
      # 비트맵 세로 크기보다 크면 중단
      return if y + n * text_size(text[n]).height >= height
      draw_text(x, y + n * text_size(text[n]).height, 
      width, text_size(text[n]).height, text[n], align)
=begin
      # 정렬 변수
      xa = case align
      when 0; x
      when 1; (width - text_size(text[n]).width) / 2.0
      when 2; width - text_size(text[n]).width end
      # 비트맵 세로 크기보다 크면 중단
      return if y + n * text_size(text[n]).height >= height
      # 텍스트 생성
      draw_text(
        x + xa, y + n * text_size(text[n]).height,
        text_size(text[n]).width + 1, text_size(text[n]).height, text[n])
=end
    end
  end
  
  # xalign // 0 : 왼, 1 : 중간, 2 : 오른
  # yalign // 0 : 위, 1 : 중간, 2 : 아래
  # 선
  def fill_line(str, color = Color.new(0, 0, 0), xalign = 0, yalign = 2, esn = false)
    return if color.nil?
    # 굵기
    thick = (text_size(str).height / 12.0).round
    thick = 1 if thick == 0
    # 글자
    text = get_divided_text(self.width, str, esn)
    text.each_index do |n|
      # 정렬
      xa = case xalign
      when 0; 0
      when 1; (width - text_size(text[n]).width) / 2.0
      when 2; width - text_size(text[n]).width end
      ya = case yalign
      when 0; 0
      when 1; text_size(text[n]).height / 2.0
      when 2; text_size(text[n]).height - thick end
      # 선 그리기
      fill_rect(
        xa, 
        ya + n * text_size(text[n]).height,
        text_size(text[n]).width,
        thick,
        color)
    end
  end
end

#────────────────────────────────────────────────────────────────────────────
# * RTP, joe59491
#────────────────────────────────────────────────────────────────────────────
module RPG::Path
  
  module_function

  def findP(*paths)
    for p in paths
      findFileData = Win32API::FindFirstFile.call(p.to_unicode)
      unless findFileData == "" # INVALID_HANDLE_VALUE
        return File.dirname(p) + "/" + findFileData
      end
    end
    return ""
  end

  def RTP(path)
    @list ||= Hash.new
    return @list[path] if @list.include?(path)
    check = File.extname(path).empty?
    rtp = []
    for i in 0...3
      unless $RTP[i].empty?
        rtp.push($RTP[i] + path)
        if check
          rtp.push($RTP[i] + path + ".*")
        end
      end
    end
    pa = findP(*rtp)
    if pa == ""
      @list[path] = path
    else
      @list[path] = pa
    end
    return @list[path]
  end
end

#────────────────────────────────────────────────────────────────────────────
# * Audio, joe59491
#────────────────────────────────────────────────────────────────────────────

module Audio
  class << self
    alias :bgm_play_path :bgm_play if !$@
    alias :bgs_play_path :bgs_play if !$@
    alias :se_play_path :se_play if !$@
    alias :me_play_path :me_play if !$@
  end
  
  module_function
  
  def bgm_play(filename, volume=100, pitch=1)
    path = filename
    path = RPG::Path::RTP(path)
    bgm_play_path(path, volume.to_i, pitch)
  end
  
  def bgs_play(filename, volume=100, pitch=1)
    path = filename
    path = RPG::Path::RTP(path)
    bgs_play_path(path, volume.to_i, pitch)
  end
  
  def me_play(filename, volume=100, pitch=1)
    path = filename
    path = RPG::Path::RTP(path)
    me_play_path(path, volume.to_i, pitch)
  end
  
  def se_play(filename, volume=100, pitch=1)
    path = filename
    path = RPG::Path::RTP(path)
    se_play_path(path, volume.to_i, pitch)
  end
end

#===============================================================================
# Proper Graphics Disposal
# Author: Blizzard
# Version: 1.0
#-------------------------------------------------------------------------------
# [ Description ]
# RPG Maker VX Ace came with a somewhat unknown problem revolving around sprites
# assigned to viewports. If a viewport is disposed before disposing the sprites
# on it, it can lead to unexpected crashes. This was normally handled in RMXP
# but this can cause memory leaks in RMVXA. As such, this script ensures that
# any sprites attached to a viewport are disposed first before the viewport is
# disposed.
#
# For more information, please read the topic discussion:
#   http://forums.rpgmakerweb.com/index.php?/topic/17400-hidden-gameexe-crash-
#   debugger-graphical-object-global-reference-ace/
#
# [ Instructions ]
# There is nothing to do here.
# Please keep this script in its current location.
#
# It is highly advised to not modify this script unless you know what you are
# doing.
#===============================================================================
#==============================================================================
# Sprite
#==============================================================================

class Sprite
  class << Sprite
    alias new_xpa_sprite_fix new
    def new(*args)
      object = new_xpa_sprite_fix(*args)
      if !object.disposed? && object.viewport != nil
        object.viewport.register_sprite(object)
      end
      return object
    end
  end 
  
  alias dispose_xpa_sprite_fix dispose
  def dispose
    if !self.disposed? && self.viewport != nil
      self.viewport.unregister_sprite(self)
    end
    dispose_xpa_sprite_fix
  end
  
end
  
#==============================================================================
# Viewport
#==============================================================================

class Viewport
  
  alias dispose_xpa_sprite_fix dispose
  def dispose
    if @_sprites != nil
      @_sprites.clone.each {|sprite| sprite.dispose if !sprite.disposed? }
      @_sprites = []
    end
    dispose_xpa_sprite_fix
  end
  
  def register_sprite(sprite)
    @_sprites ||= []
    @_sprites.push(sprite)
  end
  
  def unregister_sprite(sprite)
    @_sprites ||= []
    @_sprites.delete(sprite)
  end
  
end


=begin
#===============================================================================
 Title: Unlimited Resolution
 Date: Oct 24, 2013
 Author: Hime
--------------------------------------------------------------------------------   
 Terms of Use
 Free
--------------------------------------------------------------------------------
 Description
 
 This script modifies Graphics.resize_screen to overcome the 640x480 limitation.
 It also includes some modifications to module Graphics such as allowing the
 default fade transition to cover the entire screen.
 
 Now you can have arbitrarily large game resolutions.
--------------------------------------------------------------------------------
 Credits
 
 Unknown author for overcoming the 640x480 limitation
 Lantier, from RMW forums for posting the snippet above
 Esrever for handling the viewport
 Jet, for the custom Graphics code
 FenixFyre, for the Plane class fix
 Kaelan, for several bug fixes

#===============================================================================
=end  

module Graphics
  
  @@super_sprite = Sprite.new
  @@super_sprite.z = (2 ** (0.size * 8 - 2) - 1)

  class << self
    alias :th_large_screen_resize_screen :resize_screen
  end

  #-----------------------------------------------------------------------------
  # Unknown Scripter. Copied from http://pastebin.com/sM2MNJZj 
  #-----------------------------------------------------------------------------
  def self.resize_screen(width, height)
    wt, ht = width.divmod(32), height.divmod(32)
    wh = -> w, h, off = 0 { [w + off, h + off].pack('l2').scan /.{4}/ }
    w, h = wh.(width, height)
    ww, hh = wh.(width, height, 32)
    www, hhh = wh.(wt.first.succ, ht.first.succ)
    base = 0x10000000
    mod = -> adr, val { DL::CPtr.new(base + adr)[0, val.size] = val }
    mod.(0x195F, "\x90" * 5)
    mod.(0x19A4, h)
    mod.(0x19A9, w)
    mod.(0x1A56, h)
    mod.(0x1A5B, w)
    mod.(0x20F6, w)
    mod.(0x20FF, w)
    mod.(0x2106, h)
    mod.(0x210F, h)
    zero = [0].pack ?l
    mod.(0x1C5E3, zero)
    mod.(0x1C5E8, zero)
    mod.(0x1F477, h)
    mod.(0x1F47C, w)
    mod.(0x211FF, hh)
    mod.(0x21204, ww)
    mod.(0x21D7D, hhh[0])
    mod.(0x21E01, www[0])
    mod.(0x10DEA8, h)
    mod.(0x10DEAD, w)
    mod.(0x10DEDF, h)
    mod.(0x10DEF0, w)
    mod.(0x10DF14, h)
    mod.(0x10DF18, w)
    mod.(0x10DF48, h)
    mod.(0x10DF4C, w)
    mod.(0x10E6A7, w)
    mod.(0x10E6C3, h)
    mod.(0x10EEA9, w)
    mod.(0x10EEB9, h)
    th_large_screen_resize_screen(width, height)
  end
end

#────────────────────────────────────────────────────────────────────────────
# * Graphics, 紫苏, jubin, 2015. 03. 15
#────────────────────────────────────────────────────────────────────────────

module Graphics
  module_function
   
  @width  = Config::WINDOW_WIDTH
  @height = Config::WINDOW_HEIGHT

  GWL_STYLE         = -16
  WS_BORDER         = 0x800000
  WS_DLGFRAME       = 0x400000
  SWP_SHOWWINDOW    = 0x40
  HWND_TOPMOST      = -1
  HWND_NOTOPMOST    = -2

  PEDTH             = 0x80000
  BITSPERPEL        = 0x00040000
  PELSWIDTH         = 0x00080000
  PELSHEIGHT        = 0x00100000
  CDS_FULLSCREEN    = 0x00000004
  CDS_RESET         = 0x40000000
  DISP_CHANGE_SUCCESSFUL = 0
  DISP_CHANGE_BADMODE = -2
  
  MOD_ALT = 0x0001
  VK_RETURN = 0x0D
  KEY_LALT = 0xA4
  KEY_RETURN = 0x0D
  
  # 윈도우 스타일
  def getWindowStyle
    return Win32API::GetWindowLong.call(Game::HWND, GWL_STYLE)
  end
  
  # 컴퓨터 해상도
  def getMonitorRect
    return [Win32API::GetSystemMetrics.call(0), Win32API::GetSystemMetrics.call(1)]
  end
  
  # 작업표시줄
  def getTaskBarRect
    rect = [0, 0, 0, 0].pack('l4')
    Win32API::GetWindowRect.call(Win32API::FindWindow.call('Shell_TrayWnd', 0), rect)
    rect = rect.unpack('l4')
    w, h = (rect[2] - rect[0]).abs, (rect[3] - rect[1]).abs
    return [(w >= WIN_RECT[0] ? 0 : w), (h >= WIN_RECT[1] ? 0 : h)]
  end
  
  # 풀스크린 사용 가능한 해상도
  def getMonitorsRect
    display, devmode, n = [], '\0'*64, 0
    loop do
      if Win32API::EnumDisplaySettings.call(0, n, devmode) == 0
        break
      else
        setting = devmode.unpack("l*")
        rect = [setting[27], setting[28]]
        display.include?(rect) ? n += 1: display.push(rect)
      end
    end
    return display
  end
    
  WIN_STYLE = getWindowStyle
  WIN_RECT  = getMonitorRect
  TASKSIZE  = getTaskBarRect
  DISPLAYS  = getMonitorsRect
    
  # 해상도 변경
  def resize_screen2(width, height, fullscreen = false)
    @width, @height = width, height
    if fullscreen
      unless DISPLAYS.include?([width, height])
        if defined? MUI_Dialog
          dialog = MUI_Dialog.new(Dialog::RESOLUTION, "알림", "#{width}*#{height} 의 해상도는 풀스크린을 지원하지 않습니다.", ["확인"]) do
            dialog.dispose if dialog.value == 0
          end
        end
        return false
      end
      case Win32API::ChangeDisplaySettings.call(getDevmode(width, height), CDS_FULLSCREEN)
      when DISP_CHANGE_SUCCESSFUL
        Win32API::SetWindowLong.call(Game::HWND, GWL_STYLE, WIN_STYLE ^ (WS_BORDER | WS_DLGFRAME))
        Win32API::SetWindowPos.call(Game::HWND, HWND_TOPMOST, 0, 0, width, height, SWP_SHOWWINDOW)
        Win32API::ChangeDisplaySettings.call(0, 0x40000000)
        Win32API::ClipCursor.call([0, 0, self.width, self.height].pack('l4'))
        Win32API::SetCursorPos.call(Game.getClientRect[2] + Graphics.width / 2, Game.getClientRect[3] + Graphics.height / 2)
        return true
      when DISP_CHANGE_BADMODE
        Win32API::ClipCursor.call(0)
        Win32API::ChangeDisplaySettings.call(0, 0)
        Win32API::SetCursorPos.call(Game.getClientRect[2] + Graphics.width / 2, Game.getClientRect[3] + Graphics.height / 2)
        return false
      end
    else
      Win32API::ClipCursor.call(0)
      Win32API::ChangeDisplaySettings.call(0, 0)
      Win32API::SetWindowLong.call(Game::HWND, GWL_STYLE, WIN_STYLE)
      Win32API::SetCursorPos.call(WIN_RECT[0] / 2, WIN_RECT[1] / 2)
      return setCenterWindow(width, height) == 1
    end
  end
  
  # DEVMODE 구조체
  def getDevmode(width, height, bit=32)
    devmode =
    [0,0,0,0,0,0,0,0,0,220,0,BITSPERPEL|PELSWIDTH|PELSHEIGHT|PEDTH,
     0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,bit,width,height,0,0,0,0,0]
    return devmode.pack('Q8 L S2 L Q2 S5 Q8 S L3 Q5')
  end

  # 윈도우 가운데 정렬
  def setCenterWindow(width, height)
    Win32API::AdjustWindowRect.call(rect=[0, 0, width, height].pack('l4'), WIN_STYLE, 0)
    rect = rect.unpack('l4'); rect = rect[2] - rect[0], rect[3] - rect[1]
    x = WIN_RECT[0] - TASKSIZE[0] - rect[0]
    y = WIN_RECT[1] - TASKSIZE[1] - rect[1]
    Win32API::SetWindowPos.call(Game::HWND, HWND_NOTOPMOST, x/2, y/2, rect[0], rect[1], SWP_SHOWWINDOW)
  end

  # 풀스크린 상태
  def isFullScreen
    rect = [0, 0, 0, 0].pack('l4')
    Win32API::GetWindowRect.call(Game::HWND, rect)
    return rect.unpack('l4') == [0, 0, *WIN_RECT]
  end
    
  # Rect
  def getRect
    return [Graphics.width, Graphics.height]
  end

  class << self
    alias :_update_ :update if !$@
    def update
      _update_
      if defined? Key and Config::USE_ALT_ENTER and Graphics.focus
        if Key.press?(KEY_LALT) and Key.trigger?(KEY_RETURN)
          Graphics.resize_screen2(self.width, self.height, !isFullScreen)
        end
        exit if Key.press?(KEY_LALT) and Key.trigger?(KEY_F4)
      end
    end
  end
end

Win32API::RegisterHotKey.call(Game::HWND, 0, Graphics::MOD_ALT, Graphics::VK_RETURN)
Graphics.resize_screen(Config::WINDOW_WIDTH, Config::WINDOW_HEIGHT)
Graphics.resize_screen2(Config::WINDOW_WIDTH, Config::WINDOW_HEIGHT, File.iniGet(Config::OPTION_PATH, Config::OPTION_KEY, "fullscreen", false, 10))




#────────────────────────────────────────────────────────────────────────────
# * RPG, EnterBrain
#────────────────────────────────────────────────────────────────────────────

module RPG
  module Cache
    @cache = {}
    def self.load_bitmap(folder_name, filename, hue = 0)
      return if not filename
      path = folder_name + filename
      path = RPG::Path::RTP(path)
      if not @cache.include?(path) or @cache[path].disposed?
        if filename != ""
          @cache[path] = Bitmap.new(path)
        else
          @cache[path] = Bitmap.new(32, 32)
        end
      end
      if hue == 0
        @cache[path]
      else
        key = [path, hue]
        if not @cache.include?(key) or @cache[key].disposed?
          @cache[key] = @cache[path].clone
          @cache[key].hue_change(hue)
        end
        @cache[key]
      end
    end
  end
  class Sprite < ::Sprite
    def animation_process_timing(timing, hit)
      if (timing.condition == 0) or
        (timing.condition == 1 and hit == true) or
        (timing.condition == 2 and hit == false)
        if timing.se.name != ""
          se = timing.se
          path = RPG::Path::RTP("Audio/SE/" + se.name)
          Audio.se_play(path, Game.system.se_volume, se.pitch)
        end
        case timing.flash_scope
        when 1
          self.flash(timing.flash_color, timing.flash_duration * 2)
        when 2
          if self.viewport != nil
            self.viewport.flash(timing.flash_color, timing.flash_duration * 2)
          end
        when 3
          self.flash(nil, timing.flash_duration * 2)
        end
      end
    end
  end
end

module RPG
  class Sprite < ::Sprite
    @@_animations = []
    @@_reference_count = {}
    def initialize(viewport = nil)
      super(viewport)
      @_whiten_duration = 0
      @_appear_duration = 0
      @_escape_duration = 0
      @_collapse_duration = 0
      @_damage_duration = 0
      @_animation_duration = 0
      @_blink = false
    end
    def dispose
      dispose_damage
      dispose_animation
      dispose_loop_animation
      super
    end
    def whiten
      self.blend_type = 0
      self.color.set(255, 255, 255, 128)
      self.opacity = 255
      @_whiten_duration = 16
      @_appear_duration = 0
      @_escape_duration = 0
      @_collapse_duration = 0
    end
    def appear
      self.blend_type = 0
      self.color.set(0, 0, 0, 0)
      self.opacity = 0
      @_appear_duration = 16
      @_whiten_duration = 0
      @_escape_duration = 0
      @_collapse_duration = 0
    end
    def escape
      self.blend_type = 0
      self.color.set(0, 0, 0, 0)
      self.opacity = 255
      @_escape_duration = 32
      @_whiten_duration = 0
      @_appear_duration = 0
      @_collapse_duration = 0
    end
    def collapse
      self.blend_type = 1
      self.color.set(255, 64, 64, 255)
      self.opacity = 255
      @_collapse_duration = 48
      @_whiten_duration = 0
      @_appear_duration = 0
      @_escape_duration = 0
    end
    def damage(value, critical)
      dispose_damage
      if value.is_a?(Numeric)
        damage_string = value.abs.to_s
      else
        damage_string = value.to_s
      end
      bitmap = Bitmap.new(160, 48)
      bitmap.font.name = "Arial Black"
      bitmap.font.size = 32
      bitmap.font.color.set(0, 0, 0)
      bitmap.draw_text(-1, 12-1, 160, 36, damage_string, 1)
      bitmap.draw_text(+1, 12-1, 160, 36, damage_string, 1)
      bitmap.draw_text(-1, 12+1, 160, 36, damage_string, 1)
      bitmap.draw_text(+1, 12+1, 160, 36, damage_string, 1)
      if value.is_a?(Numeric) and value < 0
        bitmap.font.color.set(176, 255, 144)
      else
        bitmap.font.color.set(255, 255, 255)
      end
      bitmap.draw_text(0, 12, 160, 36, damage_string, 1)
      if critical
        bitmap.font.size = 20
        bitmap.font.color.set(0, 0, 0)
        bitmap.draw_text(-1, -1, 160, 20, "CRITICAL", 1)
        bitmap.draw_text(+1, -1, 160, 20, "CRITICAL", 1)
        bitmap.draw_text(-1, +1, 160, 20, "CRITICAL", 1)
        bitmap.draw_text(+1, +1, 160, 20, "CRITICAL", 1)
        bitmap.font.color.set(255, 255, 255)
        bitmap.draw_text(0, 0, 160, 20, "CRITICAL", 1)
      end
      @_damage_sprite = ::Sprite.new(self.viewport)
      @_damage_sprite.bitmap = bitmap
      @_damage_sprite.ox = 80
      @_damage_sprite.oy = 20
      @_damage_sprite.x = self.x
      @_damage_sprite.y = self.y - self.oy / 2
      @_damage_sprite.z = 3000
      @_damage_duration = 40
    end
    def animation(animation, hit)
      dispose_animation
      @_animation = animation
      return if @_animation == nil
      @_animation_hit = hit
      @_animation_duration = @_animation.frame_max
      animation_name = @_animation.animation_name
      animation_hue = @_animation.animation_hue
      bitmap = RPG::Cache.animation(animation_name, animation_hue)
      if @@_reference_count.include?(bitmap)
        @@_reference_count[bitmap] += 1
      else
        @@_reference_count[bitmap] = 1
      end
      @_animation_sprites = []
      if @_animation.position != 3 or not @@_animations.include?(animation)
        for i in 0..15
          sprite = ::Sprite.new(self.viewport)
          sprite.bitmap = bitmap
          sprite.visible = false
          @_animation_sprites.push(sprite)
        end
        unless @@_animations.include?(animation)
          @@_animations.push(animation)
        end
      end
      update_animation
    end
    def loop_animation(animation)
      return if animation == @_loop_animation
      dispose_loop_animation
      @_loop_animation = animation
      return if @_loop_animation == nil
      @_loop_animation_index = 0
      animation_name = @_loop_animation.animation_name
      animation_hue = @_loop_animation.animation_hue
      bitmap = RPG::Cache.animation(animation_name, animation_hue)
      if @@_reference_count.include?(bitmap)
        @@_reference_count[bitmap] += 1
      else
        @@_reference_count[bitmap] = 1
      end
      @_loop_animation_sprites = []
      for i in 0..15
        sprite = ::Sprite.new(self.viewport)
        sprite.bitmap = bitmap
        sprite.visible = false
        @_loop_animation_sprites.push(sprite)
      end
      update_loop_animation
    end
    def dispose_damage
      if @_damage_sprite != nil
        @_damage_sprite.bitmap.dispose
        @_damage_sprite.dispose
        @_damage_sprite = nil
        @_damage_duration = 0
      end
    end
    def dispose_animation
      if @_animation_sprites != nil
        sprite = @_animation_sprites[0]
        if sprite != nil
          @@_reference_count[sprite.bitmap] -= 1
          if @@_reference_count[sprite.bitmap] == 0
            sprite.bitmap.dispose
          end
        end
        for sprite in @_animation_sprites
          sprite.dispose
        end
        @_animation_sprites = nil
        @_animation = nil
      end
    end
    def dispose_loop_animation
      if @_loop_animation_sprites != nil
        sprite = @_loop_animation_sprites[0]
        if sprite != nil
          @@_reference_count[sprite.bitmap] -= 1
          if @@_reference_count[sprite.bitmap] == 0
            sprite.bitmap.dispose
          end
        end
        for sprite in @_loop_animation_sprites
          sprite.dispose
        end
        @_loop_animation_sprites = nil
        @_loop_animation = nil
      end
    end
    def blink_on
      unless @_blink
        @_blink = true
        @_blink_count = 0
      end
    end
    def blink_off
      if @_blink
        @_blink = false
        self.color.set(0, 0, 0, 0)
      end
    end
    def blink?
      @_blink
    end
    def effect?
      @_whiten_duration > 0 or
      @_appear_duration > 0 or
      @_escape_duration > 0 or
      @_collapse_duration > 0 or
      @_damage_duration > 0 or
      @_animation_duration > 0
    end
    def update
      super
      if @_whiten_duration > 0
        @_whiten_duration -= 1
        self.color.alpha = 128 - (16 - @_whiten_duration) * 10
      end
      if @_appear_duration > 0
        @_appear_duration -= 1
        self.opacity = (16 - @_appear_duration) * 16
      end
      if @_escape_duration > 0
        @_escape_duration -= 1
        self.opacity = 256 - (32 - @_escape_duration) * 10
      end
      if @_collapse_duration > 0
        @_collapse_duration -= 1
        self.opacity = 256 - (48 - @_collapse_duration) * 6
      end
      if @_damage_duration > 0
        @_damage_duration -= 1
        case @_damage_duration
        when 38..39
          @_damage_sprite.y -= 4
        when 36..37
          @_damage_sprite.y -= 2
        when 34..35
          @_damage_sprite.y += 2
        when 28..33
          @_damage_sprite.y += 4
        end
        @_damage_sprite.opacity = 256 - (12 - @_damage_duration) * 32
        if @_damage_duration == 0
          dispose_damage
        end
      end
      if @_animation != nil and (Graphics.frame_count % 2 == 0)
        @_animation_duration -= 1
        update_animation
      end
      if @_loop_animation != nil and (Graphics.frame_count % 2 == 0)
        update_loop_animation
        @_loop_animation_index += 1
        @_loop_animation_index %= @_loop_animation.frame_max
      end
      if @_blink
        @_blink_count = (@_blink_count + 1) % 32
        if @_blink_count < 16
          alpha = (16 - @_blink_count) * 6
        else
          alpha = (@_blink_count - 16) * 6
        end
        self.color.set(255, 255, 255, alpha)
      end
      @@_animations.clear
    end
    def update_animation
      if @_animation_duration > 0
        frame_index = @_animation.frame_max - @_animation_duration
        cell_data = @_animation.frames[frame_index].cell_data
        position = @_animation.position
        animation_set_sprites(@_animation_sprites, cell_data, position)
        for timing in @_animation.timings
          if timing.frame == frame_index
            animation_process_timing(timing, @_animation_hit)
          end
        end
      else
        dispose_animation
      end
    end
    def update_loop_animation
      frame_index = @_loop_animation_index
      cell_data = @_loop_animation.frames[frame_index].cell_data
      position = @_loop_animation.position
      animation_set_sprites(@_loop_animation_sprites, cell_data, position)
      for timing in @_loop_animation.timings
        if timing.frame == frame_index
          animation_process_timing(timing, true)
        end
      end
    end
    def animation_set_sprites(sprites, cell_data, position)
      for i in 0..15
        sprite = sprites[i]
        pattern = cell_data[i, 0]
        if sprite == nil or pattern == nil or pattern == -1
          sprite.visible = false if sprite != nil
          next
        end
        sprite.visible = true
        sprite.src_rect.set(pattern % 5 * 192, pattern / 5 * 192, 192, 192)
        if position == 3
          if self.viewport != nil
            sprite.x = self.viewport.rect.width / 2
            sprite.y = self.viewport.rect.height - 160
          else
            sprite.x = Config::WINDOW_WIDTH / 2
            sprite.y = Config::WINDOW_HEIGHT / 2
          end
        else
          sprite.x = self.x - self.ox + self.src_rect.width / 2
          sprite.y = self.y - self.oy + self.src_rect.height / 2
          sprite.y -= self.src_rect.height / 4 if position == 0
          sprite.y += self.src_rect.height / 4 if position == 2
        end
        sprite.x += cell_data[i, 1]
        sprite.y += cell_data[i, 2]
        sprite.z = 2000
        sprite.ox = 96
        sprite.oy = 96
        sprite.zoom_x = cell_data[i, 3] / 100.0
        sprite.zoom_y = cell_data[i, 3] / 100.0
        sprite.angle = cell_data[i, 4]
        sprite.mirror = (cell_data[i, 5] == 1)
        sprite.opacity = cell_data[i, 6] * self.opacity / 255.0
        sprite.blend_type = cell_data[i, 7]
      end
    end
    def animation_process_timing(timing, hit)
      if (timing.condition == 0) or
         (timing.condition == 1 and hit == true) or
         (timing.condition == 2 and hit == false)
        if timing.se.name != ""
          se = timing.se
          Audio.se_play("Audio/SE/" + se.name, se.volume, se.pitch)
        end
        case timing.flash_scope
        when 1
          self.flash(timing.flash_color, timing.flash_duration * 2)
        when 2
          if self.viewport != nil
            self.viewport.flash(timing.flash_color, timing.flash_duration * 2)
          end
        when 3
          self.flash(nil, timing.flash_duration * 2)
        end
      end
    end
    def x=(x)
      sx = x - self.x
      if sx != 0
        if @_animation_sprites != nil
          for i in 0..15
            @_animation_sprites[i].x += sx
          end
        end
        if @_loop_animation_sprites != nil
          for i in 0..15
            @_loop_animation_sprites[i].x += sx
          end
        end
      end
      super
    end
    def y=(y)
      sy = y - self.y
      if sy != 0
        if @_animation_sprites != nil
          for i in 0..15
            @_animation_sprites[i].y += sy
          end
        end
        if @_loop_animation_sprites != nil
          for i in 0..15
            @_loop_animation_sprites[i].y += sy
          end
        end
      end
      super
    end
  end
end

module RPG
  class Weather
    def initialize(viewport = nil)
      @type = 0
      @max = 0
      @ox = 0
      @oy = 0
      color1 = Color.new(255, 255, 255, 255)
      color2 = Color.new(255, 255, 255, 128)
      @rain_bitmap = Bitmap.new(7, 56)
      for i in 0..6
        @rain_bitmap.fill_rect(6-i, i*8, 1, 8, color1)
      end
      @storm_bitmap = Bitmap.new(34, 64)
      for i in 0..31
        @storm_bitmap.fill_rect(33-i, i*2, 1, 2, color2)
        @storm_bitmap.fill_rect(32-i, i*2, 1, 2, color1)
        @storm_bitmap.fill_rect(31-i, i*2, 1, 2, color2)
      end
      @snow_bitmap = Bitmap.new(6, 6)
      @snow_bitmap.fill_rect(0, 1, 6, 4, color2)
      @snow_bitmap.fill_rect(1, 0, 4, 6, color2)
      @snow_bitmap.fill_rect(1, 2, 4, 2, color1)
      @snow_bitmap.fill_rect(2, 1, 2, 4, color1)
      @sprites = []
      for i in 1..40
        sprite = Sprite.new(viewport)
        sprite.z = 1000
        sprite.visible = false
        sprite.opacity = 0
        @sprites.push(sprite)
      end
    end
    def dispose
      for sprite in @sprites
        sprite.dispose
      end
      @rain_bitmap.dispose
      @storm_bitmap.dispose
      @snow_bitmap.dispose
    end
    def type=(type)
      return if @type == type
      @type = type
      case @type
      when 1
        bitmap = @rain_bitmap
      when 2
        bitmap = @storm_bitmap
      when 3
        bitmap = @snow_bitmap
      else
        bitmap = nil
      end
      for i in 1..40
        sprite = @sprites[i]
        if sprite != nil
          sprite.visible = (i <= @max)
          sprite.bitmap = bitmap
        end
      end
    end
    def ox=(ox)
      return if @ox == ox;
      @ox = ox
      for sprite in @sprites
        sprite.ox = @ox
      end
    end
    def oy=(oy)
      return if @oy == oy;
      @oy = oy
      for sprite in @sprites
        sprite.oy = @oy
      end
    end
    def max=(max)
      return if @max == max;
      @max = [[max, 0].max, 40].min
      for i in 1..40
        sprite = @sprites[i]
        if sprite != nil
          sprite.visible = (i <= @max)
        end
      end
    end
    def update
      return if @type == 0
      for i in 1..@max
        sprite = @sprites[i]
        if sprite == nil
          break
        end
        if @type == 1
          sprite.x -= 2
          sprite.y += 16
          sprite.opacity -= 8
        end
        if @type == 2
          sprite.x -= 8
          sprite.y += 16
          sprite.opacity -= 12
        end
        if @type == 3
          sprite.x -= 2
          sprite.y += 8
          sprite.opacity -= 8
        end
        x = sprite.x - @ox
        y = sprite.y - @oy
        if sprite.opacity < 64 or x < -50 or x > 750 or y < -300 or y > 500
          sprite.x = rand(800) - 50 + @ox
          sprite.y = rand(800) - 200 + @oy
          sprite.opacity = 255
        end
      end
    end
    attr_reader :type
    attr_reader :max
    attr_reader :ox
    attr_reader :oy
  end
end

module RPG
  module Cache
    @cache = {}
    def self.animation(filename, hue)
      self.load_bitmap("Graphics/Animations/", filename, hue)
    end
    #def self.autotile(filename)
    #  self.load_bitmap("Graphics/Autotiles/", filename)
    #end
    def self.battleback(filename)
      self.load_bitmap("Graphics/Battlebacks/", filename)
    end
    def self.battler(filename, hue)
      self.load_bitmap("Graphics/Battlers/", filename, hue)
    end
    def self.character(filename, hue)
      self.load_bitmap("Graphics/Characters/", filename, hue)
    end
    def self.fog(filename, hue)
      self.load_bitmap("Graphics/Fogs/", filename, hue)
    end
    def self.gameover(filename)
      self.load_bitmap("Graphics/Gameovers/", filename)
    end
    def self.icon(filename)
      self.load_bitmap("Graphics/Icons/", filename)
    end
    def self.panorama(filename, hue)
      self.load_bitmap("Graphics/Panoramas/", filename, hue)
    end
    def self.picture(filename)
      self.load_bitmap("Graphics/Pictures/", filename)
    end
    def self.tileset(filename)
      self.load_bitmap("Graphics/Tilesets/", filename)
    end
    def self.title(filename)
      self.load_bitmap("Graphics/Titles/", filename)
    end
    def self.windowskin(filename)
      self.load_bitmap("Graphics/Windowskins/", filename)
    end
    def self.tile(filename, tile_id, hue)
      key = [filename, tile_id, hue]
      if not @cache.include?(key) or @cache[key].disposed?
        @cache[key] = Bitmap.new(32, 32)
        x = (tile_id - 384) % 8 * 32
        y = (tile_id - 384) / 8 * 32
        rect = Rect.new(x, y, 32, 32)
        @cache[key].blt(0, 0, self.tileset(filename), rect)
        @cache[key].hue_change(hue)
      end
      @cache[key]
    end
    def self.clear
      @cache = {}
      GC.start
    end
  end
end
module RPG
  class Map
    def initialize(width, height)
      @tileset_id = 1
      @width = width
      @height = height
      @autoplay_bgm = false
      @bgm = RPG::AudioFile.new
      @autoplay_bgs = false
      @bgs = RPG::AudioFile.new("", 80)
      @encounter_list = []
      @encounter_step = 30
      @data = Table.new(width, height, 3)
      @events = {}
    end
    attr_accessor :tileset_id
    attr_accessor :width
    attr_accessor :height
    attr_accessor :autoplay_bgm
    attr_accessor :bgm
    attr_accessor :autoplay_bgs
    attr_accessor :bgs
    attr_accessor :encounter_list
    attr_accessor :encounter_step
    attr_accessor :data
    attr_accessor :events
  end
end
module RPG
  class MapInfo
    def initialize
      @name = ""
      @parent_id = 0
      @order = 0
      @expanded = false
      @scroll_x = 0
      @scroll_y = 0
    end
    attr_accessor :name
    attr_accessor :parent_id
    attr_accessor :order
    attr_accessor :expanded
    attr_accessor :scroll_x
    attr_accessor :scroll_y
  end
end
module RPG
  class Event
    def initialize(x, y)
      @id = 0
      @name = ""
      @x = x
      @y = y
      @pages = [RPG::Event::Page.new]
    end
    attr_accessor :id
    attr_accessor :name
    attr_accessor :x
    attr_accessor :y
    attr_accessor :pages
  end
end
module RPG
  class Event
    class Page
      def initialize
        @condition = RPG::Event::Page::Condition.new
        @graphic = RPG::Event::Page::Graphic.new
        @move_type = 0
        @move_speed = 3
        @move_frequency = 3
        @move_route = RPG::MoveRoute.new
        @walk_anime = true
        @step_anime = false
        @direction_fix = false
        @through = false
        @always_on_top = false
        @trigger = 0
        @list = [RPG::EventCommand.new]
      end
      attr_accessor :condition
      attr_accessor :graphic
      attr_accessor :move_type
      attr_accessor :move_speed
      attr_accessor :move_frequency
      attr_accessor :move_route
      attr_accessor :walk_anime
      attr_accessor :step_anime
      attr_accessor :direction_fix
      attr_accessor :through
      attr_accessor :always_on_top
      attr_accessor :trigger
      attr_accessor :list
    end
  end
end
module RPG
  class Event
    class Page
      class Condition
        def initialize
          @switch1_valid = false
          @switch2_valid = false
          @variable_valid = false
          @self_switch_valid = false
          @switch1_id = 1
          @switch2_id = 1
          @variable_id = 1
          @variable_value = 0
          @self_switch_ch = "A"
        end
        attr_accessor :switch1_valid
        attr_accessor :switch2_valid
        attr_accessor :variable_valid
        attr_accessor :self_switch_valid
        attr_accessor :switch1_id
        attr_accessor :switch2_id
        attr_accessor :variable_id
        attr_accessor :variable_value
        attr_accessor :self_switch_ch
      end
    end
  end
end
module RPG
  class Event
    class Page
      class Graphic
        def initialize
          @tile_id = 0
          @character_name = ""
          @character_hue = 0
          @direction = 2
          @pattern = 0
          @opacity = 255
          @blend_type = 0
        end
        attr_accessor :tile_id
        attr_accessor :character_name
        attr_accessor :character_hue
        attr_accessor :direction
        attr_accessor :pattern
        attr_accessor :opacity
        attr_accessor :blend_type
      end
    end
  end
end
module RPG
  class EventCommand
    def initialize(code = 0, indent = 0, parameters = [])
      @code = code
      @indent = indent
      @parameters = parameters
    end
    attr_accessor :code
    attr_accessor :indent
    attr_accessor :parameters
  end
end
module RPG
  class MoveCommand
    def initialize(code = 0, parameters = [])
      @code = code
      @parameters = parameters
    end
    attr_accessor :code
    attr_accessor :parameters
  end
end
module RPG
  class MoveRoute
    def initialize
      @repeat = true
      @skippable = false
      @list = [RPG::MoveCommand.new]
    end
    attr_accessor :repeat
    attr_accessor :skippable
    attr_accessor :list
  end
end
module RPG
  class Actor
    def initialize
      @id = 0
      @name = ""
      @class_id = 1
      @initial_level = 1
      @final_level = 99
      @exp_basis = 30
      @exp_inflation = 30
      @character_name = ""
      @character_hue = 0
      @battler_name = ""
      @battler_hue = 0
      @parameters = Table.new(6,100)
      for i in 1..99
        @parameters[0,i] = 500+i*50
        @parameters[1,i] = 500+i*50
        @parameters[2,i] = 50+i*5
        @parameters[3,i] = 50+i*5
        @parameters[4,i] = 50+i*5
        @parameters[5,i] = 50+i*5
      end
      @weapon_id = 0
      @armor1_id = 0
      @armor2_id = 0
      @armor3_id = 0
      @armor4_id = 0
      @weapon_fix = false
      @armor1_fix = false
      @armor2_fix = false
      @armor3_fix = false
      @armor4_fix = false
    end
    attr_accessor :id
    attr_accessor :name
    attr_accessor :class_id
    attr_accessor :initial_level
    attr_accessor :final_level
    attr_accessor :exp_basis
    attr_accessor :exp_inflation
    attr_accessor :character_name
    attr_accessor :character_hue
    attr_accessor :battler_name
    attr_accessor :battler_hue
    attr_accessor :parameters
    attr_accessor :weapon_id
    attr_accessor :armor1_id
    attr_accessor :armor2_id
    attr_accessor :armor3_id
    attr_accessor :armor4_id
    attr_accessor :weapon_fix
    attr_accessor :armor1_fix
    attr_accessor :armor2_fix
    attr_accessor :armor3_fix
    attr_accessor :armor4_fix
  end
end
module RPG
  class Class
    def initialize
      @id = 0
      @name = ""
      @position = 0
      @weapon_set = []
      @armor_set = []
      @element_ranks = Table.new(1)
      @state_ranks = Table.new(1)
      @learnings = []
    end
    attr_accessor :id
    attr_accessor :name
    attr_accessor :position
    attr_accessor :weapon_set
    attr_accessor :armor_set
    attr_accessor :element_ranks
    attr_accessor :state_ranks
    attr_accessor :learnings
  end
end
module RPG
  class Class
    class Learning
      def initialize
        @level = 1
        @skill_id = 1
      end
      attr_accessor :level
      attr_accessor :skill_id
    end
  end
end
module RPG
  class Skill
    def initialize
      @id = 0
      @name = ""
      @icon_name = ""
      @description = ""
      @scope = 0
      @occasion = 1
      @animation1_id = 0
      @animation2_id = 0
      @menu_se = RPG::AudioFile.new("", 80)
      @common_event_id = 0
      @sp_cost = 0
      @power = 0
      @atk_f = 0
      @eva_f = 0
      @str_f = 0
      @dex_f = 0
      @agi_f = 0
      @int_f = 100
      @hit = 100
      @pdef_f = 0
      @mdef_f = 100
      @variance = 15
      @element_set = []
      @plus_state_set = []
      @minus_state_set = []
    end
    attr_accessor :id
    attr_accessor :name
    attr_accessor :icon_name
    attr_accessor :description
    attr_accessor :scope
    attr_accessor :occasion
    attr_accessor :animation1_id
    attr_accessor :animation2_id
    attr_accessor :menu_se
    attr_accessor :common_event_id
    attr_accessor :sp_cost
    attr_accessor :power
    attr_accessor :atk_f
    attr_accessor :eva_f
    attr_accessor :str_f
    attr_accessor :dex_f
    attr_accessor :agi_f
    attr_accessor :int_f
    attr_accessor :hit
    attr_accessor :pdef_f
    attr_accessor :mdef_f
    attr_accessor :variance
    attr_accessor :element_set
    attr_accessor :plus_state_set
    attr_accessor :minus_state_set
  end
end
module RPG
  class Item
    def initialize
      @id = 0
      @name = ""
      @icon_name = ""
      @description = ""
      @scope = 0
      @occasion = 0
      @animation1_id = 0
      @animation2_id = 0
      @menu_se = RPG::AudioFile.new("", 80)
      @common_event_id = 0
      @price = 0
      @consumable = true
      @parameter_type = 0
      @parameter_points = 0
      @recover_hp_rate = 0
      @recover_hp = 0
      @recover_sp_rate = 0
      @recover_sp = 0
      @hit = 100
      @pdef_f = 0
      @mdef_f = 0
      @variance = 0
      @element_set = []
      @plus_state_set = []
      @minus_state_set = []
    end
    attr_accessor :id
    attr_accessor :name
    attr_accessor :icon_name
    attr_accessor :description
    attr_accessor :scope
    attr_accessor :occasion
    attr_accessor :animation1_id
    attr_accessor :animation2_id
    attr_accessor :menu_se
    attr_accessor :common_event_id
    attr_accessor :price
    attr_accessor :consumable
    attr_accessor :parameter_type
    attr_accessor :parameter_points
    attr_accessor :recover_hp_rate
    attr_accessor :recover_hp
    attr_accessor :recover_sp_rate
    attr_accessor :recover_sp
    attr_accessor :hit
    attr_accessor :pdef_f
    attr_accessor :mdef_f
    attr_accessor :variance
    attr_accessor :element_set
    attr_accessor :plus_state_set
    attr_accessor :minus_state_set
  end
end
module RPG
  class Weapon
    def initialize
      @id = 0
      @name = ""
      @icon_name = ""
      @description = ""
      @animation1_id = 0
      @animation2_id = 0
      @price = 0
      @atk = 0
      @pdef = 0
      @mdef = 0
      @str_plus = 0
      @dex_plus = 0
      @agi_plus = 0
      @int_plus = 0
      @element_set = []
      @plus_state_set = []
      @minus_state_set = []
    end
    attr_accessor :id
    attr_accessor :name
    attr_accessor :icon_name
    attr_accessor :description
    attr_accessor :animation1_id
    attr_accessor :animation2_id
    attr_accessor :price
    attr_accessor :atk
    attr_accessor :pdef
    attr_accessor :mdef
    attr_accessor :str_plus
    attr_accessor :dex_plus
    attr_accessor :agi_plus
    attr_accessor :int_plus
    attr_accessor :element_set
    attr_accessor :plus_state_set
    attr_accessor :minus_state_set
  end
end
module RPG
  class Armor
    def initialize
      @id = 0
      @name = ""
      @icon_name = ""
      @description = ""
      @kind = 0
      @auto_state_id = 0
      @price = 0
      @pdef = 0
      @mdef = 0
      @eva = 0
      @str_plus = 0
      @dex_plus = 0
      @agi_plus = 0
      @int_plus = 0
      @guard_element_set = []
      @guard_state_set = []
    end
    attr_accessor :id
    attr_accessor :name
    attr_accessor :icon_name
    attr_accessor :description
    attr_accessor :kind
    attr_accessor :auto_state_id
    attr_accessor :price
    attr_accessor :pdef
    attr_accessor :mdef
    attr_accessor :eva
    attr_accessor :str_plus
    attr_accessor :dex_plus
    attr_accessor :agi_plus
    attr_accessor :int_plus
    attr_accessor :guard_element_set
    attr_accessor :guard_state_set
  end
end
module RPG
  class Enemy
    def initialize
      @id = 0
      @name = ""
      @battler_name = ""
      @battler_hue = 0
      @maxhp = 500
      @maxsp = 500
      @str = 50
      @dex = 50
      @agi = 50
      @int = 50
      @atk = 100
      @pdef = 100
      @mdef = 100
      @eva = 0
      @animation1_id = 0
      @animation2_id = 0
      @element_ranks = Table.new(1)
      @state_ranks = Table.new(1)
      @actions = [RPG::Enemy::Action.new]
      @exp = 0
      @gold = 0
      @item_id = 0
      @weapon_id = 0
      @armor_id = 0
      @treasure_prob = 100
    end
    attr_accessor :id
    attr_accessor :name
    attr_accessor :battler_name
    attr_accessor :battler_hue
    attr_accessor :maxhp
    attr_accessor :maxsp
    attr_accessor :str
    attr_accessor :dex
    attr_accessor :agi
    attr_accessor :int
    attr_accessor :atk
    attr_accessor :pdef
    attr_accessor :mdef
    attr_accessor :eva
    attr_accessor :animation1_id
    attr_accessor :animation2_id
    attr_accessor :element_ranks
    attr_accessor :state_ranks
    attr_accessor :actions
    attr_accessor :exp
    attr_accessor :gold
    attr_accessor :item_id
    attr_accessor :weapon_id
    attr_accessor :armor_id
    attr_accessor :treasure_prob
  end
end
module RPG
  class Enemy
    class Action
      def initialize
        @kind = 0
        @basic = 0
        @skill_id = 1
        @condition_turn_a = 0
        @condition_turn_b = 1
        @condition_hp = 100
        @condition_level = 1
        @condition_switch_id = 0
        @rating = 5
      end
      attr_accessor :kind
      attr_accessor :basic
      attr_accessor :skill_id
      attr_accessor :condition_turn_a
      attr_accessor :condition_turn_b
      attr_accessor :condition_hp
      attr_accessor :condition_level
      attr_accessor :condition_switch_id
      attr_accessor :rating
    end
  end
end
module RPG
  class Troop
    def initialize
      @id = 0
      @name = ""
      @members = []
      @pages = [RPG::BattleEventPage.new]
    end
    attr_accessor :id
    attr_accessor :name
    attr_accessor :members
    attr_accessor :pages
  end
end
module RPG
  class Troop
    class Member
      def initialize
        @enemy_id = 1
        @x = 0
        @y = 0
        @hidden = false
        @immortal = false
      end
      attr_accessor :enemy_id
      attr_accessor :x
      attr_accessor :y
      attr_accessor :hidden
      attr_accessor :immortal
    end
  end
end
module RPG
  class Troop
    class Page
      def initialize
        @condition = RPG::Troop::Page::Condition.new
        @span = 0
        @list = [RPG::EventCommand.new]
      end
      attr_accessor :condition
      attr_accessor :span
      attr_accessor :list
    end
  end
end
module RPG
  class Troop
    class Page
      class Condition
        def initialize
          @turn_valid = false
          @enemy_valid = false
          @actor_valid = false
          @switch_valid = false
          @turn_a = 0
          @turn_b = 0
          @enemy_index = 0
          @enemy_hp = 50
          @actor_id = 1
          @actor_hp = 50
          @switch_id = 1
        end
        attr_accessor :turn_valid
        attr_accessor :enemy_valid
        attr_accessor :actor_valid
        attr_accessor :switch_valid
        attr_accessor :turn_a
        attr_accessor :turn_b
        attr_accessor :enemy_index
        attr_accessor :enemy_hp
        attr_accessor :actor_id
        attr_accessor :actor_hp
        attr_accessor :switch_id
      end
    end
  end
end
module RPG
  class State
    def initialize
      @id = 0
      @name = ""
      @animation_id = 0
      @restriction = 0
      @nonresistance = false
      @zero_hp = false
      @cant_get_exp = false
      @cant_evade = false
      @slip_damage = false
      @rating = 5
      @hit_rate = 100
      @maxhp_rate = 100
      @maxsp_rate = 100
      @str_rate = 100
      @dex_rate = 100
      @agi_rate = 100
      @int_rate = 100
      @atk_rate = 100
      @pdef_rate = 100
      @mdef_rate = 100
      @eva = 0
      @battle_only = true
      @hold_turn = 0
      @auto_release_prob = 0
      @shock_release_prob = 0
      @guard_element_set = []
      @plus_state_set = []
      @minus_state_set = []
    end
    attr_accessor :id
    attr_accessor :name
    attr_accessor :animation_id
    attr_accessor :restriction
    attr_accessor :nonresistance
    attr_accessor :zero_hp
    attr_accessor :cant_get_exp
    attr_accessor :cant_evade
    attr_accessor :slip_damage
    attr_accessor :rating
    attr_accessor :hit_rate
    attr_accessor :maxhp_rate
    attr_accessor :maxsp_rate
    attr_accessor :str_rate
    attr_accessor :dex_rate
    attr_accessor :agi_rate
    attr_accessor :int_rate
    attr_accessor :atk_rate
    attr_accessor :pdef_rate
    attr_accessor :mdef_rate
    attr_accessor :eva
    attr_accessor :battle_only
    attr_accessor :hold_turn
    attr_accessor :auto_release_prob
    attr_accessor :shock_release_prob
    attr_accessor :guard_element_set
    attr_accessor :plus_state_set
    attr_accessor :minus_state_set
  end
end
module RPG
  class Animation
    def initialize
      @id = 0
      @name = ""
      @animation_name = ""
      @animation_hue = 0
      @position = 1
      @frame_max = 1
      @frames = [RPG::Animation::Frame.new]
      @timings = []
    end
    attr_accessor :id
    attr_accessor :name
    attr_accessor :animation_name
    attr_accessor :animation_hue
    attr_accessor :position
    attr_accessor :frame_max
    attr_accessor :frames
    attr_accessor :timings
  end
end
module RPG
  class Animation
    class Frame
      def initialize
        @cell_max = 0
        @cell_data = Table.new(0, 0)
      end
      attr_accessor :cell_max
      attr_accessor :cell_data
    end
  end
end
module RPG
  class Animation
    class Timing
      def initialize
        @frame = 0
        @se = RPG::AudioFile.new("", 80)
        @flash_scope = 0
        @flash_color = Color.new(255,255,255,255)
        @flash_duration = 5
        @condition = 0
      end
      attr_accessor :frame
      attr_accessor :se
      attr_accessor :flash_scope
      attr_accessor :flash_color
      attr_accessor :flash_duration
      attr_accessor :condition
    end
  end
end
module RPG
  class Tileset
    def initialize
      @id = 0
      @name = ""
      @tileset_name = ""
      @autotile_names = [""]*7
      @panorama_name = ""
      @panorama_hue = 0
      @fog_name = ""
      @fog_hue = 0
      @fog_opacity = 64
      @fog_blend_type = 0
      @fog_zoom = 200
      @fog_sx = 0
      @fog_sy = 0
      @battleback_name = ""
      @passages = Table.new(384)
      @priorities = Table.new(384)
      @priorities[0] = 5
      @terrain_tags = Table.new(384)
    end
    attr_accessor :id
    attr_accessor :name
    attr_accessor :tileset_name
    attr_accessor :autotile_names
    attr_accessor :panorama_name
    attr_accessor :panorama_hue
    attr_accessor :fog_name
    attr_accessor :fog_hue
    attr_accessor :fog_opacity
    attr_accessor :fog_blend_type
    attr_accessor :fog_zoom
    attr_accessor :fog_sx
    attr_accessor :fog_sy
    attr_accessor :battleback_name
    attr_accessor :passages
    attr_accessor :priorities
    attr_accessor :terrain_tags
  end
end
module RPG
  class CommonEvent
    def initialize
      @id = 0
      @name = ""
      @trigger = 0
      @switch_id = 1
      @list = [RPG::EventCommand.new]
    end
    attr_accessor :id
    attr_accessor :name
    attr_accessor :trigger
    attr_accessor :switch_id
    attr_accessor :list
  end
end
module RPG
  class System
    def initialize
      @magic_number = 0
      @party_members = [1]
      @elements = [nil, ""]
      @switches = [nil, ""]
      @variables = [nil, ""]
      @windowskin_name = ""
      @title_name = ""
      @gameover_name = ""
      @battle_transition = ""
      @title_bgm = RPG::AudioFile.new
      @battle_bgm = RPG::AudioFile.new
      @battle_end_me = RPG::AudioFile.new
      @gameover_me = RPG::AudioFile.new
      @cursor_se = RPG::AudioFile.new("", 80)
      @decision_se = RPG::AudioFile.new("", 80)
      @cancel_se = RPG::AudioFile.new("", 80)
      @buzzer_se = RPG::AudioFile.new("", 80)
      @equip_se = RPG::AudioFile.new("", 80)
      @shop_se = RPG::AudioFile.new("", 80)
      @save_se = RPG::AudioFile.new("", 80)
      @load_se = RPG::AudioFile.new("", 80)
      @battle_start_se = RPG::AudioFile.new("", 80)
      @escape_se = RPG::AudioFile.new("", 80)
      @actor_collapse_se = RPG::AudioFile.new("", 80)
      @enemy_collapse_se = RPG::AudioFile.new("", 80)
      @words = RPG::System::Words.new
      @test_battlers = []
      @test_troop_id = 1
      @start_map_id = 1
      @start_x = 0
      @start_y = 0
      @battleback_name = ""
      @battler_name = ""
      @battler_hue = 0
      @edit_map_id = 1
    end
    attr_accessor :magic_number
    attr_accessor :party_members
    attr_accessor :elements
    attr_accessor :switches
    attr_accessor :variables
    attr_accessor :windowskin_name
    attr_accessor :title_name
    attr_accessor :gameover_name
    attr_accessor :battle_transition
    attr_accessor :title_bgm
    attr_accessor :battle_bgm
    attr_accessor :battle_end_me
    attr_accessor :gameover_me
    attr_accessor :cursor_se
    attr_accessor :decision_se
    attr_accessor :cancel_se
    attr_accessor :buzzer_se
    attr_accessor :equip_se
    attr_accessor :shop_se
    attr_accessor :save_se
    attr_accessor :load_se
    attr_accessor :battle_start_se
    attr_accessor :escape_se
    attr_accessor :actor_collapse_se
    attr_accessor :enemy_collapse_se
    attr_accessor :words
    attr_accessor :test_battlers
    attr_accessor :test_troop_id
    attr_accessor :start_map_id
    attr_accessor :start_x
    attr_accessor :start_y
    attr_accessor :battleback_name
    attr_accessor :battler_name
    attr_accessor :battler_hue
    attr_accessor :edit_map_id
  end
end
module RPG
  class System
    class Words
      def initialize
        @gold = ""
        @hp = ""
        @sp = ""
        @str = ""
        @dex = ""
        @agi = ""
        @int = ""
        @atk = ""
        @pdef = ""
        @mdef = ""
        @weapon = ""
        @armor1 = ""
        @armor2 = ""
        @armor3 = ""
        @armor4 = ""
        @attack = ""
        @skill = ""
        @guard = ""
        @item = ""
        @equip = ""
      end
      attr_accessor :gold
      attr_accessor :hp
      attr_accessor :sp
      attr_accessor :str
      attr_accessor :dex
      attr_accessor :agi
      attr_accessor :int
      attr_accessor :atk
      attr_accessor :pdef
      attr_accessor :mdef
      attr_accessor :weapon
      attr_accessor :armor1
      attr_accessor :armor2
      attr_accessor :armor3
      attr_accessor :armor4
      attr_accessor :attack
      attr_accessor :skill
      attr_accessor :guard
      attr_accessor :item
      attr_accessor :equip
    end
  end
end

module RPG
  class System
    class TestBattler
      def initialize
        @actor_id = 1
        @level = 1
        @weapon_id = 0
        @armor1_id = 0
        @armor2_id = 0
        @armor3_id = 0
        @armor4_id = 0
      end
      attr_accessor :actor_id
      attr_accessor :level
      attr_accessor :weapon_id
      attr_accessor :armor1_id
      attr_accessor :armor2_id
      attr_accessor :armor3_id
      attr_accessor :armor4_id
    end
  end
end

module RPG
  class AudioFile
    def initialize(name = "", volume = 100, pitch = 100)
      @name = name
      @volume = volume
      @pitch = pitch
    end
    attr_accessor :name
    attr_accessor :volume
    attr_accessor :pitch
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ Game
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com)
# Date      2015. 1. 8
#────────────────────────────────────────────────────────────────────────────

module Game
  module_function
  def init
    @item = []
    @skill = []
    @title = []
    @gameScreen = Screen.new
    @gameSystem = System.new
    @gamePlayer = Player.new
    @gameMap = Map.new
    @slot = Slot.new
    @cooltime = Cooltime.new
    Damage.loadCache
  end
  
  def screen
    return @gameScreen
  end
  
  def system
    return @gameSystem
  end
  
  def player
    return @gamePlayer
  end
  
  def map
    return @gameMap
  end
  
  def slot
    return @slot
  end
  
  def cooltime
    return @cooltime
  end
  
  def load
    loadItem
    loadSkill
  end

  def loadItem
    file = File.open("./GameData/item.txt")
    itemList = file.read.split("\n")
    for item in itemList
      next if item == "" || item == nil
      data = item.split("|")
      @item[data[0].to_i] = ItemData.new(data)
    end
  end

  def loadSkill
    file = File.open("./GameData/skill.txt")
    skillList = file.read.split("\n")
    for skill in skillList
      next if skill == "" || skill == nil
      data = skill.split("|")
      @skill[data[0].to_i] = SkillData.new(data)
    end
  end
  
  def getItem(id)
    return @item[id]
  end
  
  def getSkill(id)
    return @skill[id]
  end
  
  def getTitle(id)
    return "" if not @title.include?(id)
    return @title[id]
  end
      
  def getJob(n)
    case n
    when 0
      return "공용"
    when 1
      return "전사"
    when 2
      return "마법사"
    when 3
      return "도적"
    else
      return "시민"
    end
  end
  
  module CharacterType
    USER = 0
    NPC = 1
    ENEMY = 2
  end
  
  module ItemType
    WEAPON = 0
    SHIELD = 1
		HELMET = 2
		ARMOR = 3
		CAPE = 4
		SHOES = 5
		ACCESSORY = 6
		ITEM = 7
  end
  
  def getItemType(type)
    case type
    when ItemType::WEAPON
      return "무기"
    when ItemType::SHIELD
      return "방패"
    when ItemType::HELMET
      return "투구"
    when ItemType::ARMOR
      return "갑옷"
    when ItemType::CAPE
      return "망토"
    when ItemType::SHOES
      return "신발"
    when ItemType::ACCESSORY
      return "보조"
    when ItemType::ITEM
      return "일반"
    end
  end
  
  module StatusType
		TITLE = 0
		IMAGE = 1
		JOB = 2
		STR = 3
		DEX = 4
		AGI = 5
		CRITICAL = 6
		AVOID = 7
		HIT = 8
		STAT_POINT = 9
		SKILL_POINT = 10
		HP = 11
		MAX_HP = 12
		MP = 13
		MAX_MP = 14
		LEVEL = 15
		EXP = 16
		MAX_EXP = 17
    GOLD = 18
    WEAPON = 19
    SHIELD = 20
    HELMET = 21
    ARMOR = 22
    CAPE = 23
    SHOES = 24
    ACCESSORY = 25
  end
  
  def getStatus(n)
    case n
    when StatusType::TITLE
      return "타이틀"
    when StatusType::IMAGE
      return "이미지"
    when StatusType::JOB
      return "직업"
    when StatusType::STR
      return "힘"
    when StatusType::DEX
      return "민첩"
    when StatusType::AGI
      return "지능"
    when StatusType::CRITICAL
      return "크리티컬"
    when StatusType::AVOID
      return "회피율"
    when StatusType::HIT
      return "명중률"
    when StatusType::STAT_POINT
      return "스텟 포인트"
    when StatusType::SKILL_POINT
      return "스킬 포인트"
    when StatusType::HP
      return "체력"
    when StatusType::MAX_HP
      return "최대 체력"
    when StatusType::MP
      return "마력"
    when StatusType::MAX_MP
      return "최대 마력"
    when StatusType::LEVEL
      return "레벨"
    when StatusType::EXP
      return "경험치"
    when StatusType::MAX_EXP
      return "최대 경험치"
    when StatusType::GOLD
      return "골드"
    when StatusType::WEAPON
      return "무기"
    when StatusType::SHIELD
      return "방패"
    when StatusType::HELMET
      return "투구"
    when StatusType::ARMOR
      return "갑옷"
    when StatusType::CAPE
      return "망토"
    when StatusType::SHOES
      return "신발"
    when StatusType::ACCESSORY
      return "보조"
    end
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ Objects
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com)
# Date      2015. 1. 9
#────────────────────────────────────────────────────────────────────────────

class ItemData
  attr_accessor :no
  attr_accessor :name
  attr_accessor :description
  attr_accessor :image
  attr_accessor :job
  attr_accessor :limitLevel
  attr_accessor :type
  attr_accessor :price
  attr_accessor :damage
  attr_accessor :magicDamage
  attr_accessor :defense
  attr_accessor :magicDefense
  attr_accessor :str
  attr_accessor :dex
  attr_accessor :agi
  attr_accessor :hp
  attr_accessor :mp
  attr_accessor :critical
  attr_accessor :avoid
  attr_accessor :hit
  attr_accessor :delay
  attr_accessor :consume
  attr_accessor :maxLoad
  attr_accessor :trade
  
  def initialize(list)
    @no = list[0].to_i#list[0] == "1" ? 1 : list[0].to_i
    @name = list[1].to_s
    @description = list[2].to_s
    @image = list[3].to_s
    @job = list[4].to_i
    @limitLevel = list[5].to_i
    @type = list[6].to_i
    @price = list[7].to_i
    @damage = list[8].to_i
    @magicDamage = list[9].to_i
    @defense = list[10].to_i
    @magicDefense = list[11].to_i
    @str = list[12].to_i
    @dex = list[13].to_i
    @agi = list[14].to_i
    @hp = list[15].to_i
    @mp = list[16].to_i
    @critical = list[17].to_i
    @avoid = list[18].to_i
    @hit = list[19].to_i
    @delay = list[20].to_i
    @consume = list[21].to_i
    @maxLoad = list[22].to_i
    @trade = list[23].to_i
  end
end

class Item
  attr_accessor :itemNo
  attr_accessor :amount
  attr_accessor :index
  attr_accessor :damage
  attr_accessor :magicDamage
  attr_accessor :defense
  attr_accessor :magicDefense
  attr_accessor :str
  attr_accessor :dex
  attr_accessor :agi
  attr_accessor :hp
  attr_accessor :mp
  attr_accessor :critical
  attr_accessor :avoid
  attr_accessor :hit
  attr_accessor :reinforce
  attr_accessor :trade
  attr_accessor :equipped
  
  def initialize(userNo, itemNo, amount, index, damage, magicDamage,
                defense, magicDefense, str, dex, agi, hp, mp, critical,
                avoid, hit, reinforce, trade, equipped)
    @userNo = userNo
		@itemNo = itemNo
		@amount = amount
    @index = index
    @damage = damage
    @magicDamage = magicDamage
    @defense = defense
    @magicDefense = magicDefense
    @str = str
    @dex = dex
    @agi = agi
    @hp = hp
    @mp = mp
    @critical = critical
    @avoid = avoid
    @hit = hit
    @reinforce = reinforce
    @trade = trade == 1
    @equipped = equipped == 1
  end
end

class SkillData
  attr_accessor :no
  attr_accessor :name
  attr_accessor :description
  attr_accessor :type
  attr_accessor :job
  attr_accessor :delay
  attr_accessor :limitLevel
  attr_accessor :maxRank
  attr_accessor :userAnimation
  attr_accessor :targetAnimation
  attr_accessor :image
  
  def initialize(list)
    @no = list[0].to_i
    @name = list[1].to_s
    @description = list[2].to_s
    @type = list[3].to_s
    @job = list[4].to_i
    @delay = list[5].to_i
    @limitLevel = list[6].to_i
    @maxRank = list[7].to_s
    @userAnimation = list[8].to_s
    @targetAnimation = list[9].to_s
    @image = list[10].to_s
  end
end

class Skill
  attr_accessor :no
  attr_accessor :rank
  
  def initialize(no, rank)
    @no = no
    @rank = rank
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ System
# --------------------------------------------------------------------------
# Author    EnterBrain
# Modify    뮤 (mu29gl@gmail.com)
# Date      2015. 1. 7
#────────────────────────────────────────────────────────────────────────────
class System
  
  include Config
  
  attr_accessor :timer
  attr_accessor :timer_working
  attr_accessor :optKey
  
  def initialize
    @timer = 0
    @timer_working = false
    # 옵션 키
    @optKey = {}
    @optKey[:fullscreen] = self.fullscreen_load
    @optKey[:bgm]        = self.bgm_load
    @optKey[:bgs]        = self.bgs_load
    @optKey[:me]         = self.me_load
    @optKey[:se]         = self.se_load
  end

  def fullscreen_load
    File.iniGet(OPTION_PATH, OPTION_KEY, "fullscreen", false, 10)
  end
  
  def fullscreen_save(value)
    File.iniWrite(OPTION_PATH, OPTION_KEY, "fullscreen", value)
    @optKey[:fullscreen] = value
  end
  
  def bgm_load
    File.iniGet(OPTION_PATH, OPTION_KEY, "bgm", 100, 6)
  end
  
  def bgm_save(volume)
    File.iniWrite(OPTION_PATH, OPTION_KEY, "bgm", volume)
    @optKey[:bgm] = volume
    bgm_play(@playing_bgm)
  end
  
  def bgs_load
    File.iniGet(OPTION_PATH, OPTION_KEY, "bgs", 100, 6)
  end
  
  def bgs_save(volume)
    File.iniWrite(OPTION_PATH, OPTION_KEY, "bgs", volume)
    @optKey[:bgs] = volume
    bgs_play(@playing_bgs)
  end
  
  def me_load
    File.iniGet(OPTION_PATH, OPTION_KEY, "me", 100, 6)
  end
  
  def me_save(volume)
    File.iniWrite(OPTION_PATH, OPTION_KEY, "me", volume)
    @optKey[:me] = volume
  end
  
  def se_load
    File.iniGet(OPTION_PATH, OPTION_KEY, "se", 100, 6)
  end
  
  def se_save(volume)
    File.iniWrite(OPTION_PATH, OPTION_KEY, "se", volume)
    @optKey[:se] = volume
  end

  def bgm_play(bgm)
    @playing_bgm = bgm
    if bgm != nil and bgm.name != ""
      Audio.bgm_play("Audio/BGM/" + bgm.name, @optKey[:bgm], bgm.pitch)
    else
      Audio.bgm_stop
    end
    Graphics.frame_reset
  end

  def bgm_stop
    Audio.bgm_stop
  end

  def bgm_fade(time)
    @playing_bgm = nil
    Audio.bgm_fade(time * 1000)
  end

  def bgm_memorize
    @memorized_bgm = @playing_bgm
  end

  def bgm_restore
    bgm_play(@memorized_bgm)
  end

  def bgs_play(bgs)
    @playing_bgs = bgs
    if bgs != nil and bgs.name != ""
      Audio.bgs_play("Audio/BGS/" + bgs.name, @optKey[:bgs], bgs.pitch)
    else
      Audio.bgs_stop
    end
    Graphics.frame_reset
  end

  def bgs_fade(time)
    @playing_bgs = nil
    Audio.bgs_fade(time * 1000)
  end

  def bgs_memorize
    @memorized_bgs = @playing_bgs
  end

  def bgs_restore
    bgs_play(@memorized_bgs)
  end

  def me_play(me)
    if me != nil and me.name != ""
      Audio.me_play("Audio/ME/" + me.name, @optKey[:me], me.pitch)
    else
      Audio.me_stop
    end
    Graphics.frame_reset
  end

  def se_play(se)
    if se != nil and se.name != ""
      Audio.se_play("Audio/SE/" + se.name, @optKey[:se], se.pitch)
    end
  end

  def se_stop
    Audio.se_stop
  end

  def playing_bgm
    return @playing_bgm
  end

  def playing_bgs
    return @playing_bgs
  end

  def update
    if @timer_working and @timer > 0
      @timer -= 1
    end
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ Screen
# --------------------------------------------------------------------------
# Author    EnterBrain
# Modify    뮤 (mu29gl@gmail.com)
# Date      2015. 1. 7
#────────────────────────────────────────────────────────────────────────────
class Screen
  attr_reader   :tone                     # 색조
  attr_reader   :flash_color              # 플래시색
  attr_reader   :shake                    # 시이크 위치
  attr_reader   :pictures                 # 픽쳐
  attr_reader   :weather_type             # 기후 타입
  attr_reader   :weather_max              # 기후 화상의 최대수
  attr_accessor :transition_processing    # 트란지션 처리중 플래그
  attr_accessor :transition_name          # 트란지션 파일

  def initialize
    @tone = Tone.new(0, 0, 0, 0)
    @tone_target = Tone.new(0, 0, 0, 0)
    @tone_duration = 0
    @flash_color = Color.new(0, 0, 0, 0)
    @flash_duration = 0
    @shake_power = 0
    @shake_speed = 0
    @shake_duration = 0
    @shake_direction = 1
    @shake = 0
    @weather_type = 0
    @weather_max = 0.0
    @weather_type_target = 0
    @weather_max_target = 0.0
    @weather_duration = 0
    @transition_processing = false
    @transition_name = "001-Blind01"
  end

  def start_tone_change(tone, duration)
    @tone_target = tone.clone
    @tone_duration = duration
    if @tone_duration == 0
      @tone = @tone_target.clone
    end
  end

  def start_flash(color, duration)
    @flash_color = color.clone
    @flash_duration = duration
  end

  def start_shake(power, speed, duration)
    @shake_power = power
    @shake_speed = speed
    @shake_duration = duration
  end

  def weather(type, power, duration)
    @weather_type_target = type
    if @weather_type_target != 0
      @weather_type = @weather_type_target
    end
    if @weather_type_target == 0
      @weather_max_target = 0.0
    else
      @weather_max_target = (power + 1) * 4.0
    end
    @weather_duration = duration
    if @weather_duration == 0
      @weather_type = @weather_type_target
      @weather_max = @weather_max_target
    end
  end

  def update
    if @tone_duration >= 1
      d = @tone_duration
      @tone.red = (@tone.red * (d - 1) + @tone_target.red) / d
      @tone.green = (@tone.green * (d - 1) + @tone_target.green) / d
      @tone.blue = (@tone.blue * (d - 1) + @tone_target.blue) / d
      @tone.gray = (@tone.gray * (d - 1) + @tone_target.gray) / d
      @tone_duration -= 1
    end
    if @flash_duration >= 1
      d = @flash_duration
      @flash_color.alpha = @flash_color.alpha * (d - 1) / d
      @flash_duration -= 1
    end
    if @shake_duration >= 1 or @shake != 0
      delta = (@shake_power * @shake_speed * @shake_direction) / 10.0
      if @shake_duration <= 1 and @shake * (@shake + delta) < 0
        @shake = 0
      else
        @shake += delta
      end
      if @shake > @shake_power * 2
        @shake_direction = -1
      end
      if @shake < - @shake_power * 2
        @shake_direction = 1
      end
      if @shake_duration >= 1
        @shake_duration -= 1
      end
    end
    if @weather_duration >= 1
      d = @weather_duration
      @weather_max = (@weather_max * (d - 1) + @weather_max_target) / d
      @weather_duration -= 1
      if @weather_duration == 0
        @weather_type = @weather_type_target
      end
    end
  end
end

#────────────────────────────────────────────────────────────────────────────
# ▶ Map
# --------------------------------------------------------------------------
# Author    EnterBrain
# Modify    뮤 (mu29gl@gmail.com)
# Date      2015. 1. 7
#────────────────────────────────────────────────────────────────────────────
class Map
  attr_accessor :tileset_name             # 타일 세트 파일명
  attr_accessor :autotile_names           # 오토 타일 파일명
  attr_accessor :panorama_name            # 파노라마 파일명
  attr_accessor :panorama_hue             # 파노라마 색상
  attr_accessor :fog_name                 # 포그 파일명
  attr_accessor :fog_hue                  # 포그 색상
  attr_accessor :fog_opacity              # 포그 불투명도
  attr_accessor :fog_blend_type           # 포그 브랜드 방법
  attr_accessor :fog_zoom                 # 포그 확대율
  attr_accessor :fog_sx                   # 포그 SX
  attr_accessor :fog_sy                   # 포그 SY
  attr_accessor :battleback_name          # 배틀 백 파일명
  attr_accessor :display_x                # 표시 X 좌표 * 128
  attr_accessor :display_y                # 표시 Y 좌표 * 128
  attr_accessor :need_refresh             # 리프레쉬 요구 플래그
  attr_reader   :passages                 # 통행 테이블
  attr_reader   :priorities               # priority 테이블
  attr_reader   :terrain_tags             # 지형 태그 테이블
  attr_reader   :fog_ox                   # 포그 원점 X 좌표
  attr_reader   :fog_oy                   # 포그 원점 Y 좌표
  attr_reader   :fog_tone                 # 포그 색조
  attr_reader   :events                   # 이벤트
  attr_reader   :netplayers               # 넷플레이어
  attr_reader   :npcs                     # NPC
  attr_reader   :enemies                   # 에너미

  def initialize
    @map_id = 0
    @display_x = 0
    @display_y = 0
  end

  def setup(map_id)
    @map_id = map_id
    @map = load_data(sprintf("Data/Map%03d.rxdata", @map_id))
    tileset = $data_tilesets[@map.tileset_id]
    @tileset_name = tileset.tileset_name
    @autotile_names = tileset.autotile_names
    @panorama_name = tileset.panorama_name
    @panorama_hue = tileset.panorama_hue
    @fog_name = tileset.fog_name
    @fog_hue = tileset.fog_hue
    @fog_opacity = tileset.fog_opacity
    @fog_blend_type = tileset.fog_blend_type
    @fog_zoom = tileset.fog_zoom
    @fog_sx = tileset.fog_sx
    @fog_sy = tileset.fog_sy
    @battleback_name = tileset.battleback_name
    @passages = tileset.passages
    @priorities = tileset.priorities
    @terrain_tags = tileset.terrain_tags
    @display_x = 0
    @display_y = 0
    @need_refresh = false
    @events = {}
    for i in @map.events.keys
      @events[i] = Event.new(@map_id, @map.events[i])
    end
    @netplayers = {}
    @npcs = {}
    @enemies = {}
    @items = {}
    @fog_ox = 0
    @fog_oy = 0
    @fog_tone = Tone.new(0, 0, 0, 0)
    @fog_tone_target = Tone.new(0, 0, 0, 0)
    @fog_tone_duration = 0
    @fog_opacity_duration = 0
    @fog_opacity_target = 0
    @scroll_direction = 2
    @scroll_rest = 0
    @scroll_speed = 4
  end

  def map_id
    return @map_id
  end

  def width
    return @map.width
  end

  def height
    return @map.height
  end

  def data
    return @map.data
  end

  def autoplay
    if @map.autoplay_bgm
      Game.system.bgm_play(@map.bgm)
    end
    if @map.autoplay_bgs
      Game.system.bgs_play(@map.bgs)
    end
  end

  def refresh
    if @map_id > 0
      for netplayer in @netplayers.values
        netplayer.refresh
      end
      for npc in @npcs.values
        npc.refresh
      end
      for enemy in @enemies.values
        enemy.refresh
      end
      for event in @events.values
        event.refresh
      end
    end
    @need_refresh = false
  end

  def scroll_down(distance)
    @display_y = [@display_y + distance, (self.height - 15) * 128].min
  end

  def scroll_left(distance)
    @display_x = [@display_x - distance, 0].max
  end

  def scroll_right(distance)
    @display_x = [@display_x + distance, (self.width - 20) * 128].min
  end

  def scroll_up(distance)
    @display_y = [@display_y - distance, 0].max
  end

  def valid?(x, y)
    return (x >= 0 and x < width and y >= 0 and y < height)
  end

  def passable?(x, y, d, self_event = nil)
    unless valid?(x, y)
      return false
    end
    bit = (1 << (d / 2 - 1)) & 0x0f
    for event in events.values
      if event.tile_id >= 0 and event != self_event and
         event.x == x and event.y == y and not event.through
        if @passages[event.tile_id] & bit != 0
          return false
        elsif @passages[event.tile_id] & 0x0f == 0x0f
          return false
        elsif @priorities[event.tile_id] == 0
          return true
        end
      end
    end
    for i in [2, 1, 0]
      tile_id = data[x, y, i]
      if tile_id == nil
        return false
      elsif @passages[tile_id] & bit != 0
        return false
      elsif @passages[tile_id] & 0x0f == 0x0f
        return false
      elsif @priorities[tile_id] == 0
        return true
      end
    end
    return true
  end

  def bush?(x, y)
    if @map_id != 0
      for i in [2, 1, 0]
        tile_id = data[x, y, i]
        if tile_id == nil
          return false
        elsif @passages[tile_id] & 0x40 == 0x40
          return true
        end
      end
    end
    return false
  end

  def counter?(x, y)
    if @map_id != 0
      for i in [2, 1, 0]
        tile_id = data[x, y, i]
        if tile_id == nil
          return false
        elsif @passages[tile_id] & 0x80 == 0x80
          return true
        end
      end
    end
    return false
  end

  def terrain_tag(x, y)
    if @map_id != 0
      for i in [2, 1, 0]
        tile_id = data[x, y, i]
        if tile_id == nil
          return 0
        elsif @terrain_tags[tile_id] > 0
          return @terrain_tags[tile_id]
        end
      end
    end
    return 0
  end

  def check_event(x, y)
    for event in Game.map.events.values
      if event.x == x and event.y == y
        return event.id
      end
    end
  end

  def start_scroll(direction, distance, speed)
    @scroll_direction = direction
    @scroll_rest = distance * 128
    @scroll_speed = speed
  end

  def scrolling?
    return @scroll_rest > 0
  end

  def start_fog_tone_change(tone, duration)
    @fog_tone_target = tone.clone
    @fog_tone_duration = duration
    if @fog_tone_duration == 0
      @fog_tone = @fog_tone_target.clone
    end
  end

  def start_fog_opacity_change(opacity, duration)
    @fog_opacity_target = opacity * 1.0
    @fog_opacity_duration = duration
    if @fog_opacity_duration == 0
      @fog_opacity = @fog_opacity_target
    end
  end
  
  def addNetplayer(id, netplayer)
    return if @netplayers.has_key?(id)
    @netplayers[id] = netplayer
    return @netplayers[id]
  end
  
  def getNetplayer(id)
    return @netplayers[id]
  end
  
  def removeNetplayer(id)
    return if not @netplayers.has_key?(id)
    @netplayers.delete(id)
  end
  
  def addNPC(id, npc)
    return if @npcs.has_key?(id)
    @npcs[id] = npc
    return @npcs[id]
  end
  
  def getNPC(id)
    return @npcs[id]
  end
  
  def removeNPC(id)
    return if not @npcs.has_key?(id)
    @npcs.delete(id)
  end
  
  def addEnemy(id, enemy)
    return if @enemies.has_key?(id)
    @enemies[id] = enemy
    return @enemies[id]
  end
  
  def getEnemy(id)
    return @enemies[id]
  end
  
  def removeEnemy(id)
    return if not @enemies.has_key?(id)
    @enemies.delete(id)
  end
  
  def addItem(id, item)
    return if @items.has_key?(id)
    @items[id] = item
    return @items[id]
  end
  
  def getItem(id)
    return @items[id]
  end
  
  def removeItem(id)
    return if not @items.has_key?(id)
    @items.delete(id)
  end

  def update
    if Game.map.need_refresh
      refresh
    end
    if @scroll_rest > 0
      distance = 2 ** @scroll_speed
      case @scroll_direction
      when 2  # 하
        scroll_down(distance)
      when 4  # 왼쪽
        scroll_left(distance)
      when 6  # 오른쪽
        scroll_right(distance)
      when 8  # 상
        scroll_up(distance)
      end
      @scroll_rest -= distance
    end
    for netplayer in @netplayers.values
      netplayer.update
    end
    for npc in @npcs.values
      npc.update
    end
    for enemy in @enemies.values
      enemy.update
    end
    for event in @events.values
      event.update
    end
    @fog_ox -= @fog_sx / 8.0
    @fog_oy -= @fog_sy / 8.0
    if @fog_tone_duration >= 1
      d = @fog_tone_duration
      target = @fog_tone_target
      @fog_tone.red = (@fog_tone.red * (d - 1) + target.red) / d
      @fog_tone.green = (@fog_tone.green * (d - 1) + target.green) / d
      @fog_tone.blue = (@fog_tone.blue * (d - 1) + target.blue) / d
      @fog_tone.gray = (@fog_tone.gray * (d - 1) + target.gray) / d
      @fog_tone_duration -= 1
    end
    if @fog_opacity_duration >= 1
      d = @fog_opacity_duration
      @fog_opacity = (@fog_opacity * (d - 1) + @fog_opacity_target) / d
      @fog_opacity_duration -= 1
    end
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ MapSprite
# --------------------------------------------------------------------------
# Author    EnterBrain
# Modify    뮤 (mu29gl@gmail.com)
# Date      2015. 1. 7
#────────────────────────────────────────────────────────────────────────────
class MapSprite
  def initialize
    @viewport1 = Viewport.new(0, 0, 640, 480)
    @viewport2 = Viewport.new(0, 0, 640, 480)
    @viewport3 = Viewport.new(0, 0, 640, 480)
    @viewport2.z = 200
    @viewport3.z = 5000
    @tilemap = Tilemap.new(@viewport1)
    @tilemap.tileset = RPG::Cache.tileset(Game.map.tileset_name)
    for i in 0..6
      autotile_name = Game.map.autotile_names[i]
      @tilemap.autotiles[i] = RPG::Cache.autotile(autotile_name)
    end
    @tilemap.map_data = Game.map.data
    @tilemap.priorities = Game.map.priorities
    @panorama = Plane.new(@viewport1)
    @panorama.z = -1000
    @fog = Plane.new(@viewport1)
    @fog.z = 3000
    @character_sprites = []
    for i in Game.map.events.keys.sort
      sprite = CharacterSprite.new(@viewport1, Game.map.events[i])
      @character_sprites.push(sprite)
    end
    @character_sprites.push(CharacterSprite.new(@viewport1, Game.player))
    @weather = RPG::Weather.new(@viewport1)
    @timer_sprite = Timer.new
    update
  end

  def dispose
    @tilemap.tileset.dispose
    for i in 0..6
      @tilemap.autotiles[i].dispose
    end
    @tilemap.dispose
    @panorama.dispose
    @fog.dispose
    for sprite in @character_sprites
      sprite.dispose
    end
    @weather.dispose
    @timer_sprite.dispose
    @viewport1.dispose
    @viewport2.dispose
    @viewport3.dispose
  end

  def update
    if @panorama_name != Game.map.panorama_name or
       @panorama_hue != Game.map.panorama_hue
      @panorama_name = Game.map.panorama_name
      @panorama_hue = Game.map.panorama_hue
      if @panorama.bitmap != nil
        @panorama.bitmap.dispose
        @panorama.bitmap = nil
      end
      if @panorama_name != ""
        @panorama.bitmap = RPG::Cache.panorama(@panorama_name, @panorama_hue)
      end
      Graphics.frame_reset
    end
    if @fog_name != Game.map.fog_name or @fog_hue != Game.map.fog_hue
      @fog_name = Game.map.fog_name
      @fog_hue = Game.map.fog_hue
      if @fog.bitmap != nil
        @fog.bitmap.dispose
        @fog.bitmap = nil
      end
      if @fog_name != ""
        @fog.bitmap = RPG::Cache.fog(@fog_name, @fog_hue)
      end
      Graphics.frame_reset
    end
    @tilemap.ox = Game.map.display_x / 4
    @tilemap.oy = Game.map.display_y / 4
    @tilemap.update
    @panorama.ox = Game.map.display_x / 8
    @panorama.oy = Game.map.display_y / 8
    @fog.zoom_x = Game.map.fog_zoom / 100.0
    @fog.zoom_y = Game.map.fog_zoom / 100.0
    @fog.opacity = Game.map.fog_opacity
    @fog.blend_type = Game.map.fog_blend_type
    @fog.ox = Game.map.display_x / 4 + Game.map.fog_ox
    @fog.oy = Game.map.display_y / 4 + Game.map.fog_oy
    @fog.tone = Game.map.fog_tone
    for sprite in @character_sprites
      sprite.update
      if sprite.erase > 255
        sprite.dispose
        @character_sprites.delete(sprite)
      end
    end
    @weather.type = Game.screen.weather_type
    @weather.max = Game.screen.weather_max
    @weather.ox = Game.map.display_x / 4
    @weather.oy = Game.map.display_y / 4
    @weather.update
    @timer_sprite.update
    @viewport1.tone = Game.screen.tone
    @viewport1.ox = Game.screen.shake
    @viewport3.color = Game.screen.flash_color
    @viewport1.update
    @viewport3.update
  end
end

#────────────────────────────────────────────────────────────────────────────
# ▶ Character
# --------------------------------------------------------------------------
# Author    EnterBrain
# Modify    뮤 (mu29gl@gmail.com)
# Date      2015. 1. 7
#────────────────────────────────────────────────────────────────────────────
class Character
  attr_reader   :id                       # ID
  attr_reader   :x                        # 맵 X 좌표 (논리 좌표)
  attr_reader   :y                        # 맵 Y 좌표 (논리 좌표)
  attr_reader   :real_x                   # 맵 X 좌표 (실좌표 * 128)
  attr_reader   :real_y                   # 맵 Y 좌표 (실좌표 * 128)
  attr_reader   :tile_id                  # 타일 ID  (0 이라면 무효)
  attr_reader   :character_name           # 캐릭터 파일명
  attr_reader   :character_hue            # 캐릭터 색상
  attr_reader   :opacity                  # 불투명도
  attr_reader   :blend_type               # 합성 방법
  attr_reader   :direction                # 방향
  attr_reader   :pattern                  # 패턴
  attr_reader   :through                  # 통행 가능
  attr_accessor :animation_id             # 애니메이션 ID
  attr_accessor :transparent              # 투명상태
  attr_accessor :move_speed
  attr_accessor :damages
  attr_accessor :isIcon

  def initialize
    @id = 0
    @x = 0
    @y = 0
    @real_x = 0
    @real_y = 0
    @tile_id = 0
    @character_name = ""
    @character_hue = 0
    @opacity = 255
    @blend_type = 0
    @direction = 2
    @pattern = 0
    @through = false
    @animation_id = 0
    @transparent = false
    @original_direction = 2
    @original_pattern = 0
    @move_type = 0
    @move_speed = 4
    @move_frequency = 6
    @move_route = nil
    @move_route_index = 0
    @original_move_route = nil
    @original_move_route_index = 0
    @walk_anime = true
    @step_anime = false
    @direction_fix = false
    @always_on_top = false
    @anime_count = 0
    @stop_count = 0
    @jump_count = 0
    @jump_peak = 0
    @wait_count = 0
    @locked = false
    @prelock_direction = 0
    @damages = []
    @isIcon = false
  end
  
  def setGraphic(character_name, character_hue)
    @image = character_name
    @character_name = character_name
    @character_hue = character_hue
  end

  def moving?
    return (@real_x != @x * 128 or @real_y != @y * 128)
  end

  def jumping?
    return @jump_count > 0
  end

  def straighten
    if @walk_anime or @step_anime
      @pattern = 0
    end
    @anime_count = 0
    @prelock_direction = 0
  end

  def passable?(x, y, d)
    new_x = x + (d == 6 ? 1 : d == 4 ? -1 : 0)
    new_y = y + (d == 2 ? 1 : d == 8 ? -1 : 0)
    unless Game.map.valid?(new_x, new_y)
      return false
    end
    if @through
      return true
    end
    unless Game.map.passable?(x, y, d, self)
      return false
    end
    unless Game.map.passable?(new_x, new_y, 10 - d)
      return false
    end
    for netplayer in Game.map.netplayers.values
      if netplayer.x == new_x and netplayer.y == new_y
        unless netplayer.through
          if self != Game.player
            return false
          end
          if netplayer.character_name != ""
            return false
          end
        end
      end
    end
    for npc in Game.map.npcs.values
      if npc.x == new_x and npc.y == new_y
        unless npc.through
          if self != Game.player
            return false
          end
          if npc.character_name != ""
            return false
          end
        end
      end
    end
    for enemy in Game.map.enemies.values
      if enemy.x == new_x and enemy.y == new_y
        unless enemy.through
          if self != Game.player
            return false
          end
          if enemy.character_name != ""
            return false
          end
        end
      end
    end
    for event in Game.map.events.values
      if event.x == new_x and event.y == new_y
        unless event.through
          if self != Game.player
            return false
          end
          if event.character_name != ""
            return false
          end
        end
      end
    end
    if Game.player.x == new_x and Game.player.y == new_y
      unless Game.player.through
        if @character_name != ""
          return false
        end
      end
    end
    return true
  end

  def lock
    if @locked
      return
    end
    @prelock_direction = @direction
    turn_toward_player
    @locked = true
  end

  def lock?
    return @locked
  end

  def unlock
    unless @locked
      return
    end
    @locked = false
    unless @direction_fix
      if @prelock_direction != 0
        @direction = @prelock_direction
      end
    end
  end

  def moveto(x, y)
    @x = x % Game.map.width
    @y = y % Game.map.height
    @real_x = @x * 128
    @real_y = @y * 128
    @prelock_direction = 0
  end

  def screen_x
    return (@real_x - Game.map.display_x + 3) / 4 + 16
  end

  def screen_y
    y = (@real_y - Game.map.display_y + 3) / 4 + 32
    if @jump_count >= @jump_peak
      n = @jump_count - @jump_peak
    else
      n = @jump_peak - @jump_count
    end
    return y - (@jump_peak * @jump_peak - n * n) / 2
  end

  def screen_z(height = 0)
    if @always_on_top
      return 999
    end
    z = (@real_y - Game.map.display_y + 3) / 4 + 32
    if @tile_id > 0
      return z + Game.map.priorities[@tile_id] * 32
    else
      return z + ((height > 32) ? 31 : 0)
    end
  end

  def bush_depth
    if @tile_id > 0 or @always_on_top
      return 0
    end
    if @jump_count == 0 and Game.map.bush?(@x, @y)
      return 12
    else
      return 0
    end
  end

  def terrain_tag
    return Game.map.terrain_tag(@x, @y)
  end
  
  def update
    if jumping?
      update_jump
    elsif moving?
      update_move
    else
      update_stop
    end
    if @anime_count > 18 - @move_speed * 2
      if not @step_anime and @stop_count > 0
        @pattern = @original_pattern
      else
        @pattern = (@pattern + 1) % 4
      end
      @anime_count = 0
    end
    if @wait_count > 0
      @wait_count -= 1
      return
    end
    if @starting or lock?
      return
    end
    if @stop_count > (40 - @move_frequency * 2) * (6 - @move_frequency)
      case @move_type
      when 1  # 랜덤
        move_type_random
      when 2  # 가까워진다
        move_type_toward_player
      when 3  # 커스텀
        move_type_custom
      end
    end
  end

  def update_jump
    @jump_count -= 1
    @real_x = (@real_x * @jump_count + @x * 128) / (@jump_count + 1)
    @real_y = (@real_y * @jump_count + @y * 128) / (@jump_count + 1)
  end

  def update_move
    distance = 2 ** @move_speed
    if @y * 128 > @real_y
      @real_y = [@real_y + distance, @y * 128].min
    end
    if @x * 128 < @real_x
      @real_x = [@real_x - distance, @x * 128].max
    end
    if @x * 128 > @real_x
      @real_x = [@real_x + distance, @x * 128].min
    end
    if @y * 128 < @real_y
      @real_y = [@real_y - distance, @y * 128].max
    end
    if @walk_anime
      @anime_count += 1.5
    elsif @step_anime
      @anime_count += 1
    end
  end

  def update_stop
    if @step_anime
      @anime_count += 1
    elsif @pattern != @original_pattern
      @anime_count += 1.5
    end
    unless @starting or lock?
      @stop_count += 1
    end
  end

  def move_type_random
    case rand(6)
    when 0..3  # 랜덤
      move_random
    when 4  # 한 걸음 전진
      move_forward
    when 5  # 일시정지
      @stop_count = 0
    end
  end

  def move_type_toward_player
    sx = @x - Game.player.x
    sy = @y - Game.player.y
    abs_sx = sx > 0 ? sx : -sx
    abs_sy = sy > 0 ? sy : -sy
    if sx + sy >= 20
      move_random
      return
    end
    case rand(6)
    when 0..3  # 플레이어에 가까워진다
      move_toward_player
    when 4  # 랜덤
      move_random
    when 5  # 한 걸음 전진
      move_forward
    end
  end

  def move_type_custom
    if jumping? or moving?
      return
    end
    while @move_route_index < @move_route.list.size
      command = @move_route.list[@move_route_index]
      if command.code == 0
        if @move_route.repeat
          @move_route_index = 0
        end
        unless @move_route.repeat
          if @move_route_forcing and not @move_route.repeat
            @move_route_forcing = false
            @move_route = @original_move_route
            @move_route_index = @original_move_route_index
            @original_move_route = nil
          end
          @stop_count = 0
        end
        return
      end
      if command.code <= 14
        case command.code
        when 1  # 하에 이동
          move_down
        when 2  # 왼쪽으로 이동
          move_left
        when 3  # 오른쪽으로 이동
          move_right
        when 4  # 상에 이동
          move_up
        when 5  # 좌하에 이동
          move_lower_left
        when 6  # 우하에 이동
          move_lower_right
        when 7  # 좌상에 이동
          move_upper_left
        when 8  # 우상에 이동
          move_upper_right
        when 9  # 랜덤에 이동
          move_random
        when 10  # 플레이어에 가까워진다
          move_toward_player
        when 11  # 플레이어로부터 멀어진다
          move_away_from_player
        when 12  # 한 걸음 전진
          move_forward
        when 13  # 한 걸음 후퇴
          move_backward
        when 14  # 점프
          jump(command.parameters[0], command.parameters[1])
        end
        if not @move_route.skippable and not moving? and not jumping?
          return
        end
        @move_route_index += 1
        return
      end
      if command.code == 15
        @wait_count = command.parameters[0] * 2 - 1
        @move_route_index += 1
        return
      end
      if command.code >= 16 and command.code <= 26
        case command.code
        when 16  # 아래를 향한다
          turn_down
        when 17  # 왼쪽을 향한다
          turn_left
        when 18  # 오른쪽을 향한다
          turn_right
        when 19  # 위를 향한다
          turn_up
        when 20  # 오른쪽으로 90 도 회전
          turn_right_90
        when 21  # 왼쪽으로 90 도 회전
          turn_left_90
        when 22  # 180 도 회전
          turn_180
        when 23  # 오른쪽이나 왼쪽으로 90 도 회전
          turn_right_or_left_90
        when 24  # 랜덤에 방향 전환
          turn_random
        when 25  # 플레이어의 분을 향한다
          turn_toward_player
        when 26  # 플레이어의 역을 향한다
          turn_away_from_player
        end
        @move_route_index += 1
        return
      end
      if command.code >= 27
        case command.code
        when 27  # 스윗치 ON
          Game.switches[command.parameters[0]] = true
          Game.map.need_refresh = true
        when 28  # 스윗치 OFF
          Game.switches[command.parameters[0]] = false
          Game.map.need_refresh = true
        when 29  # 이동 속도의 변경
          @move_speed = command.parameters[0]
        when 30  # 이동 빈도의 변경
          @move_frequency = command.parameters[0]
        when 31  # 이동시 애니메이션 ON
          @walk_anime = true
        when 32  # 이동시 애니메이션 OFF
          @walk_anime = false
        when 33  # 정지시 애니메이션 ON
          @step_anime = true
        when 34  # 정지시 애니메이션 OFF
          @step_anime = false
        when 35  # 방향 고정 ON
          @direction_fix = true
        when 36  # 방향 고정 OFF
          @direction_fix = false
        when 37  # 빠져나가 ON
          @through = true
        when 38  # 빠져나가 OFF
          @through = false
        when 39  # 맨 앞면에 표시 ON
          @always_on_top = true
        when 40  # 맨 앞면에 표시 OFF
          @always_on_top = false
        when 41  # 그래픽 변경
          @tile_id = 0
          @character_name = command.parameters[0]
          @character_hue = command.parameters[1]
          if @original_direction != command.parameters[2]
            @direction = command.parameters[2]
            @original_direction = @direction
            @prelock_direction = 0
          end
          if @original_pattern != command.parameters[3]
            @pattern = command.parameters[3]
            @original_pattern = @pattern
          end
        when 42  # 불투명도의 변경
          @opacity = command.parameters[0]
        when 43  # 합성 방법의 변경
          @blend_type = command.parameters[0]
        when 44  # SE 의 연주
          Game.system.se_play(command.parameters[0])
        when 45  # 스크립트
          result = eval(command.parameters[0])
        end
        @move_route_index += 1
      end
    end
  end

  def increase_steps
    @stop_count = 0
  end
  
  def move_down(turn_enabled = true)
    if turn_enabled
      turn_down
    end
    if passable?(@x, @y, 2)
      turn_down
      @y += 1
      increase_steps
    end
  end

  def move_left(turn_enabled = true)
    if turn_enabled
      turn_left
    end
    if passable?(@x, @y, 4)
      turn_left
      @x -= 1
      increase_steps
    end
  end

  def move_right(turn_enabled = true)
    if turn_enabled
      turn_right
    end
    if passable?(@x, @y, 6)
      turn_right
      @x += 1
      increase_steps
    end
  end

  def move_up(turn_enabled = true)
    if turn_enabled
      turn_up
    end
    if passable?(@x, @y, 8)
      turn_up
      @y -= 1
      increase_steps
    end
  end

  def move_lower_left
    unless @direction_fix
      @direction = (@direction == 6 ? 4 : @direction == 8 ? 2 : @direction)
    end
    if (passable?(@x, @y, 2) and passable?(@x, @y + 1, 4)) or
       (passable?(@x, @y, 4) and passable?(@x - 1, @y, 2))
      @x -= 1
      @y += 1
      increase_steps
    end
  end

  def move_lower_right
    unless @direction_fix
      @direction = (@direction == 4 ? 6 : @direction == 8 ? 2 : @direction)
    end
    if (passable?(@x, @y, 2) and passable?(@x, @y + 1, 6)) or
       (passable?(@x, @y, 6) and passable?(@x + 1, @y, 2))
      @x += 1
      @y += 1
      increase_steps
    end
  end

  def move_upper_left
    unless @direction_fix
      @direction = (@direction == 6 ? 4 : @direction == 2 ? 8 : @direction)
    end
    if (passable?(@x, @y, 8) and passable?(@x, @y - 1, 4)) or
       (passable?(@x, @y, 4) and passable?(@x - 1, @y, 8))
      @x -= 1
      @y -= 1
      increase_steps
    end
  end

  def move_upper_right
    unless @direction_fix
      @direction = (@direction == 4 ? 6 : @direction == 2 ? 8 : @direction)
    end
    if (passable?(@x, @y, 8) and passable?(@x, @y - 1, 6)) or
       (passable?(@x, @y, 6) and passable?(@x + 1, @y, 8))
      @x += 1
      @y -= 1
      increase_steps
    end
  end

  def move_random
    case rand(4)
    when 0  # 하에 이동
      move_down(false)
    when 1  # 왼쪽으로 이동
      move_left(false)
    when 2  # 오른쪽으로 이동
      move_right(false)
    when 3  # 상에 이동
      move_up(false)
    end
  end

  def move_toward_player
    sx = @x - Game.player.x
    sy = @y - Game.player.y
    if sx == 0 and sy == 0
      return
    end
    abs_sx = sx.abs
    abs_sy = sy.abs
    if abs_sx == abs_sy
      rand(2) == 0 ? abs_sx += 1 : abs_sy += 1
    end
    if abs_sx > abs_sy
      sx > 0 ? move_left : move_right
      if not moving? and sy != 0
        sy > 0 ? move_up : move_down
      end
    else
      sy > 0 ? move_up : move_down
      if not moving? and sx != 0
        sx > 0 ? move_left : move_right
      end
    end
  end

  def move_away_from_player
    sx = @x - Game.player.x
    sy = @y - Game.player.y
    if sx == 0 and sy == 0
      return
    end
    abs_sx = sx.abs
    abs_sy = sy.abs
    if abs_sx == abs_sy
      rand(2) == 0 ? abs_sx += 1 : abs_sy += 1
    end
    if abs_sx > abs_sy
      sx > 0 ? move_right : move_left
      if not moving? and sy != 0
        sy > 0 ? move_down : move_up
      end
    else
      sy > 0 ? move_down : move_up
      if not moving? and sx != 0
        sx > 0 ? move_right : move_left
      end
    end
  end

  def move_forward
    case @direction
    when 2
      move_down(false)
    when 4
      move_left(false)
    when 6
      move_right(false)
    when 8
      move_up(false)
    end
  end

  def move_backward
    last_direction_fix = @direction_fix
    @direction_fix = true
    case @direction
    when 2  # 하
      move_up(false)
    when 4  # 왼쪽
      move_right(false)
    when 6  # 오른쪽
      move_left(false)
    when 8  # 상
      move_down(false)
    end
    @direction_fix = last_direction_fix
  end

  def jump(x_plus, y_plus)
    if x_plus != 0 or y_plus != 0
      if x_plus.abs > y_plus.abs
        x_plus < 0 ? turn_left : turn_right
      else
        y_plus < 0 ? turn_up : turn_down
      end
    end
    new_x = @x + x_plus
    new_y = @y + y_plus
    if (x_plus == 0 and y_plus == 0) or passable?(new_x, new_y, 0)
      straighten
      @x = new_x
      @y = new_y
      distance = Math.sqrt(x_plus * x_plus + y_plus * y_plus).round
      @jump_peak = 10 + distance - @move_speed
      @jump_count = @jump_peak * 2
      @stop_count = 0
    end
  end
  
  def jumpTo(x, y)
    x_plus = x - @x
    y_plus = y - @y
    if (x_plus == 0 and y_plus == 0) or passable?(x, y, 0)
      straighten
      @x = x
      @y = y
      distance = Math.sqrt(x_plus * x_plus + y_plus * y_plus).round
      @jump_peak = 10 + distance - @move_speed
      @jump_count = @jump_peak * 2
      @stop_count = 0
    end
  end

  def turn_down
    unless @direction_fix
      @direction = 2
      @stop_count = 0
    end
  end

  def turn_left
    unless @direction_fix
      @direction = 4
      @stop_count = 0
    end
  end

  def turn_right
    unless @direction_fix
      @direction = 6
      @stop_count = 0
    end
  end

  def turn_up
    unless @direction_fix
      @direction = 8
      @stop_count = 0
    end
  end

  def turn_right_90
    case @direction
    when 2
      turn_left
    when 4
      turn_up
    when 6
      turn_down
    when 8
      turn_right
    end
  end

  def turn_left_90
    case @direction
    when 2
      turn_right
    when 4
      turn_down
    when 6
      turn_up
    when 8
      turn_left
    end
  end

  def turn_180
    case @direction
    when 2
      turn_up
    when 4
      turn_right
    when 6
      turn_left
    when 8
      turn_down
    end
  end

  def turn_right_or_left_90
    if rand(2) == 0
      turn_right_90
    else
      turn_left_90
    end
  end

  def turn_random
    case rand(4)
    when 0
      turn_up
    when 1
      turn_right
    when 2
      turn_left
    when 3
      turn_down
    end
  end

  def turn_toward_player
    sx = @x - Game.player.x
    sy = @y - Game.player.y
    if sx == 0 and sy == 0
      return
    end
    if sx.abs > sy.abs
      sx > 0 ? turn_left : turn_right
    else
      sy > 0 ? turn_up : turn_down
    end
  end
  def turn_away_from_player
    sx = @x - Game.player.x
    sy = @y - Game.player.y
    if sx == 0 and sy == 0
      return
    end
    if sx.abs > sy.abs
      sx > 0 ? turn_right : turn_left
    else
      sy > 0 ? turn_down : turn_up
    end
  end
end

#────────────────────────────────────────────────────────────────────────────
# ▶ CharacterSprite
# --------------------------------------------------------------------------
# Author    EnterBrain
# Modify    뮤 (mu29gl@gmail.com)
# Date      2015. 1. 7
#────────────────────────────────────────────────────────────────────────────
class CharacterSprite < RPG::Sprite
  attr_accessor :character
  attr_accessor :erase

  def initialize(viewport, character = nil)
    super(viewport)
    @character = character
    @guild = ""
    @title = ""
    @name = ""
    @info_width = 200
    @info_height = 60
    @character_info = Sprite.new(viewport)
    @character_info.bitmap = Bitmap.new(@info_width, @info_height)
    @erase = 0
    refresh
    update
  end
  
  def refresh
    return unless @character.is_a?(Player) or @character.is_a?(Netplayer)
    @character_info.bitmap.clear
    @character_info.bitmap.font.size = Config::FONT_SMALL_SIZE
    #@character_info.bitmap.draw_outline_text(0, 0, 200, 20, @character.guild, Color.white, Color.black, 1) Game.getTitle(@character.title), 1)
    @character_info.bitmap.draw_outline_text(0, 14, 200, 20, @character.guild, Color.white, Color.red, 1)
    @character_info.bitmap.draw_outline_text(0, 28, 200, 20, @character.name, Color.white, Color.black, 1)
  end

  def update
    super
    for damage in @character.damages
      damage.update
    end
    if @tile_id != @character.tile_id or
       @character_name != @character.character_name or
       @character_hue != @character.character_hue
      @tile_id = @character.tile_id
      @character_name = @character.character_name
      @character_hue = @character.character_hue
      if @tile_id >= 384
        self.bitmap = RPG::Cache.tile(Game.map.tileset_name,
          @tile_id, @character.character_hue)
        self.src_rect.set(0, 0, 32, 32)
        self.ox = 16
        self.oy = 32
        @character_info.ox = self.ox
        @character_info.oy = self.oy
      else
        if @character.isIcon
          self.bitmap = RPG::Cache.icon(@character.character_name)
          @cw = bitmap.width
          @ch = bitmap.height
        else
          self.bitmap = RPG::Cache.character(@character.character_name, @character.character_hue)
          @cw = bitmap.width / 4
          @ch = bitmap.height / 4
        end
        self.ox = @cw / 2
        self.oy = @ch
        @character_info.ox = self.ox
        @character_info.oy = self.oy
      end
    end
    self.visible = (not @character.transparent)
    if @tile_id == 0
      sx = @character.pattern * @cw
      sy = (@character.direction - 2) / 2 * @ch
      self.src_rect.set(sx, sy, @cw, @ch)
    end
    self.x = @character.screen_x
    self.y = @character.screen_y
    self.z = @character.screen_z(@ch)
    @character_info.x = self.x - (@info_width - @cw) / 2
    @character_info.y = self.y - 42
    @character_info.z = self.z
    @erase += 5 if @erase > 0
    self.opacity = @character.opacity - @erase
    self.blend_type = @character.blend_type
    self.bush_depth = @character.bush_depth
    if @character.animation_id != 0
      animation = $data_animations[@character.animation_id]
      animation(animation, true)
      @character.animation_id = 0
    end
    return unless @character.is_a?(Player) or @character.is_a?(Netplayer)
    if @guild != @character.guild or
      @title != Game.getTitle(@character.title) or
      @name != @character.name
      @guild = @character.guild
      @title = Game.getTitle(@character.title)
      @name = @character.name
      refresh
    end
  end
  
  def dispose
    super
    @character_info.bitmap.clear
    @character_info.dispose
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ CharacterSprite
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com)
# Date      2015. 1. 31
# --------------------------------------------------------------------------
# Description
# 
#    데미지를 표시하는 클래스입니다.
#    사용 전 Damage.loadCache를 호출하여 캐시를 불러와야 합니다.
#    업데이트는 CharacterSprite에서 수행합니다.
#────────────────────────────────────────────────────────────────────────────
class Damage < Sprite
  @@cache = {}
  
  def initialize(character, value, critical)
    super()
    @character = character
    @direction = rand(3) - 1
    @x_plus, @y_plus = 0, 0
    if value.is_a?(Fixnum)
      damage_width = 0
      file = value > 0 ? 'DAMAGE' : 'RECOVER'
      data = value.to_s.split(//)
      data = data[value > 0 ? 0 : 1, data.size]
      digit_width = @@cache[file].width / 10
      for num in data
        damage_width += digit_width
      end
      x, y = 0, 0
      if critical
        x = (@@cache['CRITICAL'].width - damage_width) / 2
        y = @@cache['CRITICAL'].height
        width = @@cache['CRITICAL'].width if @@cache['CRITICAL'].width > damage_width
        self.bitmap = Bitmap.new(width, y + @@cache[file].height)
        self.bitmap.blt(damage_width > @@cache['CRITICAL'].width ? x : 0, 0, @@cache['CRITICAL'], 
            Rect.new(0, 0, @@cache['CRITICAL'].width, @@cache['CRITICAL'].height))
        x = 0 if damage_width > @@cache['CRITICAL'].width
      else
        width = damage_width
        begin
          self.bitmap = Bitmap.new(width, y + @@cache[file].height)
        rescue
          self.bitmap = Bitmap.new(1, 1)
        end
      end
      for num in data
        self.bitmap.blt(x, y, @@cache[file], 
          Rect.new(num.to_i * digit_width, 0, digit_width, @@cache[file].height))
        x += digit_width
      end
      self.opacity = 255
    elsif value.is_a?(String)
      if @@cache.has_key?(value)
        self.bitmap = @@cache[value]
      end
    end
    self.x = @character.screen_x - self.bitmap.width / 2
    self.y = @character.screen_y - 50
    character.damages.push(self)
  end
  
  def update
    self.x = @character.screen_x - self.bitmap.width / 2 + @x_plus
    self.y = @character.screen_y - 50 + @y_plus
    self.opacity -= 10 if self.opacity > 0
    @x_plus += @direction
    if self.opacity > 150
      @y_plus -= (self.opacity - 105) / 30
    else
      @y_plus += (255 - self.opacity) / 30
    end
    dispose if self.opacity <= 0
  end
  
  def dispose
    self.bitmap.clear
    @character.damages.delete(self)
    super
  end
  
  def self.loadCache
    @@cache['CRITICAL'] = RPG::Cache.damage("CRITICAL")
    @@cache['MISS'] = RPG::Cache.damage("MISS")
    @@cache['DAMAGE'] = RPG::Cache.damage("DAMAGE")
    @@cache['RECOVER'] = RPG::Cache.damage("RECOVER")
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ Player
# --------------------------------------------------------------------------
# Author    뮤(mu29gl@gmail.com)
# Date      2015. 1. 8
#────────────────────────────────────────────────────────────────────────────
class Player < Character
  attr_accessor :no
  attr_accessor :id
  attr_accessor :name
  attr_accessor :title
  attr_accessor :image
  attr_accessor :job
  attr_accessor :guild
  attr_accessor :statPoint
  attr_accessor :skillPoint
  attr_accessor :str
  attr_accessor :dex
  attr_accessor :agi
  attr_accessor :critical
  attr_accessor :hit
  attr_accessor :avoid
  attr_accessor :hp
  attr_accessor :maxHp
  attr_accessor :mp
  attr_accessor :maxMp
  attr_accessor :level
  attr_accessor :exp
  attr_accessor :maxExp
  attr_accessor :gold
  attr_accessor :map
  attr_accessor :x
  attr_accessor :y
  attr_accessor :direction
  
  attr_accessor :weapon
  attr_accessor :shield
  attr_accessor :helmet
  attr_accessor :armor
  attr_accessor :cape
  attr_accessor :shoes
  attr_accessor :accessory
  attr_accessor :equipped
  
  attr_accessor :new_map_id
  attr_accessor :new_x
  attr_accessor :new_y
  attr_accessor :new_direction
  attr_accessor :transferring
  
  attr_accessor :friend
  attr_accessor :partyNo
  attr_accessor :party_member
  attr_accessor :guildNo
  attr_accessor :guild_member
  attr_accessor :shopNo
  
  CENTER_X =(320 - 16) * 4
  CENTER_Y =(240 - 16) * 4
  
  def initialize
    super
    @guild = ""
    @transferring = false
    @equipped = {}
    @inventory = {}
    @skillList = {}
    @shopList = {}
    
    @friend = []
    @partyNo = 0
    @party_member = []
    @guildNo = 0
    @guild_member = []
  end
  
  def addItem(index, item)
    @inventory[index] = item
  end
  
  def hasItem?(index)
    return @inventory.include?(index)
  end
  
  def getItem(index)
    return @inventory[index]
  end
  
  def updateItem(index, amount, damage, magicDamage,
                defense, magicDefense, str, dex, agi, hp, mp, critical,
                avoid, hit, reinforce, trade, equipped)
    @inventory[index].amount = amount
    @inventory[index].damage = damage
    @inventory[index].magicDamage = magicDamage
    @inventory[index].defense = defense
    @inventory[index].magicDefense = magicDefense
    @inventory[index].str = str
    @inventory[index].dex = dex
    @inventory[index].agi = agi
    @inventory[index].hp = hp
    @inventory[index].mp = mp
    @inventory[index].critical = critical
    @inventory[index].avoid = avoid
    @inventory[index].hit = hit
    @inventory[index].reinforce = reinforce
    @inventory[index].trade = trade == 1
    @inventory[index].equipped = equipped == 1
  end
  
  def removeItem(index)
    @inventory.delete(index)
  end
  
  def addSkill(skill)
    @skillList[skill.no] = skill
  end
  
  def getSkill(no)
    return @skillList[no]
  end
  
  def getSkillList
    return @skillList
  end
  
  def updateSkill(no, rank)
    @skillList[no].rank = rank
  end
  
  def removeSkill(no)
    @skillList.delete(no)
  end
  
  def addShopItem(item)
    @shopList[@shopList.size + 1] = item
    @shopList[@shopList.size].index = @shopList.size
  end
  
  def getShopItem(index)
    @shopList[index]
  end
  
  def clearShopItem
    @shopList.clear
  end

  def passable?(x, y, d)
    new_x = x +(d == 6 ?  1 : d == 4 ?  -1 : 0)
    new_y = y +(d == 2 ?  1 : d == 8 ?  -1 : 0)
    unless Game.map.valid?(new_x, new_y)
      return false
    end
    super
  end

  def center(x, y)
    max_x =(Game.map.width - 20) * 128
    max_y =(Game.map.height - 15) * 128
    Game.map.display_x = [0, [x * 128 - CENTER_X, max_x]. min]. max
    Game.map.display_y = [0, [y * 128 - CENTER_Y, max_y]. min]. max
  end

  def moveto(x, y)
    super
    center(x, y)
  end

  def refresh
    @character_name = @image
    @character_hue = 0
    @opacity = 255
    @blend_type = 0
  end

  def update
    last_moving = moving?
    unless moving?
      case Key.dir4
      when 2
        move_down
      when 4
        move_left
      when 6
        move_right
      when 8
        move_up
      end
    end
    last_real_x = @real_x
    last_real_y = @real_y
    super
    if @real_y > last_real_y and @real_y - Game.map.display_y > CENTER_Y
      Game.map.scroll_down(@real_y - last_real_y)
    end
    if @real_x < last_real_x and @real_x - Game.map.display_x < CENTER_X
      Game.map.scroll_left(last_real_x - @real_x)
    end
    if @real_x > last_real_x and @real_x - Game.map.display_x > CENTER_X
      Game.map.scroll_right(@real_x - last_real_x)
    end
    if @real_y < last_real_y and @real_y - Game.map.display_y < CENTER_Y
      Game.map.scroll_up(last_real_y - @real_y)
    end
  end
  
  def turn_down(send = false)
    unless @direction_fix
      @direction = 2
      @stop_count = 0
      Socket.send({'header' => CTSHeader::TURN_CHARACTER, 'type' => 2}) if send
    end
  end

  def turn_left(send = false)
    unless @direction_fix
      @direction = 4
      @stop_count = 0
      Socket.send({'header' => CTSHeader::TURN_CHARACTER, 'type' => 4}) if send
    end
  end

  def turn_right(send = false)
    unless @direction_fix
      @direction = 6
      @stop_count = 0
      Socket.send({'header' => CTSHeader::TURN_CHARACTER, 'type' => 6}) if send
    end
  end

  def turn_up(send = false)
    unless @direction_fix
      @direction = 8
      @stop_count = 0
      Socket.send({'header' => CTSHeader::TURN_CHARACTER, 'type' => 8}) if send
    end
  end
  
  def move_down(turn_enabled = true)
    if passable?(@x, @y, 2)
      Socket.send({'header' => CTSHeader::MOVE_CHARACTER, 'type' => 2})
      turn_down
      @y += 1
    elsif turn_enabled
      turn_down(true)
    end
  end

  def move_left(turn_enabled = true)
    if passable?(@x, @y, 4)
      Socket.send({'header' => CTSHeader::MOVE_CHARACTER, 'type' => 4})
      turn_left
      @x -= 1
    elsif turn_enabled
      turn_left(true)
    end
  end

  def move_right(turn_enabled = true)
    if passable?(@x, @y, 6)
      Socket.send({'header' => CTSHeader::MOVE_CHARACTER, 'type' => 6})
      turn_right
      @x += 1
    elsif turn_enabled
      turn_right(true)
    end
  end

  def move_up(turn_enabled = true)
    if passable?(@x, @y, 8)
      Socket.send({'header' => CTSHeader::MOVE_CHARACTER, 'type' => 8})
      turn_up
      @y -= 1
    elsif turn_enabled
      turn_up(true)
    end
  end
  
  def update_stop
    @pattern = @original_pattern
    return
  end
end

#────────────────────────────────────────────────────────────────────────────
# ▶ Netplayer
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com)
# Date      2015. 1. 11
#────────────────────────────────────────────────────────────────────────────
class Netplayer < Character
  attr_accessor :no
  attr_accessor :name
  attr_accessor :job
  attr_accessor :title
  attr_accessor :level
  attr_accessor :guild
  attr_accessor :image
  attr_accessor :hp
  attr_accessor :maxHp
  attr_accessor :x
  attr_accessor :y
  attr_accessor :finalX
  attr_accessor :finalY
  attr_accessor :startSync
  attr_accessor :direction
  
  def initialize
    super
    @moveQueue = []
    @title = 0
    @guild = ""
    @startSync = false
    @erased = false
    @through = false
    @original_speed = 0
    refresh
  end
  
  def erase
    @erased = true
    refresh
  end
  
  def addMove(value)
    @moveQueue.push(value)
  end
  
  def move_down(turn_enabled = true)
    turn_down
    @y += 1
  end

  def move_left(turn_enabled = true)
    turn_left
    @x -= 1
  end

  def move_right(turn_enabled = true)
    turn_right
    @x += 1
  end

  def move_up(turn_enabled = true)
    turn_up
    @y -= 1
  end
  
  def turn_down
    unless @direction_fix
      @direction = 2
      @stop_count = 0
    end
  end
  
  def turn_left
    unless @direction_fix
      @direction = 4
      @stop_count = 0
    end
  end
  
  def turn_right
    unless @direction_fix
      @direction = 6
      @stop_count = 0
    end
  end
  
  def turn_up
    unless @direction_fix
      @direction = 8
      @stop_count = 0
    end
  end
  
  def do_coordinate_sync
    if @startSync
      @startSync = false
      if @x != @finalX or @y != @finalY
        moveto(@finalX, @finalY)
        refresh
      end
    end
  end

  def moveto(x, y)
    @x = x % Game.map.width
    @y = y % Game.map.height
    @real_x = @x * 128
    @real_y = @y * 128
    @prelock_direction = 0
    @finalX = @x
    @finalY = @y
  end

  def refresh
    @character_name = @image
    @character_hue = 0
    @opacity = 255
    @blend_type = 0
  end
  
  def update
    super
    return if moving?
    dir = @moveQueue.shift
    if @moveQueue.size > 2 && @original_speed == 0
      @original_speed = @move_speed
      @move_speed += 1
    elsif @moveQueue.size <= 2 && @original_speed > 0
      @move_speed = @original_speed
      @original_speed = 0
    end
    case dir
    when 2
      move_down
    when 4
      move_left
    when 6
      move_right
    when 8
      move_up
    end
    do_coordinate_sync if @moveQueue.empty?
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ Enemy
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com)
# Date      2015. 1. 23
#────────────────────────────────────────────────────────────────────────────
class Enemy < Character
  attr_accessor :no
  attr_accessor :name
  attr_accessor :image
  attr_accessor :hp
  attr_accessor :maxHp
  attr_accessor :x
  attr_accessor :y
  attr_accessor :finalX
  attr_accessor :finalY
  attr_accessor :direction
  
  def initialize
    super
    @erased = false
    @through = false
    @original_speed = 0
    refresh
  end
  
  def erase
    @erased = true
    refresh
  end
  
  def move_down(turn_enabled = true)
    turn_down
    @y += 1
  end

  def move_left(turn_enabled = true)
    turn_left
    @x -= 1
  end

  def move_right(turn_enabled = true)
    turn_right
    @x += 1
  end

  def move_up(turn_enabled = true)
    turn_up
    @y -= 1
  end
  
  def turn_down
    unless @direction_fix
      @direction = 2
      @stop_count = 0
    end
  end
  
  def turn_left
    unless @direction_fix
      @direction = 4
      @stop_count = 0
    end
  end
  
  def turn_right
    unless @direction_fix
      @direction = 6
      @stop_count = 0
    end
  end
  
  def turn_up
    unless @direction_fix
      @direction = 8
      @stop_count = 0
    end
  end
  
  def refresh
    @character_name = @image
    @character_hue = 0
    @opacity = 255
    @blend_type = 0
  end

  def moveto(x, y)
    @x = x % Game.map.width
    @y = y % Game.map.height
    @real_x = @x * 128
    @real_y = @y * 128
    @prelock_direction = 0
    @finalX = @x
    @finalY = @y
  end
  
  def update
    super
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ NPC
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com)
# Date      2015. 2. 8
#────────────────────────────────────────────────────────────────────────────
class NPC < Character
  attr_accessor :no
  attr_accessor :name
  attr_accessor :image
  attr_accessor :hp
  attr_accessor :maxHp
  attr_accessor :x
  attr_accessor :y
  attr_accessor :direction
  
  def initialize
    super
    @erased = false
    @through = false
    @original_speed = 0
    refresh
  end
  
  def erase
    @erased = true
    refresh
  end
  
  def move_down(turn_enabled = true)
    turn_down
    @y += 1
  end

  def move_left(turn_enabled = true)
    turn_left
    @x -= 1
  end

  def move_right(turn_enabled = true)
    turn_right
    @x += 1
  end

  def move_up(turn_enabled = true)
    turn_up
    @y -= 1
  end
  
  def turn_down
    unless @direction_fix
      @direction = 2
      @stop_count = 0
    end
  end
  
  def turn_left
    unless @direction_fix
      @direction = 4
      @stop_count = 0
    end
  end
  
  def turn_right
    unless @direction_fix
      @direction = 6
      @stop_count = 0
    end
  end
  
  def turn_up
    unless @direction_fix
      @direction = 8
      @stop_count = 0
    end
  end
  
  def refresh
    @character_name = @image
    @character_hue = 0
    @opacity = 255
    @blend_type = 0
  end

  def moveto(x, y)
    @x = x % Game.map.width
    @y = y % Game.map.height
    @real_x = @x * 128
    @real_y = @y * 128
    @prelock_direction = 0
    @finalX = @x
    @finalY = @y
  end
  
  def update
    super
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ Event
# --------------------------------------------------------------------------
# Author    EnterBrain
# Modify    뮤(mu29gl@gmail.com)
# Date      2015. 1. 7
#────────────────────────────────────────────────────────────────────────────
class Event < Character
  attr_reader   :trigger
  attr_reader   :list
  attr_reader   :starting
  attr_reader   :page
  attr_accessor :erased

  def initialize(map_id, event)
    super()
    @map_id = map_id
    @event = event
    @id = @event.id
    @erased = false
    @starting = false
    # 초기 위치에 이동
    moveto(@event.x, @event.y)
    refresh
  end

  def clear_starting
    @starting = false
  end

  def over_trigger?
    if @character_name != "" and not @through
      return false
    end
    unless Game.map.passable?(@x, @y, 0)
      return false
    end
    return true
  end

  def start
    if @list.size > 1
      @starting = true
    end
  end

  def erase
    @erased = true
    refresh
  end

  def refresh
    new_page = nil
    unless @erased
      for page in @event.pages.reverse
        c = page.condition
        if c.switch1_valid
          if Game.switches[c.switch1_id] == false
            next
          end
        end
        if c.switch2_valid
          if Game.switches[c.switch2_id] == false
            next
          end
        end
        if c.variable_valid
          if Game.variables[c.variable_id] < c.variable_value
            next
          end
        end
        if c.self_switch_valid
          key = [@map_id, @event.id, c.self_switch_ch]
          if Game.self_switches[key] != true
            next
          end
        end
        new_page = page
        break
      end
    end
    if new_page == @page
      return
    end
    @page = new_page
    clear_starting
    if @page == nil
      @tile_id = 0
      @character_name = ""
      @character_hue = 0
      @move_type = 0
      @trigger = nil
      @list = nil
      @interpreter = nil
      return
    end
    @tile_id = @page.graphic.tile_id
    @character_name = @page.graphic.character_name
    @character_hue = @page.graphic.character_hue
    if @original_direction != @page.graphic.direction
      @direction = @page.graphic.direction
      @original_direction = @direction
      @prelock_direction = 0
    end
    if @original_pattern != @page.graphic.pattern
      @pattern = @page.graphic.pattern
      @original_pattern = @pattern
    end
    @opacity = @page.graphic.opacity
    @blend_type = @page.graphic.blend_type
    @move_type = @page.move_type
    @move_speed = @page.move_speed
    @move_frequency = @page.move_frequency
    @move_route = @page.move_route
    @move_route_index = 0
    @move_route_forcing = false
    @walk_anime = @page.walk_anime
    @step_anime = @page.step_anime
    @direction_fix = @page.direction_fix
    @through = @page.through
    @always_on_top = @page.always_on_top
    @trigger = @page.trigger
    @list = @page.list
    @interpreter = nil
    if @trigger == 4
      @interpreter = Interpreter.new
    end
    check_event_trigger_auto
  end

  def check_event_trigger_touch(x, y)
    if Game.system.map_interpreter.running?
      return
    end
    if @trigger == 2 and x == Game.player.x and y == Game.player.y
      unless over_trigger?
        start
      end
    end
  end

  def check_event_trigger_auto
    if @trigger == 2
      if @x == Game.player.x and @y == Game.player.y and over_trigger?
        start
      end
    end
    if @trigger == 3
      start
    end
  end

  def update
    super
    check_event_trigger_auto
    if @interpreter != nil
      unless @interpreter.running?
        @interpreter.setup(@list, @event.id)
      end
      @interpreter.update
    end
  end
end

class Timer < Sprite
  #--------------------------------------------------------------------------
  # ● 오브젝트 초기화
  #--------------------------------------------------------------------------
  def initialize
    super
    self.bitmap = Bitmap.new(88, 48)
    self.bitmap.font.name = "Arial"
    self.bitmap.font.size = 32
    self.x = 640 - self.bitmap.width
    self.y = 0
    self.z = 500
    update
  end
  #--------------------------------------------------------------------------
  # ● 해방
  #--------------------------------------------------------------------------
  def dispose
    if self.bitmap != nil
      self.bitmap.dispose
    end
    super
  end
  #--------------------------------------------------------------------------
  # ● 프레임 갱신
  #--------------------------------------------------------------------------
  def update
    super
    # 타이머 작동중이라면 가시로 설정
    self.visible = Game.system.timer_working
    # 타이머를 재묘화 할 필요가 있는 경우
    if Game.system.timer / Graphics.frame_rate != @total_sec
      # 윈도우 내용을 클리어
      self.bitmap.clear
      # 토탈초수를 계산
      @total_sec = Game.system.timer / Graphics.frame_rate
      # 타이머 표시용의 문자열을 작성
      min = @total_sec / 60
      sec = @total_sec % 60
      text = sprintf("%02d:%02d", min, sec)
      # 타이머를 묘화
      self.bitmap.font.color.set(255, 255, 255)
      self.bitmap.draw_text(self.bitmap.rect, text, 1)
    end
  end
end

MAX_PRIORITY_LAYERS = 5

#===============================================================================
# ** Viewport
#===============================================================================

class Viewport
  alias :_initialize_ :initialize if !$@
  def initialize(x=0, y=0, width=Graphics.width, height=Graphics.height, override=false)
    if x.is_a?(Rect)
      _initialize_(x)
    elsif [x, y, width, height] == [0, 0, 640, 480] && !override 
      _initialize_(Rect.new(0, 0, Graphics.width, Graphics.height))
    else
      _initialize_(Rect.new(x, y, width, height))
    end
  end
  
  def resize(*args)
    self.rect = args[0].is_a?(Rect) ? args[0] : Rect.new(*args)
  end
end

#===============================================================================
# ** Tilemap
#===============================================================================

class Tilemap
  
  attr_accessor :tileset, :autotiles, :map_data, :priorities, :ground_sprite
  #---------------------------------------------------------------------------
  # Initialize
  #---------------------------------------------------------------------------
  def initialize(viewport = nil)
    @viewport = viewport
    @layer_sprites = []
    @autotile_frame = []      #[[ANIMATION_DRAW_INDEX, CURRENT_LOGICAL_FRAME], ... ]
    @autotile_framedata = []  #[[DATA_FROM_CONFIGURATION_ABOVE], ... ]
    # Ensures that the bitmap width accounts for an extra tile
    # and is divisible by 32
    bitmap_width = ((Graphics.width / 32.0).ceil + 1) * 32
    # Create the priority layers
    ((Graphics.height/32.0).ceil + MAX_PRIORITY_LAYERS).times{ |i|
      s = Sprite.new(@viewport)
      s.y = i*32 - (MAX_PRIORITY_LAYERS - 1) * 32
      s.z = 32 * (i+2)
      s.bitmap = Bitmap.new(bitmap_width, MAX_PRIORITY_LAYERS * 32)
      @layer_sprites.push(s)
    }
    
    # Same reasons as bitmap_width, but for height
    bitmap_height = ((Graphics.height / 32.0).ceil + 1) * 32
    # Create the ground layer (priority 0)
    s = Sprite.new(@viewport)
    s.bitmap = Bitmap.new(bitmap_width, bitmap_height)
    @ground_sprite = s
    @ground_sprite.z = 0
    
    # Initialize Autotile data
    Game.map.autotile_names.each_index {|i| filename = Game.map.autotile_names[i]
      # Get animation frame rate of the autotile
      frames = autotile_framerate(filename)
      # If autotile doesn't animate
      if frames.nil?
        @autotile_frame[i] = [0,0]
        @autotile_framedata[i] = nil
      else
        # Save the frame rate data
        @autotile_framedata[i] = frames
        # Determine how long one animation cycle takes and indicate at what time
        # the next frame of animation occurs
        total = 0
        frame_checkpoints = []
        frames.each_index{|j| f = frames[j]
          total += f
          frame_checkpoints[j] = total
        }
        # Get animation frame for this autotile based on game time passed
        current_frame = Graphics.frame_count % total
        frame_checkpoints.each_index{|j| c = frame_checkpoints[j]
          next if c.nil?
          if c > current_frame
            @autotile_frame[i] = [j, c - current_frame]
            break
          end
        }
      end
    }
    
    # Initialize remaining variables
    @first_update = true
    @tileset = nil
    @autotiles = []
    @map_data = nil
    @priorities = nil
    @old_ox = 0
    @old_oy = 0
    @ox = 0
    @oy = 0
    @shift = 0
    
    # Set up the DLL.calls
    @@update = Win32API::DrawMapsBitmap2
    @@autotile_update = Win32API::UpdateAutotiles
    @@initial_draw = Win32API::DrawMapsBitmap
    @empty_tile = Bitmap.new(32,32)
    Win32API::InitEmptyTile.call(@empty_tile.object_id)
  end
  
  def autotile_framerate(filename)
    w = RPG::Cache.autotile(filename).width
    h = RPG::Cache.autotile(filename).height
    if (h == 32 && w / 32 == 1) || (h == 192 && w / 256 == 1)
      return nil
    else
      return h == 32 ? Array.new(w/32){|i| 16} : Array.new(w/256){|i| 16}
    end
  end
  
  #---------------------------------------------------------------------------
  # Dispose tilemap
  #---------------------------------------------------------------------------
  def dispose
    @layer_sprites.each{|sprite| sprite.dispose}
    @ground_sprite.dispose
  end
  #---------------------------------------------------------------------------
  # Check if disposed tilemap
  #---------------------------------------------------------------------------
  def disposed?
    return @layer_sprites[0].disposed?
  end
  #---------------------------------------------------------------------------
  # Get viewport
  #---------------------------------------------------------------------------
  def viewport
    return @viewport
  end
  #---------------------------------------------------------------------------
  # Update tilemap graphics
  #---------------------------------------------------------------------------
  def update
    # t = Time.now
    autotile_need_update = []
    # Update autotile animation frames
    for i in 0..6
      autotile_need_update[i] = false
      # If this autotile doesn't animate, skip
      next if @autotile_framedata[i].nil?
      # Reduce frame count
      @autotile_frame[i][1] -= 1
      # Autotile requires update
      if @autotile_frame[i][1] == 0
        @autotile_frame[i][0] = (@autotile_frame[i][0] + 1) % @autotile_framedata[i].size
        @autotile_frame[i][1] = @autotile_framedata[i][@autotile_frame[i][0]]
        autotile_need_update[i] = true
      end
    end
    # If Game.data[]= script.call was used, force redraw on entire map
    if self.map_data.changed
      @first_update = true
      self.map_data.changed = false
    end
    
    # Stop the update unless updating for first time or there are no shifting
    return if (!@first_update && @shift == 0 && autotile_need_update.index(true).nil?)

    # Set up the array for the priority layers
    layers = [@layer_sprites.size + 1]
    # Insert higher priority layers into the array in order (least to most y-value sprite)
    @layer_sprites.each{|sprite| layers.push(sprite.bitmap.object_id) }
    # Insert ground layer last in the array
    layers.push(@ground_sprite.bitmap.object_id)
    # Load autotile bitmap graphics into array
    tile_bms = [self.tileset.object_id]
    self.autotiles.each{|autotile| tile_bms.push(autotile.object_id) }
    # Store autotile animation frame data
    autotiledata = []
    for i in 0..6
      autotiledata.push(@autotile_frame[i][0])
      autotiledata.push(autotile_need_update[i] ? 1 : 0)
    end
    # Fills in remaining information of other tilemaps
    misc_data = [@ox + Game.screen.shake.to_i, @oy, self.map_data.object_id, self.priorities.object_id, @shift, MAX_PRIORITY_LAYERS]
    
    # If forcing fresh redraw of the map (or drawing for first time)
    if @first_update
      # Initialize layer sprite positions and clear them for drawing
      @layer_sprites.each_index{|i| layer = @layer_sprites[i]
        layer.bitmap.clear
        layer.x = -(@ox % 32)
        if layer.x <= -32 + Game.screen.shake.to_i
          layer.x += 32
        elsif layer.x > Game.screen.shake.to_i
          layer.x -= 32
        end
        layer.y = (i * 32) - (@oy % 32) - (MAX_PRIORITY_LAYERS-1) * 32
      }
      @ground_sprite.bitmap.clear
      @ground_sprite.x = -(@ox % 32)
      if @ground_sprite.x <= -32 + Game.screen.shake.to_i
        @ground_sprite.x += 32
      elsif @ground_sprite.x > Game.screen.shake.to_i
        @ground_sprite.x -= 32
      end
      @ground_sprite.y = -(@oy % 32)
      # Turn off flag to prevent.calling this portion of code again
      @first_update = false
      # Make DLL.call
      @@initial_draw.call(layers.pack("L*"), tile_bms.pack("L*"), autotiledata.pack("L*"), misc_data.pack("L*"))
    elsif @shift != 0
      # Update for shifting
      @@update.call(layers.pack("L*"), tile_bms.pack("L*"), autotiledata.pack("L*"), misc_data.pack("L*"))
    end
    # Check for autotile updates
    if !autotile_need_update.index(true).nil?
      @@autotile_update.call(layers.pack("L*"), tile_bms.pack("L*"), autotiledata.pack("L*"), misc_data.pack("L*"))
    end
    # Reset shift flag
    @shift = 0
  end
  
  #---------------------------------------------------------------------------
  # Return if tilemap is visible
  #---------------------------------------------------------------------------
  def visible
    return layer_sprites[0].visible
  end
  #---------------------------------------------------------------------------
  # Show or hide tilemap
  #---------------------------------------------------------------------------
  def visible=(bool)
    @layer_sprites.each{|sprite| sprite.visible = bool}
    @ground_sprite.visible = bool
  end
  
  #---------------------------------------------------------------------------
  # Shift tilemap horizontally
  #---------------------------------------------------------------------------
  def ox=(ox)
    # No shift = no need to continue
    return if @ox == ox && !Game.screen.shaking?
    # Compute difference and save change
    diff = @ox - ox
    @ox = ox
    # If forcing redraw, no need to shift layer sprites around
    return if @first_update
    
    # If shift is too big, force redraw
    if diff.abs > 32
      @first_update = true
      return
    end
    # Shift sprites
    @ground_sprite.x += diff
    @layer_sprites.each{|sprite| sprite.x += diff}

    # If sprites are out of bounds, reposition and redraw (make DLL.call)
    if @ground_sprite.x <= -32 + Game.screen.shake.to_i
      @ground_sprite.x += 32
      @ground_sprite.bitmap.fill_rect(0, 0, 32, @ground_sprite.bitmap.height, Color.new(0,0,0,0))
      @layer_sprites.each{|sprite| 
        sprite.x += 32
        sprite.bitmap.fill_rect(0, 0, 32, sprite.bitmap.height, Color.new(0,0,0,0))
      }
      @shift += 1 # Redraw right column
    elsif @ground_sprite.x > 0 + Game.screen.shake.to_i
      @ground_sprite.x -= 32
      @ground_sprite.bitmap.fill_rect(@ground_sprite.bitmap.width - 32, 0, 32, @ground_sprite.bitmap.height, Color.new(0,0,0,0))
      @layer_sprites.each{|sprite| 
        sprite.x -= 32
        sprite.bitmap.fill_rect(sprite.bitmap.width - 32, 0, 32, sprite.bitmap.height, Color.new(0,0,0,0))
      }
      @shift += 2 # Redraw left column
    end
  end
  #---------------------------------------------------------------------------
  # Shift tilemap vert.cally
  #---------------------------------------------------------------------------
  def oy=(oy)
    return if @oy == oy
    diff = @oy - oy
    @oy = oy
    # If shift is too big, force redraw
    if diff.abs > 32
      @first_update = true
      return
    end
    # Shift sprites
    @ground_sprite.y += diff
    @layer_sprites.each{ |sprite|
      sprite.y += diff
      sprite.z += diff
    }
    # If ground is out of bounds, reshift and redraw (make DLL.call)
    if @ground_sprite.y <= -32
      @ground_sprite.y += 32
      @shift += 4 # Redraw bottom row
    elsif @ground_sprite.y > 0
      @ground_sprite.y -= 32
      @shift += 8 # Redraw top row
    end

    # If layer is too far up screen, need to move it down
    if @layer_sprites[0].y <= -(MAX_PRIORITY_LAYERS * 32)
      shift_amt = ((Graphics.height/32.0).ceil + MAX_PRIORITY_LAYERS) * 32
      layer = @layer_sprites.shift
      layer.y += shift_amt
      layer.z += shift_amt
      layer.bitmap.clear
      @layer_sprites.push(layer)
    end
    # If layer is too far down screen, need to move it up
    if @layer_sprites[-1].y > ((Graphics.height/32.0).ceil * 32)
      shift_amt = ((Graphics.height/32.0).ceil + MAX_PRIORITY_LAYERS) * -32
      layer = @layer_sprites.pop
      layer.y += shift_amt
      layer.z += shift_amt
      layer.bitmap.clear
      @layer_sprites.unshift(layer)
    end
  end
end

#===============================================================================
# ** Game.player
#===============================================================================

class Player
  
  CENTER_X = ((Graphics.width / 2) - 16) * 4
  CENTER_Y = ((Graphics.height / 2) - 16) * 4
  
  def center(x, y)
    max_x = (Game.map.width - (Graphics.width / 32.0).ceil) * 128
    max_y = (Game.map.height - (Graphics.height / 32.0).ceil) * 128
    Game.map.display_x = [0, [x * 128 - CENTER_X, max_x].min].max
    Game.map.display_y = [0, [y * 128 - CENTER_Y, max_y].min].max
  end  
end

#===============================================================================
# ** Game_Map
#===============================================================================
class Map
  alias :_setup_ :setup if !$@
  def setup(map_id)
    _setup_(map_id)
    @map_edge = [self.width - (Graphics.width/32.0).ceil, self.height - (Graphics.height/32.0).ceil]
    @map_edge.collect! {|size| size * 128 }
    if Game.map.width < Graphics.width / 32
      Player.const_set(:CENTER_X, Graphics.width * 128)
    else
      Player.const_set(:CENTER_X, ((Graphics.width / 2) - 16) * 4)
    end
    if Game.map.height < Graphics.height / 32
      Player.const_set(:CENTER_Y, Graphics.height * 128)
    else
      Player.const_set(:CENTER_Y, ((Graphics.height / 2) - 16) * 4)
    end
  end

  def scroll_down(distance)
    @display_y = [@display_y + distance, @map_edge[1]].min
  end

  def scroll_right(distance)
    @display_x = [@display_x + distance, @map_edge[0]].min
  end
end

#===============================================================================
# ** Plane
#===============================================================================

Object.send(:remove_const, :Plane)

class Plane < Sprite
 
  def z=(z)
    super(z * 1000)
  end
 
  def ox=(ox)
    return if @bitmap == nil
    super(ox % @bitmap.width)
  end
 
  def oy=(oy)
    return if @bitmap == nil
    super(oy % @bitmap.height)
  end
 
  def bitmap
    return @bitmap
  end
 
  def bitmap=(tile)
    @bitmap = tile
    xx = 1 + (Graphics.width.to_f / tile.width).ceil
    yy = 1 + (Graphics.height.to_f / tile.height).ceil
    plane = Bitmap.new(@bitmap.width * xx, @bitmap.height * yy)
    (0..xx).each {|x| (0..yy).each {|y|
      plane.blt(x * @bitmap.width, y * @bitmap.height, @bitmap, @bitmap.rect)
    }}
    super(plane)
  end
 
  def x; end
  def y; end
  def x=(x); end
  def y=(y); end
end

#===============================================================================
# ** Table
#===============================================================================

class Table
  attr_accessor :changed
  
  alias :init_for_changed :initialize if !$@
  def initialize(*args)
    init_for_changed(*args)
    @changed = false
  end
  
  alias :flag_changes_to_set :[]= if !$@
  def []=(x, y, z=nil, v=nil)
    if v.nil?
      if z.nil?
        flag_changes_to_set(x, y)
      else
        flag_changes_to_set(x, y, z)
      end
    else
      @changed = true
      flag_changes_to_set(x, y, z, v)
    end
  end
  
end

module RPG::Cache

  AUTO_INDEX = 
  
  [27,28,33,34],  [5,28,33,34],  [27,6,33,34],  [5,6,33,34],
  [27,28,33,12],  [5,28,33,12],  [27,6,33,12],  [5,6,33,12],
  [27,28,11,34],  [5,28,11,34],  [27,6,11,34],  [5,6,11,34],
  [27,28,11,12],  [5,28,11,12],  [27,6,11,12],  [5,6,11,12],
  [25,26,31,32],  [25,6,31,32],  [25,26,31,12], [25,6,31,12],
  [15,16,21,22],  [15,16,21,12], [15,16,11,22], [15,16,11,12],
  [29,30,35,36],  [29,30,11,36], [5,30,35,36],  [5,30,11,36],
  [39,40,45,46],  [5,40,45,46],  [39,6,45,46],  [5,6,45,46],
  [25,30,31,36],  [15,16,45,46], [13,14,19,20], [13,14,19,12],
  [17,18,23,24],  [17,18,11,24], [41,42,47,48], [5,42,47,48],
  [37,38,43,44],  [37,6,43,44],  [13,18,19,24], [13,14,43,44],
  [37,42,43,48],  [17,18,47,48], [13,18,43,48], [13,18,43,48]
  
  def self.autotile(filename)
    key = "Graphics/Autotiles/#{filename}"
    key = RPG::Path::RTP(key)
    if !@cache.include?(key) || @cache[key].disposed? 
      # Cache the autotile graphic.
      @cache[key] = (filename == '') ? Bitmap.new(128, 96) : Bitmap.new(key)
      # Cache each configuration of this autotile.
      new_bm = self.format_autotiles(@cache[key], filename)
      @cache[key].dispose
      @cache[key] = new_bm
    end
    return @cache[key]
  end

  def self.format_autotiles(bitmap, filename)
    if bitmap.height > 32 && bitmap.height < 256
      frames = bitmap.width / 96
      template = Bitmap.new(256*frames,192)
      # Create a bitmap to use as a template for creation.
      (0..frames-1).each{|frame|
      (0...6).each {|i| (0...8).each {|j| AUTO_INDEX[8*i+j].each {|number|
        number -= 1
        x, y = 16 * (number % 6), 16 * (number / 6)
        rect = Rect.new(x + (frame * 96), y, 16, 16)
        template.blt((32 * j + x % 32) + (frame * 256), 32 * i + y % 32, bitmap, rect)
      }}}}
      return template
    else
      return bitmap
    end
  end
  
end

#===============================================================================
# ** RPG::Weather
#===============================================================================

class RPG::Weather
  
  alias :add_more_weather_sprites :initialize if !$@
  def initialize(vp = nil)
    add_more_weather_sprites(vp)
    total_sprites = Graphics.width * Graphics.height / 7680
    if total_sprites > 40
      for i in 1..(total_sprites - 40)
        sprite = Sprite.new(vp)
        sprite.z = 1000
        sprite.visible = false
        sprite.opacity = 0
        @sprites.push(sprite)
      end
    end
  end
  
  def type=(type)
    return if @type == type
    @type = type
    case @type
    when 1
      bitmap = @rain_bitmap
    when 2
      bitmap = @storm_bitmap
    when 3
      bitmap = @snow_bitmap
    else
      bitmap = nil
    end
    for i in 1..@sprites.size
      sprite = @sprites[i]
      if sprite != nil
        sprite.visible = (i <= @max)
        sprite.bitmap = bitmap
      end
    end
  end
  
  def max=(max)
    return if @max == max;
    @max = [[max, 0].max, @sprites.size].min
    for i in 1..@sprites.size
      sprite = @sprites[i]
      if sprite != nil
        sprite.visible = (i <= @max)
      end
    end
  end
  
  def update
    return if @type == 0
    for i in 1..@max
      sprite = @sprites[i]
      if sprite == nil
        break
      end
      if @type == 1
        sprite.x -= 2
        sprite.y += 16
        sprite.opacity -= 8
      end
      if @type == 2
        sprite.x -= 8
        sprite.y += 16
        sprite.opacity -= 12
      end
      if @type == 3
        sprite.x -= 2
        sprite.y += 8
        sprite.opacity -= 8
      end
      x = sprite.x - @ox
      y = sprite.y - @oy
      if sprite.opacity < 64
        sprite.x = rand(Graphics.width + 100) - 100 + @ox
        sprite.y = rand(Graphics.width + 200) - 200 + @oy
        sprite.opacity = 160 + rand(96)
      end
    end
  end
  
end


#===============================================================================
# ** Screen
#===============================================================================

class Screen
  
  def weather(type, power, duration)
    @weather_type_target = type
    if @weather_type_target != 0
      @weather_type = @weather_type_target
    end
    if @weather_type_target == 0
      @weather_max_target = 0.0
    else
      if WEATHER_ADJUSTMENT
        num = Graphics.width * Graphics.height / 76800.0
      else
        num = 4.0
      end
      @weather_max_target = (power + 1) * num
    end
    @weather_duration = duration
    if @weather_duration == 0
      @weather_type = @weather_type_target
      @weather_max = @weather_max_target
    end
  end
  
  def shaking?
    return @shake_duration > 0 || @shake != 0
  end
  
end
class Slot
  attr_accessor :slot
  
  def initialize
    @slot = []
    
    for i in 0...10
      @slot[i] = -1
    end
  end
  
  def setSlot(index, slot)
    @slot[index] = slot
  end
  
  def getSlot(n)
    return @slot[n]
  end
  
  def getKey(n)
    return Key::SLOT[n]
  end
end
class Cool
  attr_accessor :nowCooltime
  attr_accessor :fullCooltime
  
  def initialize(nowCooltime, fullCooltime)
    @nowCooltime = nowCooltime
    @fullCooltime = fullCooltime
  end
end

class Cooltime
  attr_accessor :slot
  
  def initialize
    @slot = []
    
    for i in 0...10
      @slot[i] = Cool.new(0, 0)
    end
  end
  
  def setCool(i, nowCooltime, fullCooltime)
    @slot[i].nowCooltime = nowCooltime
    @slot[i].fullCooltime = fullCooltime
  end
  
  def getCool(i)
    return @slot[i]
  end
end




#────────────────────────────────────────────────────────────────────────────
# ▶ Scene_Logo
# --------------------------------------------------------------------------
# Author    RedPudding
# Date      2010. 1. 17
# --------------------------------------------------------------------------
# Description
# 
#    서버 접속 후 로고를 표시합니다. (시간 좀 늘렸습니다^^.)
#────────────────────────────────────────────────────────────────────────────
class Scene_Logo
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
      $scene = Scene_Server.new
    end
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ Scene_Server
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2015. 2
#────────────────────────────────────────────────────────────────────────────
class Scene_Server
  def initialize
    Game.system.bgm_play(RPG::AudioFile.new("Rain.mp3"))
    @cache = RPG::Cache.title("title.png"), RPG::Cache.title("cloud.png")
    @sprite = []
    # title
    @sprite[0] = Sprite.new
    @sprite[0].bitmap = @cache[0]
    # sun
    @sprite[1] = Sprite.new
    @sprite[1].ox = @cache[1].width / 2
    @sprite[1].oy = @cache[1].height / 2
    @sprite[1].x = 400
    @sprite[1].y = 85
    @sprite[1].bitmap = @cache[1]
    @sprite[1].opacity = 0
    @viewport = Viewport.new(390, 135, 25, 25)
    # rain
    @rain = true
    @sprite[2] = Sprite.new(@viewport)
    @sprite[2].bitmap = Bitmap.new(25, @viewport.rect.height * 2)
    @sprite[2].opacity = 0
    # comment
    @sprite[3] = Sprite.new
    @sprite[3].y = 212
    @sprite[3].opacity = 0
    @sprite[3].bitmap = Bitmap.new(800, 20)
    @sprite[3].bitmap.font.name = Config::FONT[0]
    @sprite[3].bitmap.font.size = 20
    @sprite[3].bitmap.draw_multi_text(0, 0, @sprite[3].bitmap.width, @sprite[3].bitmap.height,
    "RPGXP 온라인 엔진", 1)
    MUI_Server.new
  end
  
  def main
    $data_tilesets = load_data("Data/Tilesets.rxdata")
    $data_animations = load_data("Data/Animations.rxdata")
    Graphics.transition
    loop do
      slide
      animation
      Socket.update
      MUI.update
      Graphics.update
      if $scene != self
        break
      end
    end
    Graphics.freeze
    @sprite.each_index { |n| @sprite[n].bitmap.dispose; @sprite[n].dispose }
    #@cache.each_index { |n| @cache[n].dispose }
    MUI.getForm(MUI_Server).dispose
  end
  
  def slide
    @sprite[1].y += (115 - @sprite[1].y + @sprite[1].oy) / 10.0
    if @sprite[1].opacity < 255
      @sprite[1].opacity += 5
    else
      return if @sprite[3].opacity >= 255
      @sprite[3].opacity += 2
    end
  end
  
  def rain
    return if !@rain
    @sprite[2].bitmap.clear
    32.times do
      @sprite[2].bitmap.fill_rect(rand(@sprite[2].bitmap.width) - 1,
      - 24 + rand(@sprite[2].bitmap.height) * 3,
      1,
      3 + rand(2), Color.white(128))
    end
  end
  
  def animation
    if Mouse.x >= @sprite[1].x - @sprite[1].ox and Mouse.x <= @sprite[1].x - @sprite[1].ox + @sprite[1].bitmap.width and
      Mouse.y >= @sprite[1].y - @sprite[1].oy and Mouse.y <= @sprite[1].y - @sprite[1].oy + @sprite[1].bitmap.height
      @sprite[1].zoom_x += (1.2 - @sprite[1].zoom_x) / 10.0
      @sprite[1].zoom_y += (1.2 - @sprite[1].zoom_y) / 10.0
      if Mouse.trigger?
        @rain = @rain ? false : true
      end
    else
      @sprite[1].zoom_x += (1 - @sprite[1].zoom_x) / 10.0
      @sprite[1].zoom_y += (1 - @sprite[1].zoom_y) / 10.0
    end
    if @rain
      if Graphics.frame_count % 1 == 0
        @sprite[2].y += 1
        @sprite[2].opacity += 10
        if @sprite[2].y >= @sprite[2].bitmap.height / 4
          @sprite[2].y = 0
          rain
        end
      end
    else
      @sprite[2].y += 1 if @sprite[2].opacity >= 0
      @sprite[2].opacity -= 10 if @sprite[2].opacity >= 0
      @sprite[2].bitmap.clear if @sprite[2].opacity <= 0
    end
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ Scene_Login
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com)
# Date      2014. 1. 18
#────────────────────────────────────────────────────────────────────────────
class Scene_Login
  def main
    @sprite = Sprite.new
    @sprite.bitmap = RPG::Cache.title("Title")
    Graphics.transition
    MUI_Login.new
    loop do
      MUI.update
      Graphics.update
      update
      if $scene != self
        break
      end
    end
    MUI.getForm(MUI_Login).dispose if MUI.include?(MUI_Login)
    MUI.getForm(MUI_Register).dispose if MUI.include?(MUI_Register)
    Graphics.freeze    
    @sprite.bitmap.dispose
    @sprite.dispose
  end
  
  def update
    Socket.update
  end
end
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
#────────────────────────────────────────────────────────────────────────────
# ▶ Scene_Map
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com)
# Date      2015
#────────────────────────────────────────────────────────────────────────────
class Scene_Map
  attr_accessor :hud
  
  def initialize
    @mapSprite = MapSprite.new
    @hud = MUI_HUD.new
    MUI::Console.init
    MUI::ChatBox.init
  end
  
  def main
    Graphics.transition
    loop do
      Graphics.update
      Socket.update
      MUI.update
      MUI::ChatBox.update
      @hud.update
      update
      if $scene != self
        break
      end
    end
    Graphics.freeze
    @mapSprite.dispose
  end

  def update
    loop do
      Game.map.update
      Game.player.update
      Game.system.update
      Game.screen.update
      unless Game.player.transferring
        break
      end
      transfer_player
      if Game.screen.transition_processing
        break
      end
    end
    if Game.screen.transition_processing
      Game.screen.transition_processing = false
      if Game.screen.transition_name == ""
        Graphics.transition(20)
      else
        Graphics.transition(40, "Graphics/Transitions/" +
          Game.screen.transition_name)
      end
    end
    @mapSprite.update
    if Mouse.trigger?
      for netplayer in Game.map.netplayers.values
        if netplayer.x == Mouse.map_x && netplayer.y == Mouse.map_y
          MUI.getForm(MUI_ClickMenu).dispose if MUI.include?(MUI_ClickMenu)
          MUI_ClickMenu.new(netplayer.no)
        end
      end
    end
    return if MUI.nowTyping?
    if Key.trigger?(KEY_U)
      if MUI.include?(MUI_Status)
        MUI.getForm(MUI_Status).dispose
      else
        MUI_Status.new
      end
    elsif Key.trigger?(KEY_I)
      if MUI.include?(MUI_Inventory)
        MUI.getForm(MUI_Inventory).dispose
      else
        MUI_Inventory.new
      end
    elsif Key.trigger?(KEY_K)
      if MUI.include?(MUI_Skill)
        MUI.getForm(MUI_Skill).dispose
      else
        MUI_Skill.new
      end
    elsif Key.trigger?(KEY_SPACE)
      Socket.send({'header' => CTSHeader::ACTION})
    elsif Key.trigger?(KEY_Z)
      Socket.send({'header' => CTSHeader::PICK_ITEM})
    end
  end

  def transfer_player
    Game.player.transferring = false
    if Game.map.map_id != Game.player.new_map_id
      Game.map.setup(Game.player.new_map_id)
    end
    Game.player.moveto(Game.player.new_x, Game.player.new_y)
    case Game.player.new_direction
    when 2  # 하
      Game.player.turn_down
    when 4  # 왼쪽
      Game.player.turn_left
    when 6  # 오른쪽
      Game.player.turn_right
    when 8  # 상
      Game.player.turn_up
    end
    Game.player.straighten
    Game.map.update
    @mapSprite.dispose
    @mapSprite = MapSprite.new
    #if Game.screen.transition_processing
    #  Game.screen.transition_processing = false
    #  Graphics.transition(20)
    #end
    Game.map.autoplay
    Graphics.frame_reset
    Input.update
  end
end




#────────────────────────────────────────────────────────────────────────────
# ▶ Socket Library
# --------------------------------------------------------------------------
# Author    Ruby
# Version   1.8.1
#────────────────────────────────────────────────────────────────────────────
module Win32
  def copymem(len)
    buf = '\0' * len
    Win32API::RtlMoveMemory.call(buf, self, len)
    buf
  end
end

class Numeric
  include Win32
  def ref(length)
    buffer = "\\" * length
    Win32API::RtlMoveMemory.call(buffer, self, length)
    return buffer
  end
end

class String
  include Win32
  def ref(length)
    buffer = "\\" * length
    Win32API::RtlMoveMemory.call(buffer, self, length)
    return buffer
  end
end

class Network
  def self.call
    @closesocket = Win32API.new('ws2_32.dll', 'closesocket', 'p', 'l')
    @connect = Win32API.new('ws2_32.dll', 'connect', 'ppl', 'l')
    @gethostbyname = Win32API.new('ws2_32.dll', 'gethostbyname', 'p', 'l')
    @recv = Win32API.new('ws2_32.dll', 'recv', 'ppll', 'l')
    @select = Win32API.new('ws2_32.dll', 'select', 'lpppp', 'l')
    @send = Win32API.new('ws2_32.dll', 'send', 'ppll', 'l')
    @socket = Win32API.new('ws2_32.dll', 'socket', 'lll', 'l')
    @wsagetlasterror = Win32API.new('ws2_32.dll', 'WSAGetLastError', '', 'l')
  end
  
  def self.close
    ret = @closesocket.call($fd) rescue nil
    return ret
  end
  
  def self.connect(ip, port)
    check if ($fd = @socket.call(2, 1, 6)) == -1
    sockaddr = sockaddr_in(port, ip)
    ret = @connect.call($fd, sockaddr, sockaddr.size)
    check if ret == -1
    return ret
  end
  
  def self.gethostbyname(name)
    data = @gethostbyname.call(name)
    raise SocketError::ENOASSOCHOST if data == 0
    host = data.ref(16).unpack('LLssL')
    name = host[0].ref(256).unpack("c*").pack("c*").split("\0")[0]
    address_type = host[2]
    address_list = host[4].ref(4).unpack('L')[0].ref(4).unpack("c*").pack("c*")
    return [name, [], address_type, address_list]
    #ptr = @gethostbyname.call(name)
    #host = ptr.copymem(16).unpack('iissi')
    #p [host[0].copymem(16).split('\u0000')[0], [], host[2], host[4].copymem(4).unpack('l')[0].copymem(4)]
    #return [host[0].copymem(16).split('\u0000')[0], [], host[2], host[4].copymem(4).unpack('l')[0].copymem(4)]
  end
  
  def self.recv(len, flags = 0)
    buf = "\0" * len
    len = @recv.call($fd, buf, buf.size, flags)
    check if len == -1
    return buf, len
  end
  
  def self.select(timeout)
    ret = @select.call(1, [1, $fd].pack('ll'), 0, 0, [timeout, timeout * 1000000].pack('ll'))
    check if ret == -1
    return ret
  end
  
  def self.send(msg, flags = 0)
    ret = @send.call($fd, msg, msg.size, flags)
    check if ret == -1
    return ret
  end
  
  def self.sockaddr_in(port, host)
    return [2, port].pack('sn') + gethostbyname(host)[3] + [].pack('x8')
  end
  
  def self.ready?
    if select(0) != 0
      return true
    else
      return false
    end
  end
  
  def self.check
    errno = @wsagetlasterror.call
    if errno == 10053
      desc = "연결이 사용자의 호스트 시스템에 의해 중단되었습니다."
    elsif errno == 10054
      desc = "서버에서 현재 연결을 강제로 끊었습니다."
    elsif errno == 10061
      desc = "서버가 열리지 않아서 연결이 불가능 합니다."
    elsif errno == 10065
      desc = "네트워크 장애등에 의해 서버와 연결이 불가능 합니다."
    else
      desc = "시스템이 판단할 수 없는 에러입니다."
    end
    print desc
    exit
  end
end

#===============================================================================
# ** Socket
#-------------------------------------------------------------------------------
# Author    Lee SangHyuk
# Date      2013. 1. 8 *
#===============================================================================

class Socket
  attr_reader :pdata
  attr_reader :IsConnected
  
  def self.init
    @pdata = ""
    @isConnected = false
  end
  
  def self.connect(ip, port)
    Network.connect(ip, port)
    @isConnected = true
  end  
  
  def self.send(data)
    return if not @isConnected
    
    json_data = JSON.encode(data)
    msg = "\0" * (json_data.size + 4)
    msg[0] = [json_data.size >> 24 & 0xff].pack('U*')
    msg[1] = [json_data.size >> 16 & 0xff].pack('U*')
    msg[2] = [json_data.size >>  8 & 0xff].pack('U*')
    msg[3] = [json_data.size       & 0xff].pack('U*')
    for i in 0...json_data.size
      msg[4+i] = json_data[i]
    end
    msg += "\n"
    Network.send(msg)
  end
  
  def self.close
    Network.close# if Network
  end
  
  def self.update
    return if not @isConnected
    if Network.ready?
      temp, plen = Network.recv(0xffff)
      @pdata = @pdata + temp[0...plen]
    end
    @pdata.gsub!("\u0000", "")
    while @pdata.size > 2
      sIndex = 0
      eIndex = 0
      for i in 0...@pdata.size
        if @pdata[i] == "{"
          sIndex = i
        end
        if @pdata[i] == "}"
          eIndex = i
          break
        end
      end
      if sIndex < eIndex
        data = @pdata[sIndex..eIndex]
        self.recv(JSON.decode(data))
      end
      @pdata = @pdata[(eIndex + (eIndex == 0 ? 0 : 1))...@pdata.size]
    end
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ JSON Encoder/Decoder
# --------------------------------------------------------------------------
# Author    Game Gay, Unicode
# Modify    뮤 (mu29gl@gmail.com)
# Date      2012. 6. 21
# --------------------------------------------------------------------------
# Description
# 
#    소수를 포함한 값이 들어가면 int로 정상 반환되지 않는 문제 해결
#    음수 값이 반환되지 않는 문제 해결
#────────────────────────────────────────────────────────────────────────────

module JSON
  TOKEN_NONE = 0
  TOKEN_CURLY_OPEN = 1
  TOKEN_CURLY_CLOSED = 2
  TOKEN_SQUARED_OPEN = 3
  TOKEN_SQUARED_CLOSED = 4
  TOKEN_COLON = 5
  TOKEN_COMMA = 6
  TOKEN_STRING = 7
  TOKEN_NUMBER = 8
  TOKEN_TRUE = 9
  TOKEN_FALSE = 10
  TOKEN_NULL = 11
  
  @index = 0
  @json = ""
  @length = 0
  
  def self.decode(json)
    @json = json
    @index = 0
    @length = @json.length
    return self.parse
  end
  
  def self.encode(obj)
    if obj.is_a?(Hash)
      return self.encode_hash(obj)
    elsif obj.is_a?(Array)
      return self.encode_array(obj)
    elsif obj.is_a?(Fixnum) || obj.is_a?(Float)
      return self.encode_integer(obj)
    elsif obj.is_a?(String)
      return self.encode_string(obj)
    elsif obj.is_a?(TrueClass) || obj.is_a?(FalseClass)
      return self.encode_bool(obj)
    elsif obj.is_a?(NilClass)
      return "null"
    end
    return nil
  end
  
  def self.encode_hash(hash)
    string = "{"
    hash.each_key {|key|
      string += "\"#{key}\":" + self.encode(hash[key]).to_s + ","
    }
    string[string.size - 1, 1] = "}"
    return string
  end
  
  def self.encode_array(array)
    string = "["
    array.each {|i|
      string += self.encode(i).to_s + ","
    }
    string[string.size - 1, 1] = "]"
    return string
  end
  
  def self.encode_string(string)
    return "\"#{string}\""
  end
  
  def self.encode_integer(int)
    return int.to_s
  end
  
  def self.encode_bool(bool)
    return (bool.is_a?(TrueClass) ? "true" : "false")
  end
  
  def self.next_token(debug = 0)
    char = @json[@index, 1]
    @index += 1
    case char
    when '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '-' 
      return TOKEN_NUMBER
    when '{' 
      return TOKEN_CURLY_OPEN
    when '}' 
      return TOKEN_CURLY_CLOSED
    when '"' 
      return TOKEN_STRING
    when ',' 
      return TOKEN_COMMA
    when '['
      return TOKEN_SQUARED_OPEN
    when ']'
      return TOKEN_SQUARED_CLOSED
    when ':' 
      return TOKEN_COLON
    end
    @index -= 1
    if @json[@index, 5] == "false"
      @index += 5
      return TOKEN_FALSE
    elsif @json[@index, 4] == "true"
      @index += 4
      return TOKEN_TRUE
    elsif @json[@index, 4] == "null"
      @index += 4
      return TOKEN_NULL
    end
    return TOKEN_NONE
  end
  
  def self.parse(debug = 0)
    complete = false
    while !complete
      if @index >= @length
        break
      end
      token = self.next_token
      case token
      when TOKEN_NONE
        return nil
      when TOKEN_NUMBER
        return self.parse_number
      when TOKEN_CURLY_OPEN
        return self.parse_object
      when TOKEN_STRING
        return self.parse_string
      when TOKEN_SQUARED_OPEN
        return self.parse_array
      when TOKEN_TRUE
        return true
      when TOKEN_FALSE
        return false
      when TOKEN_NULL
        return nil
      end
    end
  end
  
  def self.parse_object
    obj = {}
    complete = false
    while !complete
      token = self.next_token
      if token == TOKEN_CURLY_CLOSED
        complete = true
        break
      elsif token == TOKEN_NONE
        return nil
      elsif token == TOKEN_COMMA
      else
        name = self.parse_string
        return nil if name == nil
        token = self.next_token
        return nil if token != TOKEN_COLON
        value = self.parse
        obj[name] = value
      end
    end
    return obj
  end
  
  def self.parse_string
    complete = false
    string = ""
    while !complete
      break if @index >= @length
      char = @json[@index, 1]
      @index += 1
      case char
      when '"'
        complete = true
        break
      else
        string += char.to_s
      end
    end
    if !complete
      return nil
    end
    return string
  end
  
  def self.parse_number
    @index -= 1
    negative = @json[@index, 1] == "-" ? true : false
    string = ""
    complete = false
    while !complete
      break if @index >= @length
      char = @json[@index, 1]
      @index += 1
      case char
      when "{", "}", ":", ",", "[", "]"
        @index -= 1
        complete = true
        break
      when "0", "1", "2", '3', '4', '5', '6', '7', '8', '9', '.'
        string += char.to_s
      end
    end
    number = string.to_i
    return negative ? -number : number
  end
  
  def self.parse_array
    obj = []
    complete = false
    while !complete
      token = self.next_token(1)
      if token == TOKEN_SQUARED_CLOSED
        complete = true
        break
      elsif token == TOKEN_NONE
        return nil
      elsif token == TOKEN_COMMA
      else
        @index -= 1
        value = self.parse
        obj.push(value)
      end
    end
    return obj
  end
end

#────────────────────────────────────────────────────────────────────────────
# ▶ Header
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com)
# Date      2014
# --------------------------------------------------------------------------
# Description
# 
#    패킷 인덱스를 지정하는 헤더 모듈입니다.
#────────────────────────────────────────────────────────────────────────────
module CTSHeader
	LOGIN = 0
	REGISTER = 1
	MOVE_CHARACTER = 2
	TURN_CHARACTER = 3
  REMOVE_EQUIP_ITEM = 4
	USE_STAT_POINT = 5
	ACTION = 6
	USE_ITEM = 7
	USE_SKILL = 8
  DROP_ITEM = 9
  DROP_GOLD = 10
  PICK_ITEM = 11
  CHAT = 12
	
	OPEN_REGISTER_WINDOW = 100
	CHANGE_ITEM_INDEX = 101
	REQUEST_TRADE = 102
	RESPONSE_TRADE = 103
	LOAD_TRADE_ITEM = 104
	DROP_TRADE_ITEM = 105
	CHANGE_TRADE_GOLD = 106
	FINISH_TRADE = 107
  CANCEL_TRADE = 108
  SELECT_MESSAGE = 109
	CREATE_PARTY = 110
	INVITE_PARTY = 111
	RESPONSE_PARTY = 112
	QUIT_PARTY = 113
	KICK_PARTY = 114
	BREAK_UP_PARTY = 115
	CREATE_GUILD = 116
	INVITE_GUILD = 117
	RESPONSE_GUILD = 118
	QUIT_GUILD = 119
	KICK_GUILD = 120
	BREAK_UP_GUILD = 121
  BUY_SHOP_ITEM = 122
  
  SET_SLOT = 200
  DEL_SLOT = 201
end

module STCHeader
  LOGIN = 0
	REGISTER = 1
	MOVE_CHARACTER = 2
	TURN_CHARACTER = 3
	CREATE_CHARACTER = 4
	REMOVE_CHARACTER = 5
	REFRESH_CHARACTER = 6
  JUMP_CHARACTER = 7
  ANIMATION_CHARACTER = 8
  MOTION_CHARACTER = 9
	UPDATE_CHARACTER = 10
  DAMAGE_CHARACTER = 11
  LOAD_DROP_ITEM = 12
	LOAD_DROP_GOLD = 13
	REMOVE_DROP_ITEM = 14
	REMOVE_DROP_GOLD = 15
	NOTIFY = 16
  MOVE_MAP = 17
  CHAT = 18
	
	OPEN_REGISTER_WINDOW = 100
	UPDATE_STATUS = 101
	SET_ITEM = 102
	UPDATE_ITEM = 103
	SET_SKILL = 104
	UPDATE_SKILL = 105
	REQUEST_TRADE = 106
	OPEN_TRADE_WINDOW = 107
	LOAD_TRADE_ITEM = 108
	DROP_TRADE_ITEM = 109
  CHANGE_TRADE_GOLD = 110
	FINISH_TRADE = 111
  CANCEL_TRADE = 112
	OPEN_MESSAGE_WINDOW = 113
	CLOSE_MESSAGE_WINDOW = 114
	SET_SHOP_ITEM = 115
	SET_PARTY  = 116
	INVITE_PARTY = 117
	SET_PARTY_MEMBER = 118
	REMOVE_PARTY_MEMBER = 119
	CREATE_GUILD = 120
	SET_GUILD = 121
	INVITE_GUILD = 122
	SET_GUILD_MEMBER = 123
	REMOVE_GUILD_MEMBER = 124
  OPEN_SHOP_WINDOW = 125
  
  SET_SLOT = 200
  SET_COOLTIME = 201
end
#────────────────────────────────────────────────────────────────────────────
# ▶ Packet
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com)
# Date      2014
# --------------------------------------------------------------------------
# Description
# 
#    각종 패킷을 받아 처리를 담당하는 클래스입니다.
#────────────────────────────────────────────────────────────────────────────

class Socket
  include Game
  def self.recv(recv)
    #begin
    return if not recv
    case recv["header"]
    when STCHeader::LOGIN
      case recv["type"]
      when 0
        Game.player.no = recv["no"]
        Game.player.id = recv["id"]
        Game.player.name = recv["name"]
        Game.player.title = recv["title"]
        Game.player.image = recv["image"]
        Game.player.job = recv["job"]
        Game.player.guild = recv["guild"]
        Game.player.guildNo = recv["guildNo"]
        Game.player.statPoint = recv["statPoint"]
        Game.player.skillPoint = recv["skillPoint"]
        Game.player.str = recv["str"]
        Game.player.dex = recv["dex"]
        Game.player.agi = recv["agi"]
        Game.player.critical = recv["critical"]
        Game.player.hit = recv["hit"]
        Game.player.avoid = recv["avoid"]
        Game.player.hp = recv["hp"]
        Game.player.maxHp = recv["maxHp"]
        Game.player.mp = recv["mp"]
        Game.player.maxMp = recv["maxMp"]
        Game.player.level = recv["level"]
        Game.player.exp = recv["exp"]
        Game.player.maxExp = recv["maxExp"]
        Game.player.gold = recv["gold"]
        Game.player.map = recv["map"]
        Game.player.x = recv["x"]
        Game.player.y = recv["y"]
        Game.player.direction = recv["direction"]
        # Equip
        Game.player.weapon = recv["weapon"]
        Game.player.shield = recv["shield"]
        Game.player.helmet = recv["helmet"]
        Game.player.armor = recv["armor"]
        Game.player.cape = recv["cape"]
        Game.player.shoes = recv["shoes"]
        Game.player.accessory = recv["accessory"]
        Game.map.setup(Game.player.map)
        Game.player.moveto(Game.player.x, Game.player.y)
        Game.player.refresh
        Game.map.autoplay
        $scene = Scene_Map.new
        Game.map.update
      when 1
        dialog = MUI_Dialog.new(Dialog::LOGIN, "로그인 실패", "아이디와 비밀번호를 확인해주세요.", ["닫기"]) do
          dialog.dispose if dialog.value == 0
        end
      end
    when STCHeader::REGISTER
      case recv["type"]
      when 0
        dialog = MUI_Dialog.new(Dialog::REGISTER, "가입 성공", "가입이 완료되었습니다.", ["닫기"]) do
          dialog.dispose if dialog.value == 0
        end
      when 1
        dialog = MUI_Dialog.new(Dialog::REGISTER, "가입 실패", "이미 존재하는 아이디입니다.", ["닫기"]) do
          dialog.dispose if dialog.value == 0
        end
      when 2
        dialog = MUI_Dialog.new(Dialog::REGISTER, "가입 실패", "이미 존재하는 닉네임입니다.", ["닫기"]) do
          dialog.dispose if dialog.value == 0
        end
      when 3
        dialog = MUI_Dialog.new(Dialog::REGISTER, "가입 실패", "알 수 없는 오류입니다.", ["닫기"]) do
          dialog.dispose if dialog.value == 0
        end
      end
    when STCHeader::CREATE_CHARACTER
      character = case recv["type"]
      when CharacterType::USER; Game.map.addNetplayer(recv["no"], Netplayer.new)
      when CharacterType::NPC; Game.map.addNPC(recv["no"], NPC.new)
      when CharacterType::ENEMY; Game.map.addEnemy(recv["no"], Enemy.new) end
      return if not character
      character.no = recv["no"]
      character.name = recv["name"]
      character.image = recv["image"]
      character.hp = recv["hp"]
      character.maxHp = recv["maxHp"]
      character.moveto(recv["x"], recv["y"])
      character.direction = recv["d"]
      character.setGraphic(recv["image"], 0)
      if recv["type"] == 0
        character.title = recv["title"]
        character.guild = recv["guild"]
      end
      create_sprite(character)
      character.refresh
    when STCHeader::REMOVE_CHARACTER
      case recv["type"]
      when 0
        character = Game.map.getNetplayer(recv["no"])
        Game.map.removeNetplayer(recv["no"])
      when 1
        character = Game.map.getNPC(recv["no"])
        Game.map.removeNPC(recv["no"])
      when 2
        character = Game.map.getEnemy(recv["no"])
        Game.map.removeEnemy(recv["no"])
      end
      remove_sprite(character)
    when STCHeader::MOVE_CHARACTER
      case recv["type"]
      when 0
        netplayer = Game.map.getNetplayer(recv["no"])
        return if not netplayer
        netplayer.addMove(recv["d"])
        netplayer.finalX = recv["x"]
        netplayer.finalY = recv["y"]
        netplayer.startSync = true
      when 1
        p "npc"
      when 2
        enemy = Game.map.getEnemy(recv["no"])
        return if not enemy
        case recv["d"]
        when 2
          enemy.move_down
        when 4
          enemy.move_left
        when 6
          enemy.move_right
        when 8
          enemy.move_up
        end
        enemy.finalX = recv["x"]
        enemy.finalY = recv["y"]
      end
    when STCHeader::TURN_CHARACTER
      character = case recv["type"]
      when CharacterType::USER; Game.map.getNetplayer(recv["no"])
      when CharacterType::NPC; Game.map.getNPC(recv["no"])
      when CharacterType::ENEMY; Game.map.getEnemy(recv["no"]) end
      return if not character
      case recv["d"]
      when 2
        character.turn_down
      when 4
        character.turn_left
      when 6
        character.turn_right
      when 8
        character.turn_up
      end
    when STCHeader::REFRESH_CHARACTER
      character = case recv["type"]
      when CharacterType::USER; (Game.player.no == recv["no"] ? Game.player : Game.map.getNetplayer(recv["no"]))
      when CharacterType::NPC; Game.map.getNPC(recv["no"])
      when CharacterType::ENEMY; Game.map.getEnemy(recv["no"]) end
      return if not character
      character.moveto(recv["x"], recv["y"])
      character.direction = recv["d"]
      character.refresh
    when STCHeader::JUMP_CHARACTER
      character = case recv["type"]
      when CharacterType::USER; (Game.player.no == recv["no"] ? Game.player : Game.map.getNetplayer(recv["no"]))
      when CharacterType::NPC; Game.map.getNPC(recv["no"])
      when CharacterType::ENEMY; Game.map.getEnemy(recv["no"]) end
      return if not character
      character.jumpTo(recv["x"], recv["y"])
      character.refresh
    when STCHeader::ANIMATION_CHARACTER
      character = case recv["type"]
      when CharacterType::USER; (Game.player.no == recv["no"] ? Game.player : Game.map.getNetplayer(recv["no"]))
      when CharacterType::NPC; Game.map.getNPC(recv["no"])
      when CharacterType::ENEMY; Game.map.getEnemy(recv["no"]) end
      return if not character
      character.animation_id = recv["ani"]
    when STCHeader::UPDATE_CHARACTER
      character = case recv["type"]
      when CharacterType::USER; Game.map.getNetplayer(recv["no"])
      when CharacterType::NPC; Game.map.getNPC(recv["no"])
      when CharacterType::ENEMY; Game.map.getEnemy(recv["no"]) end
      return if not character
      character.title = recv["#{StatusType::TITLE}"] if recv["#{StatusType::TITLE}"]
      character.job = recv["StatusType::JOB"] if recv["StatusType::JOB"]
      character.image = recv["StatusType::IMAGE"] if recv["StatusType::IMAGE"]
      character.maxHp = recv["StatusType::MAX_HP"] if recv["StatusType::MAX_HP"]
      character.level = recv["#{StatusType::LEVEL}"] if recv["#{StatusType::LEVEL}"]
      character.hp = recv["#{StatusType::HP}"] if recv["#{StatusType::HP}"]
    when STCHeader::DAMAGE_CHARACTER
      character = case recv["type"]
      when CharacterType::USER; (Game.player.no == recv["no"] ? Game.player : Game.map.getNetplayer(recv["no"]))
      when CharacterType::NPC; Game.map.getNPC(recv["no"])
      when CharacterType::ENEMY; Game.map.getEnemy(recv["no"]) end
      return if not character
      Damage.new(character, recv["value"], !recv["critical"].nil?)
    when STCHeader::LOAD_DROP_ITEM
      item = Game.map.addItem(recv["no"], Character.new)
      return if not item
      item.isIcon = true
      item.setGraphic(recv["image"], 0)
      item.moveto(recv["x"], recv["y"])
      create_sprite(item)
    when STCHeader::LOAD_DROP_GOLD
      item = Game.map.addItem(recv["no"], Character.new)
      return if not item
      item.isIcon = true
      item.setGraphic("032-Item01", 0)
      item.moveto(recv["x"], recv["y"])
      create_sprite(item)
    when STCHeader::REMOVE_DROP_ITEM
      item = Game.map.getItem(recv["no"])
      Game.map.removeItem(recv["no"])
      remove_sprite(item)
    when STCHeader::REMOVE_DROP_GOLD
      item = Game.map.getItem(recv["no"])
      Game.map.removeItem(recv["no"])
      remove_sprite(item)
    when STCHeader::NOTIFY
    when STCHeader::MOVE_MAP
      return if !$scene.is_a?(Scene_Map)
      Game.player.new_map_id = recv["map"]
      Game.player.new_x = recv["x"]
      Game.player.new_y = recv["y"]
      Game.player.transferring = true
      $scene.transfer_player
    when STCHeader::CHAT
      color1 = Color.new(recv["r"], recv["g"], recv["b"]) if recv["r"]
      color2 = Color.new(recv["r2"], recv["g2"], recv["b2"]) if recv["r2"]
      MUI::Console.write(recv["message"], color1 ? color1 : Color.white, color2 ? color2 : Color.black)
    when STCHeader::OPEN_REGISTER_WINDOW
      MUI_Register.new(recv["image"], recv["job"])
    when STCHeader::UPDATE_STATUS
      Game.player.title = recv["#{StatusType::TITLE}"] if recv["#{StatusType::TITLE}"]
      Game.player.image = recv["#{StatusType::IMAGE}"] if recv["#{StatusType::IMAGE}"]
      Game.player.job = recv["#{StatusType::JOB}"] if recv["#{StatusType::JOB}"]
      Game.player.str = recv["#{StatusType::STR}"] if recv["#{StatusType::STR}"]
      Game.player.dex = recv["#{StatusType::DEX}"] if recv["#{StatusType::DEX}"]
      Game.player.agi = recv["#{StatusType::AGI}"] if recv["#{StatusType::AGI}"]
      Game.player.critical = recv["#{StatusType::CRITICAL}"] if recv["#{StatusType::CRITICAL}"]
      Game.player.avoid = recv["#{StatusType::AVOID}"] if recv["#{StatusType::AVOID}"]
      Game.player.hit = recv["#{StatusType::HIT}"] if recv["#{StatusType::HIT}"]
      Game.player.statPoint = recv["#{StatusType::STAT_POINT}"] if recv["#{StatusType::STAT_POINT}"]
      Game.player.skillPoint = recv["#{StatusType::SKILL_POINT}"] if recv["#{StatusType::SKILL_POINT}"]
      Game.player.hp = recv["#{StatusType::HP}"] if recv["#{StatusType::HP}"]
      Game.player.maxHp = recv["#{StatusType::MAX_HP}"] if recv["#{StatusType::MAX_HP}"]
      Game.player.mp = recv["#{StatusType::MP}"] if recv["#{StatusType::MP}"]
      Game.player.maxMp = recv["#{StatusType::MAX_MP}"] if recv["#{StatusType::MAX_MP}"]
      Game.player.level = recv["#{StatusType::LEVEL}"] if recv["#{StatusType::LEVEL}"]
      Game.player.exp = recv["#{StatusType::EXP}"] if recv["#{StatusType::EXP}"]
      Game.player.maxExp = recv["#{StatusType::MAX_EXP}"] if recv["#{StatusType::MAX_EXP}"]
      if recv["#{StatusType::GOLD}"]
        Game.player.gold = recv["#{StatusType::GOLD}"]
        MUI.getForm(MUI_Inventory).refreshData if MUI.include?(MUI_Inventory)
      end
      Game.player.weapon = recv["#{StatusType::WEAPON}"] if recv["#{StatusType::WEAPON}"]
      Game.player.shield = recv["#{StatusType::SHIELD}"] if recv["#{StatusType::SHIELD}"]
      Game.player.helmet = recv["#{StatusType::HELMET}"] if recv["#{StatusType::HELMET}"]
      Game.player.armor = recv["#{StatusType::ARMOR}"] if recv["#{StatusType::ARMOR}"]
      Game.player.cape = recv["#{StatusType::CAPE}"] if recv["#{StatusType::CAPE}"]
      Game.player.shoes = recv["#{StatusType::SHOES}"] if recv["#{StatusType::SHOES}"]
      Game.player.accessory = recv["#{StatusType::ACCESSORY}"] if recv["#{StatusType::ACCESSORY}"]
      MUI.getForm(MUI_Status).refreshData if MUI.include?(MUI_Status)
    when STCHeader::SET_ITEM
      item = Item.new(recv["userNo"], recv["itemNo"], 
                      recv["amount"], recv["index"], 
                      recv["damage"], recv["magicDamage"], 
                      recv["defense"], recv["magicDefense"], 
                      recv["str"], recv["dex"], 
                      recv["agi"], recv["hp"], 
                      recv["mp"], recv["critical"], 
                      recv["avoid"], recv["hit"], 
                      recv["reinforce"], recv["trade"],
                      recv["equipped"])
      Game.player.addItem(recv["index"], item)
      MUI.getForm(MUI_Inventory).refreshData if MUI.include?(MUI_Inventory)
    when STCHeader::UPDATE_ITEM
      case recv["type"]
      when 0
        Game.player.removeItem(recv["index"])
      when 1
        Game.player.updateItem(recv["index"], recv["amount"],
                              recv["damage"], recv["magicDamage"], 
                              recv["defense"], recv["magicDefense"], 
                              recv["str"], recv["dex"], 
                              recv["agi"], recv["hp"], 
                              recv["mp"], recv["critical"], 
                              recv["avoid"], recv["hit"], 
                              recv["reinforce"], recv["trade"],
                              recv["equipped"])
      end
      MUI.getForm(MUI_Inventory).refreshData if MUI.include?(MUI_Inventory)
    when STCHeader::SET_SKILL
      skill = Skill.new(recv["no"], recv["rank"])
      Game.player.addSkill(skill)
      MUI.getForm(MUI_Skill).refreshData if MUI.include?(MUI_Skill)
    when STCHeader::UPDATE_SKILL
      case recv["type"]
      when 0
        Game.player.removeSkill(recv["no"])
      when 1
        Game.player.updateSkill(recv["no"], recv["rank"])
      end
    when STCHeader::REQUEST_TRADE
      partner = Game.map.getNetplayer(recv["partnerNo"])
      return if not partner
      dialog = MUI_Dialog.new(Dialog::TRADE_REQUEST, "거래 요청", partner.name + " 님이 거래를 요청하셨습니다.", ["수락", "거절"]) do
        if dialog.value == 0
          Socket.send({"header" => CTSHeader::RESPONSE_TRADE, "type" => 0, "partner" => partner.no})
          dialog.dispose
        elsif dialog.value == 1
          Socket.send({"header" => CTSHeader::RESPONSE_TRADE, "type" => 1, "partner" => partner.no})
          dialog.dispose
        end
      end
    when STCHeader::OPEN_TRADE_WINDOW
      partner = Game.map.getNetplayer(recv["partnerNo"])
      return if not partner
      MUI_Trade.new(partner)
    when STCHeader::LOAD_TRADE_ITEM
      item = Item.new(recv["userNo"], recv["itemNo"], 
                      recv["amount"], recv["index"], 
                      recv["damage"], recv["magicDamage"], 
                      recv["defense"], recv["magicDefense"], 
                      recv["str"], recv["dex"], 
                      recv["agi"], recv["hp"], 
                      recv["mp"], recv["critical"], 
                      recv["avoid"], recv["hit"], 
                      recv["reinforce"], 1, 0)
      if MUI.include?(MUI_Trade)
        MUI.getForm(MUI_Trade).addMyItem(recv["index"], item) if Game.player.no == recv["userNo"]
        MUI.getForm(MUI_Trade).addPartnerItem(recv["index"], item) if MUI.getForm(MUI_Trade).user.no == recv["userNo"]
      end
    when STCHeader::DROP_TRADE_ITEM
      if MUI.include?(MUI_Trade)
        MUI.getForm(MUI_Trade).removeMyItem(recv["index"]) if Game.player.no == recv["no"]
        MUI.getForm(MUI_Trade).removePartnerItem(recv["index"]) if MUI.getForm(MUI_Trade).user.no == recv["no"]
      end
    when STCHeader::CHANGE_TRADE_GOLD
      MUI.getForm(MUI_Trade).setGold(recv["no"], recv["amount"]) if MUI.include?(MUI_Trade)
    when STCHeader::FINISH_TRADE
      MUI.getForm(MUI_Trade).acceptTrade(recv["no"]) if MUI.include?(MUI_Trade)
    when STCHeader::CANCEL_TRADE
      MUI.getForm(MUI_Trade).dispose if MUI.include?(MUI_Trade)
    when STCHeader::OPEN_MESSAGE_WINDOW
      MUI_Message.new(recv["no"]) if !MUI.include?(MUI_Message)
      MUI.getForm(MUI_Message).set(recv["message"], recv["select"])
    when STCHeader::CLOSE_MESSAGE_WINDOW
      MUI.getForm(MUI_Message).dispose if MUI.include?(MUI_Message)
    when STCHeader::OPEN_SHOP_WINDOW
      Game.player.shopNo = recv["no"]
      Game.player.clearShopItem
      MUI_Shop.new 
    when STCHeader::SET_SHOP_ITEM
      return if !MUI.include?(MUI_Shop)
      item = Item.new(0, recv["no"], 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
      Game.player.addShopItem(item)
      MUI.getForm(MUI_Shop).refreshData
    when STCHeader::SET_PARTY
      Game.player.partyNo = recv["no"]
      if Game.player.partyNo == 0
        Game.player.party_member = []
        MUI.getForm(MUI_Community).refreshData if MUI.include?(MUI_Community)
      end
    when STCHeader::SET_PARTY_MEMBER
      member = Netplayer.new
      member.no = recv["no"]
      member.name = recv["name"]
      member.image = recv["image"]
      member.level = recv["level"]
      member.job = recv["job"]
      member.hp = recv["hp"]
      member.maxHp = recv["maxHp"]
      Game.player.party_member.push(member)
      MUI.getForm(MUI_Community).refreshData if MUI.include?(MUI_Community)
    when STCHeader::REMOVE_PARTY_MEMBER
      for member in Game.player.party_member
        if member.no == recv["no"]
          Game.player.party_member.delete(member)
          break
        end
      end
      MUI.getForm(MUI_Community).refreshData if MUI.include?(MUI_Community)
    when STCHeader::INVITE_PARTY
      partyNo = recv["partyNo"]
      dialog = MUI_Dialog.new(Dialog::PARTY_INVITE, "파티 초대", recv["master"] + " 님의 파티에 가입하시겠습니까?", ["수락", "거절"]) do
        if dialog.value == 0
          Socket.send({"header" => CTSHeader::RESPONSE_PARTY, "type" => 0, "partyNo" => partyNo})
          dialog.dispose
        elsif dialog.value == 1
          Socket.send({"header" => CTSHeader::RESPONSE_PARTY, "type" => 1, "partyNo" => partyNo})
          dialog.dispose
        end
      end
    when STCHeader::CREATE_GUILD
      dialog = MUI_Dialog.new(Dialog::GUILD_CREATE, "길드 생성", "길드를 생성합니다.", ["수락", "거절"], ["길드 이름을 입력하세요."]) do
        if dialog.value == 0
          Socket.send({"header" => CTSHeader::CREATE_GUILD, "name" => dialog.textbox[0].text}) if dialog.textbox[0].text != ""
          dialog.dispose
        elsif dialog.value == 1
          dialog.dispose
        end
      end
    when STCHeader::SET_GUILD
      Game.player.guildNo = recv["no"]
      if Game.player.guildNo == 0
        Game.player.guild_member = []
        MUI.getForm(MUI_Community).refreshData if MUI.include?(MUI_Community)
      end
    when STCHeader::SET_GUILD_MEMBER
      member = Netplayer.new
      member.no = recv["no"]
      member.name = recv["name"]
      member.image = recv["image"]
      member.level = recv["level"]
      member.job = recv["job"]
      member.hp = recv["hp"]
      member.maxHp = recv["maxHp"]
      Game.player.guild_member.push(member)
      MUI.getForm(MUI_Community).refreshData if MUI.include?(MUI_Community)
    when STCHeader::REMOVE_GUILD_MEMBER
      for member in Game.player.guild_member
        if member.no == recv["no"]
          Game.player.guild_member.delete(member)
          break
        end
      end
      MUI.getForm(MUI_Community).refreshData if MUI.include?(MUI_Community)
    when STCHeader::INVITE_GUILD
      guildNo = recv["guildNo"]
      dialog = MUI_Dialog.new(Dialog::GUILD_INVITE, "길드 초대", recv["master"] + " 님의 길드에 가입하시겠습니까?", ["수락", "거절"]) do
        if dialog.value == 0
          Socket.send({"header" => CTSHeader::RESPONSE_GUILD, "type" => 0, "guildNo" => guildNo})
          dialog.dispose
        elsif dialog.value == 1
          Socket.send({"header" => CTSHeader::RESPONSE_GUILD, "type" => 1, "guildNo" => guildNo})
          dialog.dispose
        end
      end
    when STCHeader::SET_SLOT
      Game.slot.setSlot(recv["index"], recv["slot"])
      $scene.hud.slotRefresh(:icon_shortcut) if $scene.is_a?(Scene_Map)
    when STCHeader::SET_COOLTIME
      Game.cooltime.setCool(recv['index'], recv['nowCooltime'], recv['fullCooltime'])
    end
    #rescue
    #  p $!
    #end
  end
end




#────────────────────────────────────────────────────────────────────────────
# ▶ MUI3
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com)
# Date      2013
# --------------------------------------------------------------------------
# Description
# 
#    Mu User Interface 3 메인 클래스입니다.
#────────────────────────────────────────────────────────────────────────────

class MUI
  def self.init
    @inputs = []
    @forms = []
    @focus = nil
    @dragItem = nil
    @dragItemSprite = Sprite.new
    @dragItemSprite.z = 999999
    @cursor = MUI::Cursor.new
    ItemInfo.init
    SkillInfo.init
    @z = 99999
  end
  
  def self.addForm(form)
    @forms.push(form)
    self.setFocus(form)
    @z += 1
    form.z = @z
  end
  
  def self.deleteForm(form)
    @forms.delete(form)
    self.findFocus
  end
  
  def self.addInput(ime)
    @inputs.push(ime)
  end
  
  def self.deleteInput(ime)
    @inputs.delete(ime)
  end
  
  def self.nowTyping?
    for input in @inputs
      return true if input.focus
    end
    return false
  end
  
  def self.getFocus
    return @focus
  end
  
  def self.setFocus(form)
    @focus.disposeToolTip if @focus
    @focus = form
    @forms.delete(form)
    @forms.push(form)
    @z += 1
    form.z = @z
  end
  
  def self.findFocus
    @focus = @forms.size > 0 ? @forms[@forms.size - 1] : nil
  end
  
  def self.message
    return @message
  end
  
  def self.getForm(ui)
    for form in @forms
      return form if form.is_a?(ui)
    end
  end
  
  def self.include?(ui)
    for form in @forms
      return true if form.is_a?(ui)
    end
    return false
  end
  
  def self.checkFocus
    if Mouse.trigger? || Mouse.trigger?(1)
      for i in 0...@forms.size
        if @forms[@forms.size - i - 1].isMouseOver
          setFocus(@forms[@forms.size - i - 1]) if @focus != @forms[@forms.size - i - 1]
          break
        end
      end
    end
  end
  
  def self.dragItem; @dragItem end
  def self.dragItem=(value)
    return if @dragItem == value
    @dragItem = value
    if value.is_a?(Item)
      @cursor.setImage(RPG::Cache.icon(Game.getItem(@dragItem.itemNo).image))
    elsif value.is_a?(Skill)
      @cursor.setImage(RPG::Cache.icon(Game.getSkill(@dragItem.no).image))
    elsif value.is_a?(NilClass)
      @cursor.setDefaultImage
    end
  end
    
  def self.update
    Key.update
    Input.update
    Mouse.update
    checkFocus
    @focus.update if @focus
    if Mouse.x && Mouse.y
      @cursor.update
      ItemInfo.update
      SkillInfo.update
      if @dragItem
        @dragItemSprite.x = Mouse.x
        @dragItemSprite.y = Mouse.y
      end
    end
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ MUI::Function
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com)
# Date      2013
# --------------------------------------------------------------------------
# Description
# 
#    MUI 에서 사용하는 함수를 담당하는 클래스입니다.
#────────────────────────────────────────────────────────────────────────────
module RPG
  module Cache
    def self.mui(filename)
      self.load_bitmap("Graphics/MUI/", filename)
    end

    def self.form(filename)
      self.load_bitmap("Graphics/MUI/Form/", filename)
    end
    
    def self.button(filename)
      self.load_bitmap("Graphics/MUI/Button/", filename)
    end
    
    def self.textBox(filename)
      self.load_bitmap("Graphics/MUI/TextBox/", filename)
    end
    
    def self.checkBox(filename)
      self.load_bitmap("Graphics/MUI/CheckBox/", filename)
    end
    
    def self.radioBox(filename)
      self.load_bitmap("Graphics/MUI/RadioBox/", filename)
    end
    
    def self.vScroll(filename)
      self.load_bitmap("Graphics/MUI/VScroll/", filename)
    end
    
    def self.hScroll(filename)
      self.load_bitmap("Graphics/MUI/HScroll/", filename)
    end
    
    def self.tab(filename)
      self.load_bitmap("Graphics/MUI/Tab/", filename)
    end
    
    def self.hud(filename)
      self.load_bitmap("Graphics/MUI/HUD/", filename)
    end
    
    def self.damage(filename)
      self.load_bitmap("Graphics/Damage/", filename)
    end
  end
end

def comment_include(*args)
  list = *args[0].list
  trigger = *args[1]
  split = *args[2]
  return nil if list == nil
  return nil unless list.is_a?(Array)
  for item in list
    next if item.code != 108
    if split
      par = item.parameters[0].split(' | ')
      return item.parameters[0] if par[0] == trigger
    else
      return item.parameters[0] if item.parameters[0] == trigger
    end
  end
  return nil
end

def create_sprite(c)
  if $scene.is_a?(Scene_Map)
    $scene.instance_eval do
      @mapSprite.instance_eval do
        return if not @character_sprites
        @character_sprites.each do |v|
          if v.character == c
            return v
          end
        end
        sprite = CharacterSprite.new(@viewport1, c) #해상도
        @character_sprites.push(sprite)
      end
    end
  end
  return nil
end

def remove_sprite(c)
  if $scene.is_a?(Scene_Map)
    $scene.instance_eval do
      @mapSprite.instance_eval do
        delv = nil
        @character_sprites.each do |v|
          if v.character == c
            v.erase = 1
            break
          end
        end
      end
    end
  end
  return nil
end
#────────────────────────────────────────────────────────────────────────────
# ▶ Math
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com)
# Date      2014
#────────────────────────────────────────────────────────────────────────────
module Math
  # 원(W) 단위 절사함수 : 1000 => 1,000
  def self.unitMoney(num)
    num = num.to_s
    a = num.split(//).reverse
    result = ""
    for i in 0...a.size
      if i % 3 == 0 && i != 0
        result += ','
      end
      result += a[i]
    end
    return result.reverse.to_s
  end
end
class MUI
  class Temp
    @status = Rect.new(0, 0, 0, 0)
    @inventory = Rect.new(0, 0, 0, 0)
    @skill = Rect.new(0, 0, 0, 0)
    @option = Rect.new(0, 0, 0, 0)
    @community = Rect.new(0, 0, 0, 0)
    @quest = Rect.new(0, 0, 0, 0)
  end
end

#────────────────────────────────────────────────────────────────────────────
# ▶ MUI::Form
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2014
# --------------------------------------------------------------------------
# Description
# 
#    폼을 담당하는 클래스입니다.
#────────────────────────────────────────────────────────────────────────────
class MUI
  class Form
    def initialize(x, y, w, h)
      @x = (x == 'center' ? (Graphics.width - w) / 2 : x)
      @y = (y == 'center' ? (Graphics.height - h) / 2 : y)
      @width = w
      @height = h
      @opacity = 255
      @captionText = nil
      @drag = true
      @close = true
      @controls = []
      @@cache = {}
      @style = "White"
      loadCache(@style)
      # 뷰포트, 스프라이트, 비트맵 생성
      titleHeight = @@cache['TM'].height
      @titleViewport = Viewport.new(@x, @y, @width, titleHeight)
      @baseViewport = Viewport.new(@x, @y + titleHeight, @width, @height - titleHeight)
      @titleSprite = Sprite.new(@titleViewport)
      @captionSprite = Sprite.new(@titleViewport)
      @baseSprite = Sprite.new(@baseViewport)
      @titleSprite.bitmap = Bitmap.new(@width, titleHeight)
      @captionSprite.bitmap = Bitmap.new(@width, titleHeight)
      @baseSprite.bitmap = Bitmap.new(@width, @height - titleHeight)
      # 닫기 버튼
      @pic_close = MUI::PictureBox.new(@width - @@cache['X'].width * 1.5, (@titleViewport.rect.height - @@cache['X'].height).abs / 2, @@cache['X'].width, @@cache['X'].height)
      @pic_close.picture = @@cache['X']
      addTitleControl(@pic_close)
      @pic_close.visible = @close
      # 툴팁
      @tipSprite = Sprite.new
      @tipSprite.bitmap = Bitmap.new(1, 1)
      @tipSprite.z = 9999999
      @toolTip = ""
      refresh
      MUI.addForm(self)
    end
    
    def refresh
      @titleSprite.bitmap.clear
      @baseSprite.bitmap.clear
      @titleSprite.bitmap.blt(0, 0, @@cache['TL'], Rect.new(0, 0, @@cache['TL'].width, @@cache['TL'].height))
      @titleSprite.bitmap.stretch_blt(Rect.new(@@cache['TL'].width, 0, @width - (@@cache['TR'].width + @@cache['TL'].width), @@cache['TM'].height), @@cache['TM'], Rect.new(0, 0, @@cache['TM'].width, @@cache['TM'].height))
      @titleSprite.bitmap.blt(@width - @@cache['TR'].width, 0, @@cache['TR'], Rect.new(0, 0, @@cache['TR'].width, @@cache['TR'].height))
      height = @baseSprite.bitmap.height
      @baseSprite.bitmap.blt(0, 0, @@cache['UL'], Rect.new(0, 0, @@cache['UL'].width, @@cache['UL'].height))
      @baseSprite.bitmap.blt(@width - @@cache['UR'].width, 0, @@cache['UR'], Rect.new(0, 0, @@cache['UR'].width, @@cache['UR'].height))
      @baseSprite.bitmap.stretch_blt(Rect.new(@@cache['UL'].width, 0, @width - (@@cache['UR'].width + @@cache['UL'].width), @@cache['UM'].height), @@cache['UM'], Rect.new(0, 0, @@cache['UM'].width, @@cache['UM'].height))
      @baseSprite.bitmap.stretch_blt(Rect.new(0, @@cache['UL'].height, @@cache['ML'].width, height - (@@cache['UL'].height + @@cache['DL'].height)), @@cache['ML'], Rect.new(0, 0, @@cache['ML'].width, @@cache['ML'].height))
      @baseSprite.bitmap.stretch_blt(Rect.new(@width - @@cache['MR'].width, @@cache['UR'].height, @@cache['MR'].width, height - (@@cache['UR'].height + @@cache['DR'].height)), @@cache['MR'], Rect.new(0, 0, @@cache['MR'].width, @@cache['MR'].height))
      @baseSprite.bitmap.stretch_blt(Rect.new(@@cache['ML'].width, @@cache['UL'].height, @width - (@@cache['ML'].width + @@cache['MR'].width), height - (@@cache['UM'].height + @@cache['DM'].height)), @@cache['MM'], Rect.new(0, 0, @@cache['MM'].width, @@cache['MM'].height))
      @baseSprite.bitmap.blt(0, height - @@cache['DL'].height, @@cache['DL'], Rect.new(0, 0, @@cache['DL'].width, @@cache['DL'].height))
      @baseSprite.bitmap.blt(@width - @@cache['DR'].width, height - @@cache['DR'].height, @@cache['DR'], Rect.new(0, 0, @@cache['DR'].width, @@cache['DR'].height))
      @baseSprite.bitmap.stretch_blt(Rect.new(@@cache['DL'].width, height - @@cache['DM'].height, @width - (@@cache['DR'].width + @@cache['DL'].width), @@cache['DM'].height), @@cache['DM'], Rect.new(0, 0, @@cache['DM'].width, @@cache['DM'].height))
    end
    
    def titleRefresh(align = 1)
      return if @captionText.nil?
      @captionSprite.x = case align
      when 0
        @captionSprite.bitmap.font.size
      when 1
        (@width - @captionSprite.bitmap.text_size(@captionText).width) / 2
      when 2
        @width - @captionSprite.bitmap.text_size(@captionText).width - @captionSprite.bitmap.font.size
      end
      @captionSprite.y = (@titleViewport.rect.height - @captionSprite.bitmap.font.size) / 2
    end
    
    def x; @x end
    def x=(value)
      return if @x == value
      delta = value - @x
      @x = value
      @titleViewport.rect.x += delta
      @baseViewport.rect.x += delta
      for con in @controls
        con.realX += delta
      end
    end
    
    # y
    def y; @y end
    def y=(value)
      return if @y == value
      delta = value - @y
      @y = value      
      @titleViewport.rect.y += delta
      @baseViewport.rect.y += delta
      for con in @controls
        con.realY += delta
      end
    end
    
    def z=(value)
      @titleViewport.z = value
      @baseViewport.z = value
    end
    
    # 너비
    def width; @width end
    def width=(value)
      return if @width == value
      @width = value
      @titleViewport.rect.width = @width
      @baseViewport.rect.width = @width
      @titleSprite.bitmap.dispose
      @captionSprite.bitmap.dispose
      @baseSprite.bitmap.dispose
      @titleSprite.bitmap   = Bitmap.new(@titleViewport.rect.width, @titleViewport.rect.height)
      @captionSprite.bitmap = Bitmap.new(@titleViewport.rect.width, @titleViewport.rect.height)
      @baseSprite.bitmap    = Bitmap.new(@baseViewport.rect.width, @height - @titleViewport.rect.height)
      @pic_close.x = @width - @@cache['X'].width * 1.5
      refresh
      titleRefresh
    end
      
    # 높이
    def height; @height end
    def height=(value)
      return if @height == value
      @height = value
      @baseViewport.rect.height = @height - @titleViewport.rect.height
      @titleSprite.bitmap.dispose
      @captionSprite.bitmap.dispose
      @baseSprite.bitmap.dispose
      @titleSprite.bitmap   = Bitmap.new(@titleViewport.rect.width, @titleViewport.rect.height)
      @captionSprite.bitmap = Bitmap.new(@titleViewport.rect.width, @titleViewport.rect.height)
      @baseSprite.bitmap    = Bitmap.new(@baseViewport.rect.width, @height - @titleViewport.rect.height)
      refresh
    end
    
    # 드래그
    def drag; @drag end
    def drag=(value)
      return if @drag == value
      return unless value.is_a?(TrueClass) or value.is_a?(FalseClass)
      @drag = value
    end
    
    # 닫기
    def close; @close end
    def close=(value)
      return if @close == value
      return unless value.is_a?(TrueClass) or value.is_a?(FalseClass)
      @pic_close.visible = @close = value
    end
    
    # 폼 스타일
    def style; @style end
    def style=(value)
      return if @style == value
      loadCache(@style = value)
      @titleViewport.rect = Rect.new(@x, @y, @width, @@cache['TM'].height)
      @baseViewport.rect  = Rect.new(@x, @y + @titleViewport.rect.height, @width, @height - @titleViewport.rect.height)
      refresh
    end
    
    # 투명도
    def opacity; @opacity end
    def opacity=(value)
      return if @opacity == value
      if value.between?(0, 255)
        @opacity = value
        @titleSprite.opacity = @opacity
        @captionSprite.opacity = @opacity
        @baseSprite.opacity = @opacity
      end
    end

    # 타이틀
    def getTitle; @captionText end
    def setTitle(text, align = 1, color = (@style == "Black" ? Color.white : (@style == "White" ? Color.gray : Color.black)), font = Config::FONT[0], size = Config::FONT_NORMAL_SIZE + 1)
      #return if @captionText == text
      @captionText = text
      @captionSprite.bitmap.clear
      @captionSprite.bitmap.font.name = font
      @captionSprite.bitmap.font.size = size      
      @captionSprite.bitmap.font.color = color
      @captionSprite.bitmap.font.bold = true
      @captionSprite.bitmap.draw_text(0, 0, @captionSprite.bitmap.text_size(text).width + 1, size, text, 0)
      titleRefresh(align)
    end

    def loadCache(style)
      @@cache['TL'] = RPG::Cache.form(style + "/" + "TL")
      @@cache['TM'] = RPG::Cache.form(style + "/" + "TM")
      @@cache['TR'] = RPG::Cache.form(style + "/" + "TR")
      @@cache['UL'] = RPG::Cache.form(style + "/" + "UL")
      @@cache['UM'] = RPG::Cache.form(style + "/" + "UM")
      @@cache['UR'] = RPG::Cache.form(style + "/" + "UR")
      @@cache['ML'] = RPG::Cache.form(style + "/" + "ML")
      @@cache['MM'] = RPG::Cache.form(style + "/" + "MM")
      @@cache['MR'] = RPG::Cache.form(style + "/" + "MR")
      @@cache['DL'] = RPG::Cache.form(style + "/" + "DL")
      @@cache['DM'] = RPG::Cache.form(style + "/" + "DM")
      @@cache['DR'] = RPG::Cache.form(style + "/" + "DR")
      @@cache['X']  = RPG::Cache.form(style + "/" + "X")
      @@cache['X2'] = RPG::Cache.form(style + "/" + "X2")
    end
    
    # 마우스가 범위에 들어올 때
    def isMouseOver
      x, y = Mouse.x, Mouse.y
      return false if (not x or not y)
      if @x <= x && @x + @width > x && @y <= y && @y + @height > y
        return true
      else
        return false
      end
    end

    # 마우스가 올려질 때
    def isSelected
      if isMouseOver && MUI.getFocus == self
        return true
      end
      return false
    end

    #  폼_뷰포트 취득
    def getViewport
      return @baseViewport
    end
    
    # 폼타이틀_뷰포트 취득
    def getTitleViewport
      return @titleViewport
    end

    # 컨트롤 취득
    def getControls
      return @controls
    end
    
    # 폼_컨트롤 추가
    def addControl(control)
      control.setParent(self)
      @controls.push(control)
    end
    
    # 폼타이틀_컨트롤 추가
    def addTitleControl(control)
      control.setTitleParent(self)
      @controls.push(control)
    end
    
    # 텍스트 라인 수 리턴
    def line(width, str)
      return if @baseSprite.nil?
      return @baseSprite.bitmap.line(width, str)
    end

    # 컨트롤 툴팁
    def drawToolTip(value)
      @tipSprite.x, @tipSprite.y = Mouse.x, Mouse.y
      return if value == @toolTip
      @toolTip = value
      # 텍스트 사이즈 취득
      @tipSprite.bitmap = Bitmap.new(1, 1)
      width = Array.new
      str = @toolTip.split "\n"
      str.each_index { |n| width.push(@tipSprite.bitmap.text_size(str[n]).width) }
      height = str.size * Config::FONT_NORMAL_SIZE
      # 재생성
      @tipSprite.bitmap = Bitmap.new(width.max + 2, height + 2)
      @tipSprite.bitmap.clear
      @tipSprite.bitmap.fill_rect(0, 0, @tipSprite.bitmap.width, @tipSprite.bitmap.height, Color.black(128))
      @tipSprite.bitmap.draw_multi_text(0, 0, @tipSprite.bitmap.width, @tipSprite.bitmap.height, @toolTip)
    end
    
    def disposeToolTip
      @toolTipDraw = false
      @toolTip = ""
      @tipSprite.bitmap.dispose
    end
    
    # 업데이트
    def update
      return if MUI.getFocus != self
      @toolTipDraw = false
      # 컨트롤 업데이트
      for con in @controls
        con.update
        if con.isSelected and con.toolTip != ""
          @toolTipDraw = true
          drawToolTip(con.toolTip)
        end
      end
      if not @toolTipDraw and not @tipSprite.bitmap.disposed?
        @toolTip = ""
        @tipSprite.bitmap.dispose
      end
      # 드래그
      if Mouse.press? and @drag and isMouseOver
        cx = Mouse.x - Mouse.ox
        cy = Mouse.y - Mouse.oy
        self.x -= cx
        self.y -= cy
        Mouse.x -= cx
        Mouse.y -= cy
      end
      # 닫기 버튼
      @pic_close.picture = @pic_close.isSelected ? @@cache['X2'] : @@cache['X']
      if @close && Key.trigger?(KEY_ESCAPE)
        dispose
      end
      if @pic_close.click
        dispose
      end
    end

    # 삭제
    def dispose
      MUI.deleteForm(self)
      # 컨트롤 삭제
      for con in @controls
        con.dispose
      end
      # 메모리 해제
      self.instance_variables.each do |v|
        if instance_variable_get(v).is_a?(Sprite)
          instance_variable_get(v).dispose
          instance_variable_set(v, nil)
        end
      end
      GC.start
    end
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ MUI::Control
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2014
# --------------------------------------------------------------------------
# Description
# 
#    컨트롤을 담당하는 클래스입니다.
#────────────────────────────────────────────────────────────────────────────
class MUI
  class Control
    def initialize(x, y, w, h)
      @realX = x
      @realY = y
      @x = x
      @y = y
      @width = w
      @height = h
      @enable = true
      @visible = true
      @opacity = 255
      @toolTip = ""
    end
    
    def setParent(form)
      @parent = form
      @baseSprite = Sprite.new(form.getViewport)
      @baseSprite.bitmap = Bitmap.new(@width, @height)
      @baseSprite.x = @x
      @baseSprite.y = @y
      @realX = @x + form.getViewport.rect.x
      @realY = @y + form.getViewport.rect.y
      refresh
    end

    def setTitleParent(form)
      @parent = form
      @baseSprite = Sprite.new(form.getTitleViewport)
      @baseSprite.bitmap = Bitmap.new(@width, @height)
      @baseSprite.x = @x
      @baseSprite.y = @y
      @realX = @x + form.getTitleViewport.rect.x
      @realY = @y + form.getTitleViewport.rect.y
      refresh
    end

    # 실제 x
    def realX; @realX end
    def realX=(value)
      @realX = value
    end
    
    # 실제 y
    def realY; @realY end
    def realY=(value)
      @realY = value
    end

    # x
    def x; @x end
    def x=(value)
      @x = value
      @baseSprite.x = @x
      @realX = @parent.getViewport.rect.x + @x
    end
    
    # y
    def y; @y end
    def y=(value)
      @y = value
      @baseSprite.y = @y
      @realY = @parent.getViewport.rect.y + @y
    end

    # 너비
    def width; @width end
    def width=(value)
      return if @width == value or value <= 0
      @width = value
      return if @baseSprite.nil?
      @baseSprite.bitmap.dispose
      @baseSprite.bitmap = Bitmap.new(@width, @height)
      refresh
    end

    # 높이
    def height; @height end
    def height=(value)
      return if @height == value or value <= 0
      @height = value
      return if @baseSprite.nil?
      @baseSprite.bitmap.dispose
      @baseSprite.bitmap = Bitmap.new(@width, @height)
      refresh
    end
    
    # 활성화
    def enable; @enable end
    def enable=(value)
      return if @enable == value
      return unless value.is_a?(TrueClass) or value.is_a?(FalseClass)
      @enable = value
      return if @baseSprite.nil?
      if @enable
        @baseSprite.tone.set(0, 0, 0) if @baseSprite.tone != Tone.new(0, 0, 0)
      else
        @baseSprite.tone.set(-20, -20, -20, 100) if @baseSprite.tone != Tone.new(-20, -20, -20, 100)
      end
    end

    # 표시
    def visible; @visible end
    def visible=(value)
      return if @visible == value
      return unless value.is_a?(TrueClass) or value.is_a?(FalseClass)
      @visible = value
      return if @baseSprite.nil?
      @baseSprite.visible = value
    end
    
    # 투명도
    def opacity; @opacity end
    def opacity=(value)
      return if @opacity == value
      return unless value.between?(0, 255)
      @opacity = value
      return if @baseSprite.nil?
      @baseSprite.opacity = value
      refresh
    end
    
    # 텍스트 라인 수 리턴
    def line(width, str)
      return if @baseSprite.nil?
      return @baseSprite.bitmap.line(width, str)
    end
    
    def toolTip; @toolTip end
    def toolTip=(value)
      return if @toolTip == value
      return if @baseSprite.nil?
      @toolTip = value
    end
    
    def baseSprite; @baseSprite end 
    
    # 컨트롤을 한 번 누를 때
    def click(id = 0)
      id = 0 if not id.between?(0,2)
      if isSelected && Mouse.trigger?(id) && @visible
        Game.system.se_play(Config::DECISION_SE)
        return true
      else
        return false
      end
    end
    
    # 컨트롤을 꾹 누를 때
    def press(id = 0)
      id = 0 if not id.between?(0,2)
      if isSelected && Mouse.press?(id) && @visible
        return true
      else
        return false
      end
    end
    
    # 컨트롤을 꾹 누를 때
    def repeat(id)
      return if not @enable or not @visible
    end
    
    # 마우스가 컨트롤의 범위에 들어올 때
    def isMouseOver
      x, y = Mouse.x, Mouse.y
      return false if (not x or not y)
      if @realX <= x && @realX + @width > x && @realY <= y && @realY + @height > y
        return true
      else
        return false
      end
    end
    
    # 컨트롤에 마우스가 올려질 때
    def isSelected
      if isMouseOver && MUI.getFocus == @parent
        viewport1 = @parent.getViewport.rect
        viewport2 = @parent.getTitleViewport.rect
        # 베이스
        ((x >= viewport1.x and x <= viewport1.x + viewport1.width and
          y >= viewport1.y and y <= viewport1.y + viewport1.height) or
        # 타이틀
         (x >= viewport2.x and x <= viewport2.x + viewport2.width and
          y >= viewport2.y and y <= viewport2.y + viewport2.height))
        return true
      end
      return false
    end
    
    # 업데이트
    def update
      return if not @enable or not @visible
      return if @baseSprite.nil?
    end
    
    # 삭제
    def dispose
      if not @baseSprite.nil? and @baseSprite.is_a?(Sprite)
        self.instance_variables.each do |v|
          if instance_variable_get(v).is_a?(Sprite)
            instance_variable_get(v).dispose
            instance_variable_set(v, nil)
          end
        end
      end
    end

    # Recter
    def realTimeEdit(form)
      if $DEBUG
        if Key.press?(KEY_CTRL)
          form.drag = false
          if Mouse.trigger?
            self.x = Mouse.x - form.x
            self.y = Mouse.y - form.y - form.getTitleViewport.rect.height
            puts "#{self.x}, #{self.y}, #{self.width}, #{self.height}"
          end
          if Key.trigger?(KEY_C)
            File.setClipboard(", ", self.x, self.y, self.width, self.height)
          end
        elsif Key.press?(KEY_SHIFT)
          form.drag = false
          if Mouse.trigger?
            x = Mouse.x - form.x - @x
            y = Mouse.y - form.y - form.getTitleViewport.rect.height - @y
            self.width  = (x <= 0 ? 1 : x)
            self.height = (y <= 0 ? 1 : y)
          end
        else
          form.drag = true
        end
      end
    end
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ MUI::Label
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2014
# --------------------------------------------------------------------------
# Description
# 
#    레이블 컨트롤을 담당하는 클래스입니다.
#────────────────────────────────────────────────────────────────────────────
class MUI
  class Label < Control
    def initialize(x, y, w, h)
      super(x, y, w, h)
      @align = 0
      @bold = false
      @italic = false
      @color = [Color.black, nil]
      @name = Config::FONT[0]
      @size = Config::FONT_NORMAL_SIZE
      @underLine = false
      @middleLine = false
      @text = ""
    end
      
    # 정렬 // 왼쪽 0, 가운데 1, 오른쪽 2
    def align; @align end
    def align=(value)
      return if @align == value
      @align = value
      return if @baseSprite.nil?
      refresh
    end
    
    # 굵게
    def bold; @bold end
    def bold=(value)
      return if @bold == value
      @bold = value
      return if @baseSprite.nil?
      @baseSprite.bitmap.font.bold = @bold
      refresh
    end
    
    # 기울기
    def italic; @italic end
    def italic=(value)
      return if @italic == value
      @italic = value
      return if @baseSprite.nil?
      @baseSprite.bitmap.font.italic = @italic
      refresh
    end
    
    # 안쪽 색깔
    def color; @color[0] end
    def color=(value)
      return if @color[0] == value
      @color[0] = value
      return if @baseSprite.nil?
      @baseSprite.bitmap.font.color = @color[0]
      refresh
    end
    
    # 바깥쪽 색깔
    def color2; @color[1] end
    def color2=(value)
      return if @color[1] == value
      @color[1] = value
      return if @baseSprite.nil?
      return unless @color[1].is_a?(Color)
      refresh
    end
    
    # 폰트명
    def name; @name end
    def name=(value)
      return if @name == value
      @name = value
      return if @baseSprite.nil?
      @baseSprite.bitmap.font.name = @name
      refresh
    end
    
    # 크기
    def size; @size end
    def size=(value)
      return if @size == value
      @size = value
      return if @baseSprite.nil?
      @baseSprite.bitmap.font.size = @size
      refresh
    end
    
    # 취소선
    def middleLine; @middleLine end
    def middleLine=(value)
      return if @middleLine == value
      @middleLine = value
      return if @baseSprite.nil?
      refresh
    end
    
    # 밑줄
    def underLine; @underLine end
    def underLine=(value)
      return if @underLine == value
      @underLine = value
      return if @baseSprite.nil?
      refresh
    end
    
    # 텍스트
    def text; @text end
    def text=(value)
      return if @text == value
      @text = value
      return if @baseSprite.nil?
      refresh
    end
    
    # 자동 크기
    def autoSize
      return if @text.nil? or @text == ""
      return if @baseSprite.nil?
      @esn = true
      str = @text.split "\n"
      for i in 0...str.size
        width ||= Array.new
        width.push(@baseSprite.bitmap.text_size(str[i]).width)
        width = width.max if i == str.size - 1
      end
      height = @baseSprite.bitmap.get_divided_text(width, @text, @esn).size * @baseSprite.bitmap.font.size
      self.width = width
      self.height = height
    end
    
    # 리프레시
    def refresh
      @baseSprite.bitmap.clear
      @baseSprite.bitmap.font.name = @name
      @baseSprite.bitmap.font.size = @size
      @baseSprite.bitmap.font.bold = @bold
      @baseSprite.bitmap.font.italic = @italic
      @baseSprite.bitmap.font.color = @color[0]
      @baseSprite.visible = @visible
      @baseSprite.opacity = @opacity
      if @color[1].is_a?(Color)
        @baseSprite.bitmap.draw_multi_outline_text(0, 0, @width, @height, @text, @color[0], @color[1], @align)
      else
        @baseSprite.bitmap.draw_multi_text(0, 0, @width, @height, @text, @align, @esn)
      end
      @baseSprite.bitmap.fill_line(@text, @color[1].is_a?(Color) ? @color[1] : @color[0], @align, 1, @esn) if @middleLine
      @baseSprite.bitmap.fill_line(@text, @color[1].is_a?(Color) ? @color[1] : @color[0], @align, 2, @esn) if @underLine
    end
    
    # 클릭
    def click(id = 0)
      super
      id = 0 if not id.between?(0,2)
      if isSelected && Mouse.trigger?(id) && @visible
        Game.system.se_play(Config::DECISION_SE)
        return true
      else
        return false
      end
    end
    
    # 꾹 클릭
    def repeat(id = 0)
      super
      id = 0 if not id.between?(0,2)
      if isSelected && Mouse.repeat?(id) && @visible
        Game.system.se_play(Config::DECISION_SE)
        return true
      else
        return false
      end
    end
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ MUI::Button
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2014
# --------------------------------------------------------------------------
# Description
# 
#    버튼 컨트롤을 담당하는 클래스입니다.
#────────────────────────────────────────────────────────────────────────────
class MUI
  class Button < Control
    def initialize(x, y, w, h)
      super(x, y, w, h)      
      @align = 1
      @bold = false
      @color = Color.white
      @name = Config::FONT[0]
      @size = Config::FONT_NORMAL_SIZE
      @italic = false
      @text = ""
      @picture = nil
      @enable = true
      @visible = true
      loadCache(@style = "Blue")
    end
        
    def align; @align; end
    def align=(value)
      return if @align == value
      @align = value
      return if @baseSprite.nil?
      refresh
    end
    
    def bold; @bold; end
    def bold=(value)
      return if @bold == value
      @bold = value
      return if @baseSprite.nil?
      @baseSprite.bitmap.font.bold = @bold
      refresh
    end
    
    def color; @color; end
    def color=(value)
      return if @color == value
      @color = value
      return if @baseSprite.nil?
      @baseSprite.bitmap.font.color = @color
      refresh
    end
      
    def name; @name; end
    def name=(value)
      return if @name == value
      @name = value
      return if @baseSprite.nil?
      @baseSprite.bitmap.font.name = @name
      refresh
    end
    
    def size; @size; end
    def size=(value)
      return if @size == value
      @size = value
      return if @baseSprite.nil?
      @baseSprite.bitmap.font.size = @size
      refresh
    end
    
    def italic; @italic; end
    def italic=(value)
      return if @italic == value
      @italic = value
      return if @baseSprite.nil?
      @baseSprite.bitmap.font.italic = @italic
      refresh
    end

    def text; @text; end
    def text=(text)
      return if @text == text
      @text = text
      return if @baseSprite.nil?
      refresh
    end
    
    def picture; @picture; end
    def picture=(path)
      if path.is_a?(String)
        @picture = Bitmap.new(path)
      elsif path.is_a?(Bitmap)
        @picture = path
      end
      return if @baseSprite.nil?
      refresh
    end
    
    def style; @style; end
    def style=(value)
      loadCache(@style = value)
      return if @baseSprite.nil?
      refresh
    end
    
    def refresh
      @baseSprite.bitmap.clear
      # Proverty
      @baseSprite.bitmap.font.name = @name
      @baseSprite.bitmap.font.size = @size
      @baseSprite.bitmap.font.bold = @bold
      @baseSprite.bitmap.font.italic = @italic
      @baseSprite.bitmap.font.color = @color
      @baseSprite.visible = @visible
      @baseSprite.opacity = @opacity
      # Button
      height = @baseSprite.bitmap.height
      @baseSprite.bitmap.blt(0, 0, @@cache['UL'], Rect.new(0, 0, @@cache['UL'].width, @@cache['UL'].height))
      @baseSprite.bitmap.blt(@width - @@cache['UR'].width, 0, @@cache['UR'], Rect.new(0, 0, @@cache['UR'].width, @@cache['UR'].height))
      @baseSprite.bitmap.stretch_blt(Rect.new(@@cache['UL'].width, 0, @width - (@@cache['UR'].width + @@cache['UL'].width), @@cache['UM'].height), @@cache['UM'], Rect.new(0, 0, @@cache['UM'].width, @@cache['UM'].height))
      @baseSprite.bitmap.stretch_blt(Rect.new(0, @@cache['UL'].height, @@cache['ML'].width, height - (@@cache['UL'].height + @@cache['DL'].height)), @@cache['ML'], Rect.new(0, 0, @@cache['ML'].width, @@cache['ML'].height))
      @baseSprite.bitmap.stretch_blt(Rect.new(@width - @@cache['MR'].width, @@cache['UR'].height, @@cache['MR'].width, height - (@@cache['UR'].height + @@cache['DR'].height)), @@cache['MR'], Rect.new(0, 0, @@cache['MR'].width, @@cache['MR'].height))
      @baseSprite.bitmap.stretch_blt(Rect.new(@@cache['ML'].width, @@cache['UL'].height, @width - (@@cache['ML'].width + @@cache['MR'].width), height - (@@cache['UM'].height + @@cache['DM'].height)), @@cache['MM'], Rect.new(0, 0, @@cache['MM'].width, @@cache['MM'].height))
      @baseSprite.bitmap.blt(0, height - @@cache['DL'].height, @@cache['DL'], Rect.new(0, 0, @@cache['DL'].width, @@cache['DL'].height))
      @baseSprite.bitmap.blt(@width - @@cache['DR'].width, height - @@cache['DR'].height, @@cache['DR'], Rect.new(0, 0, @@cache['DR'].width, @@cache['DR'].height))
      @baseSprite.bitmap.stretch_blt(Rect.new(@@cache['DL'].width, height - @@cache['DM'].height, @width - (@@cache['DR'].width + @@cache['DL'].width), @@cache['DM'].height), @@cache['DM'], Rect.new(0, 0, @@cache['DM'].width, @@cache['DM'].height))
      # Picture
      if @text.nil? or (@text.is_a?(String) and @text.empty?)
        length = 0; @text = ""
      else
        length = @baseSprite.bitmap.get_divided_text(@width, @text).size
      end
      @baseSprite.bitmap.blt((@width - @picture.width) / 2,
        (@height - @picture.height - length * @baseSprite.bitmap.font.size) / 2,
        @picture, Rect.new(0, 0, @picture.width, @picture.height)) if @picture.is_a?(Bitmap)
      # text
      @baseSprite.bitmap.draw_multi_text(0, 
        ((@height - length * @baseSprite.bitmap.font.size) / 2) + (@picture.is_a?(Bitmap) ? @picture.height / 2 : 0),
        @width, @height, @text, @align)
      # enable
      @enable ? @baseSprite.tone.set(0, 0, 0) : @baseSprite.tone.set(-20, -20, -20, 100)
    end
      
    def loadCache(style)
      @@cache = {}
      @@cache['UL'] = RPG::Cache.button(style + "/" + "UL")
      @@cache['UM'] = RPG::Cache.button(style + "/" + "UM")
      @@cache['UR'] = RPG::Cache.button(style + "/" + "UR")
      @@cache['ML'] = RPG::Cache.button(style + "/" + "ML")
      @@cache['MM'] = RPG::Cache.button(style + "/" + "MM")
      @@cache['MR'] = RPG::Cache.button(style + "/" + "MR")
      @@cache['DL'] = RPG::Cache.button(style + "/" + "DL")
      @@cache['DM'] = RPG::Cache.button(style + "/" + "DM")
      @@cache['DR'] = RPG::Cache.button(style + "/" + "DR")
    end

    def update
      super
      if isSelected and @visible and @enable
        @baseSprite.opacity = 150 if @baseSprite.opacity != 150
      else
        @baseSprite.opacity = 255 if @baseSprite.opacity != 255
      end
    end
    
    def click(id = 0)
      super
      id = 0 if not id.between?(0, 2)
      if Mouse.trigger?(id) and isSelected and @visible
        if @enable
          Game.system.se_play(Config::DECISION_SE)
          return true
        else
          Game.system.se_play(Config::BUZZER_SE)
          return false
        end
      else
        return false
      end
    end
    
    def press(id = 0)
      id = 0 if not id.between?(0, 2)
      if isSelected
        @baseSprite.opacity = 150
        return true if Mouse.press?(id) and @visible
      else
        @baseSprite.opacity = 255
        return false
      end
    end
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ MUI::TextBox
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2014
# --------------------------------------------------------------------------
# Description
# 
#    IME을 사용하는, 텍스트박스 컨트롤을 담당하는 클래스입니다.
#────────────────────────────────────────────────────────────────────────────
class MUI
  class TextBox < Control    
    def initialize(x, y, w, h)
      super(x, y, w, h)
      @align = 0
      @bold = false
      @color = Color.black
      @name = Config::FONT[0]
      @size = Config::FONT_NORMAL_SIZE
      @focus = false
      @italic = false
      @passwordChar = false
      @text = ""
      @helpText = ""
      @style = "White"
      @ime = IME.new
      loadCache(@style)
    end
      
    def loadCache(style)
      @@cache = {}
      @@cache['UL'] = RPG::Cache.textBox(style + "/" + "UL")
      @@cache['UM'] = RPG::Cache.textBox(style + "/" + "UM")
      @@cache['UR'] = RPG::Cache.textBox(style + "/" + "UR")
      @@cache['ML'] = RPG::Cache.textBox(style + "/" + "ML")
      @@cache['MM'] = RPG::Cache.textBox(style + "/" + "MM")
      @@cache['MR'] = RPG::Cache.textBox(style + "/" + "MR")
      @@cache['DL'] = RPG::Cache.textBox(style + "/" + "DL")
      @@cache['DM'] = RPG::Cache.textBox(style + "/" + "DM")
      @@cache['DR'] = RPG::Cache.textBox(style + "/" + "DR")
      
      @@cache['UL2'] = RPG::Cache.textBox(style + "/" + "UL2")
      @@cache['UM2'] = RPG::Cache.textBox(style + "/" + "UM2")
      @@cache['UR2'] = RPG::Cache.textBox(style + "/" + "UR2")
      @@cache['ML2'] = RPG::Cache.textBox(style + "/" + "ML2")
      @@cache['MM2'] = RPG::Cache.textBox(style + "/" + "MM2")
      @@cache['MR2'] = RPG::Cache.textBox(style + "/" + "MR2")
      @@cache['DL2'] = RPG::Cache.textBox(style + "/" + "DL2")
      @@cache['DM2'] = RPG::Cache.textBox(style + "/" + "DM2")
      @@cache['DR2'] = RPG::Cache.textBox(style + "/" + "DR2")
      @baseBitmap = []
    end
    
    def setParent(form)
      @parent = form
      @baseSprite = Sprite.new(form.getViewport)
      @textSprite = Sprite.new(form.getViewport)
      @textSprite.z = @baseSprite.z + 1
      @textBitmap = Bitmap.new(@width, @height)
      @baseSprite.x = @x
      @baseSprite.y = @y
      @textSprite.x = @x
      @textSprite.y = @y
      @realX = @x + form.getViewport.rect.x
      @realY = @y + form.getViewport.rect.y
      refresh
    end

    def setTitleParent(form)
      @parent = form
      @baseSprite = Sprite.new(form.getTitleViewport)
      @textSprite = Sprite.new(form.getTitleViewport)
      @textBitmap = Bitmap.new(@width, @height)
      @baseSprite.x = @x
      @baseSprite.y = @y
      @textSprite.x = @x
      @textSprite.y = @y
      @realX = @x + form.getViewport.rect.x
      @realY = @y + form.getViewport.rect.y
      refresh
    end
    
    def align; @align; end
    def align=(value)
      return if @align == value
      @align = value
      return if @baseSprite.nil?
      refresh
    end
    
    def bold; @bold; end
    def bold=(value)
      return if @bold == value
      @bold = value
      return if @baseSprite.nil?
      refresh
    end
    
    def color; @color; end
    def color=(value)
      return if @color == value
      @color = value
      return if @baseSprite.nil?
      refresh
    end
    
    def name; @name; end
    def name=(value)
      return if @name == value
      @name = value
      return if @baseSprite.nil?
      refresh
    end
    
    def size; @size; end
    def size=(value)
      return if @size == value
      @size = value
      return if @baseSprite.nil?
      refresh
    end
    
    def italic; @italic; end
    def italic=(value)
      return if @italic == value
      @italic = value
      return if @baseSprite.nil?
      refresh
    end

    def enable; @enable; end
    def enable=(value)
      return if @enable == value
      return unless value.is_a?(TrueClass) or value.is_a?(FalseClass)
      @enable = value
      return if @baseSprite.nil?
      if @enable
        @textBitmap.font.color = Color.gray
        @baseSprite.tone.set(0, 0, 0) if @baseSprite.tone != Tone.new(0, 0, 0)
      else
        @textBitmap.font.color = Color.gray(128)
        @baseSprite.tone.set(-20, -20, -20, 100) if @baseSprite.tone != Tone.new(-20, -20, -20, 100)
      end
      refresh
    end

    def visible; @visible; end
    def visible=(value)
      return if @visible == value
      return unless value.is_a?(TrueClass) or value.is_a?(FalseClass)
      @visible = value
      return if @baseSprite.nil?
      refresh
    end
    
    def style; @style end
    def style=(value)
      return if @style == value
      @style = value
      loadCache(@style)
      return if @baseSprite.nil?
      refresh
    end
    
    def passwordChar; @passwordChar; end
    def passwordChar=(value)
      return if @passwordChar == value
      @passwordChar = value
      return if @baseSprite.nil?
      refresh
    end
    
    def helpText; @helpText; end
    def helpText=(value)
      return if @helpText == value
      @helpText = value
      return if @textBitmap.nil?
      textRefresh
    end
    
    def text; @text end
    def text=(value)
      return if @text == value
      @text = value
      @ime.text = @text.split(//)
      @ime.setText
      return if @textBitmap.nil?
      textRefresh
    end
    
    def focus; @focus end
    def focus=(value)
      return if @focus == value
      return unless value.is_a?(TrueClass) or value.is_a?(FalseClass)
      @focus = value
      return if @textBitmap.nil?
      refresh
    end
    
    def update
      super
      if Mouse.trigger?
        if isSelected
          if not self.focus
            self.focus = true
            @ime.choice = false
            @ime.focus = true
            @baseSprite.bitmap = @baseBitmap[1]
            @ime.setIMEMode = @passwordChar ? 0 : 1
          end
        elsif self.focus
          self.focus = false
          @ime.choice = true
          @ime.focus = false
          @baseSprite.bitmap = @baseBitmap[0]
        end
      end
      if self.focus
        @ime.update
        textRefresh if @text != @ime.getText
      end
    end
        
    def refresh
      @gap = ((@height - @textBitmap.font.size) / 2.0).round
      @textSprite.y = @baseSprite.y - @gap
      @baseSprite.visible = @visible
      @baseSprite.opacity = @opacity
      baseRefresh
      @baseSprite.bitmap = @baseBitmap[self.focus ? 1 : 0].dup
      @textBitmap.font.name = @name
      @textBitmap.font.size = @size
      @textBitmap.font.bold = @bold
      @textBitmap.font.italic = @italic
      @textBitmap.font.color = @color
      @textSprite.visible = @visible
      @textSprite.opacity = @opacity
      @textSprite.bitmap = @textBitmap
      textRefresh
    end
    
    def baseRefresh
      # non-focus
      @baseBitmap[0] = Bitmap.new(@width, @height)
      @baseBitmap[0].clear
      @baseBitmap[0].blt(0, 0, @@cache['UL'], Rect.new(0, 0, @@cache['UL'].width, @@cache['UL'].height))
      @baseBitmap[0].blt(@width - @@cache['UR'].width, 0, @@cache['UR'], Rect.new(0, 0, @@cache['UR'].width, @@cache['UR'].height))
      @baseBitmap[0].stretch_blt(Rect.new(@@cache['UL'].width, 0, @width - (@@cache['UR'].width + @@cache['UL'].width), @@cache['UM'].height), @@cache['UM'], Rect.new(0, 0, @@cache['UM'].width, @@cache['UM'].height))
      @baseBitmap[0].stretch_blt(Rect.new(0, @@cache['UL'].height, @@cache['ML'].width, @height - (@@cache['UL'].height + @@cache['DL'].height)), @@cache['ML'], Rect.new(0, 0, @@cache['ML'].width, @@cache['ML'].height))
      @baseBitmap[0].stretch_blt(Rect.new(@width - @@cache['MR'].width, @@cache['UR'].height, @@cache['MR'].width, @height - (@@cache['UR'].height + @@cache['DR'].height)), @@cache['MR'], Rect.new(0, 0, @@cache['MR'].width, @@cache['MR'].height))
      @baseBitmap[0].stretch_blt(Rect.new(@@cache['ML'].width, @@cache['UL'].height, @width - (@@cache['ML'].width + @@cache['MR'].width), @height - (@@cache['UM'].height + @@cache['DM'].height)), @@cache['MM'], Rect.new(0, 0, @@cache['MM'].width, @@cache['MM'].height))
      @baseBitmap[0].blt(0, @height - @@cache['DL'].height, @@cache['DL'], Rect.new(0, 0, @@cache['DL'].width, @@cache['DL'].height))
      @baseBitmap[0].blt(@width - @@cache['DR'].width, @height - @@cache['DR'].height, @@cache['DR'], Rect.new(0, 0, @@cache['DR'].width, @@cache['DR'].height))
      @baseBitmap[0].stretch_blt(Rect.new(@@cache['DL'].width, @height - @@cache['DM'].height, @width - (@@cache['DR'].width + @@cache['DL'].width), @@cache['DM'].height), @@cache['DM'], Rect.new(0, 0, @@cache['DM'].width, @@cache['DM'].height))
      # focus
      @baseBitmap[1] = Bitmap.new(@width, @height)
      @baseBitmap[1].clear
      @baseBitmap[1].blt(0, 0, @@cache['UL2'], Rect.new(0, 0, @@cache['UL2'].width, @@cache['UL2'].height))
      @baseBitmap[1].blt(@width - @@cache['UR2'].width, 0, @@cache['UR2'], Rect.new(0, 0, @@cache['UR2'].width, @@cache['UR2'].height))
      @baseBitmap[1].stretch_blt(Rect.new(@@cache['UL2'].width, 0, @width - (@@cache['UR2'].width + @@cache['UL2'].width), @@cache['UM2'].height), @@cache['UM2'], Rect.new(0, 0, @@cache['UM2'].width, @@cache['UM2'].height))
      @baseBitmap[1].stretch_blt(Rect.new(0, @@cache['UL2'].height, @@cache['ML2'].width, @height - (@@cache['UL2'].height + @@cache['DL2'].height)), @@cache['ML2'], Rect.new(0, 0, @@cache['ML2'].width, @@cache['ML2'].height))
      @baseBitmap[1].stretch_blt(Rect.new(@width - @@cache['MR2'].width, @@cache['UR2'].height, @@cache['MR2'].width, @height - (@@cache['UR2'].height + @@cache['DR2'].height)), @@cache['MR2'], Rect.new(0, 0, @@cache['MR2'].width, @@cache['MR2'].height))
      @baseBitmap[1].stretch_blt(Rect.new(@@cache['ML2'].width, @@cache['UL2'].height, @width - (@@cache['ML2'].width + @@cache['MR2'].width), @height - (@@cache['UM2'].height + @@cache['DM2'].height)), @@cache['MM2'], Rect.new(0, 0, @@cache['MM2'].width, @@cache['MM2'].height))
      @baseBitmap[1].blt(0, @height - @@cache['DL2'].height, @@cache['DL2'], Rect.new(0, 0, @@cache['DL2'].width, @@cache['DL2'].height))
      @baseBitmap[1].blt(@width - @@cache['DR2'].width, @height - @@cache['DR2'].height, @@cache['DR2'], Rect.new(0, 0, @@cache['DR2'].width, @@cache['DR2'].height))
      @baseBitmap[1].stretch_blt(Rect.new(@@cache['DL2'].width, @height - @@cache['DM2'].height, @width - (@@cache['DR2'].width + @@cache['DL2'].width), @@cache['DM2'].height), @@cache['DM2'], Rect.new(0, 0, @@cache['DM2'].width, @@cache['DM2'].height))
    end
    
    def textRefresh
      @text = @ime.getText
      @textBitmap.clear
      if @text == ""
        if @helpText != "" and @helpText != nil
          @textBitmap.font.color = Color.gray(128)
          @textBitmap.draw_text(@gap, @gap * 2, 
          @textBitmap.text_size(@helpText).width,
          @textBitmap.text_size(@helpText).height, @helpText.to_s)
          @textBitmap.font.color = @color
        end
      else
        @textBitmap.draw_text(@gap, @gap, @width, @height, (@passwordChar ? @passwordChar * @text.size : @text))
        @textSprite.bitmap = @textBitmap
      end
    end

    def dispose
      super
      @text = ""
      @ime.dispose
    end
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ MUI::PictureBox
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2014
# --------------------------------------------------------------------------
# Description
# 
#    픽쳐박스 컨트롤을 담당하는 클래스입니다.
#────────────────────────────────────────────────────────────────────────────
class MUI
  class PictureBox < Control
    def picture; @picture; end
      
    def initialize(x, y, w, h)
      super(x, y, w, h)
    end
    
    def picture=(path)
      return if @picture == path
      clear
      begin
        if path.is_a?(String)
          @picture = Bitmap.new(path)
        elsif path.is_a?(Bitmap)
          @picture = path
        end
      rescue
        @picture = Bitmap.new(1, 1)
      end
      return if @baseSprite.nil?
      refresh
    end
    
    def clear
      return if @baseSprite.nil?
      @picture = nil
      @baseSprite.bitmap.clear
    end
    
    # 자동 크기
    def autoSize
      return unless @picture.is_a?(Bitmap)
      self.width = @picture.width
      self.height = @picture.height
    end
    
    def refresh
      return if @baseSprite.nil?
      @baseSprite.bitmap.clear
      @baseSprite.visible = @visible
      @baseSprite.opacity = @opacity
      return if @picture.nil?
      @baseSprite.bitmap.blt(0, 0, @picture, Rect.new(0, 0, @width, @height))
    end
    
    def update
      super
    end
    
    def click(id = 0)
      super
      id = 0 if not id.between?(0,2)
      if isSelected && Mouse.trigger?(id) && @visible
        Game.system.se_play(Config::DECISION_SE)
        return true
      else
        return false
      end
    end
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ MUI::CheckBox
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2014
# --------------------------------------------------------------------------
# Description
# 
#    체크박스 컨트롤을 담당하는 클래스입니다.
#────────────────────────────────────────────────────────────────────────────
class MUI
  class CheckBox < Control    
    def initialize(x, y, w, h)
      super(x, y, w, h)
      @value = false
      @style = "White"
      loadCache(@style)
    end
    
    def style; @style; end
    def style=(value)
      loadCache(@style = value)
      return if @baseSprite.nil?
      refresh
    end
    
    def loadCache(style)
      @@cache = {}
      @@cache['false'] = RPG::Cache.checkBox(style + "/" + "0.png")
      @@cache['true']  = RPG::Cache.checkBox(style + "/" + "1.png")
      @bitmap = @@cache[@value.to_s]
    end
    
    def value; @value end
    def value=(value)
      return unless value.is_a?(TrueClass) or value.is_a?(FalseClass)
      @value = value
      @bitmap = @@cache[@value.to_s]
      return if @baseSprite.nil?
      refresh
    end
    
    def enable=(value)
      if value
        @enable = true
        @baseSprite.tone.set(0, 0, 0)
      else
        @enable = false
        @baseSprite.tone.set(-20, -20, -20, 255)
      end
    end
    
    def refresh
      @baseSprite.bitmap.clear
      @baseSprite.bitmap.blt(0, 0, @bitmap, Rect.new(0, 0, @bitmap.width, @bitmap.height))
    end
    
    def update
      super
      if Mouse.trigger? && isSelected
        Game.system.se_play(Config::DECISION_SE)
        self.value = @value ? false : true
      end
    end
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ MUI::RadioBox
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2014
# --------------------------------------------------------------------------
# Description
# 
#    라디오박스 컨트롤을 담당하는 클래스입니다.
#────────────────────────────────────────────────────────────────────────────
class MUI
  class RadioBox < Control    
    @@group = {}
    def initialize(x, y, w, h)
      super(x, y, w, h)
      @value = false
      @group = nil
      @style = "White"
      loadCache(@style)
      @bitmap = @@cache[@value.to_s]
    end
    
    def style; @style; end
    def style=(value)
      loadCache(@style = value)
      return if @baseSprite.nil?
      refresh
    end
    
    def loadCache(style)
      @@cache = {}
      @@cache['false'] = RPG::Cache.radioBox(style + "/" + "0.png")
      @@cache['true']  = RPG::Cache.radioBox(style + "/" + "1.png")
    end
    
    def value; @value end
    def value=(value)
      return if @value == value
      for others in @@group[@group]
        next if others == self
        others.valueProc = false
        others.bitmapProc = @@cache[false.to_s]
        others.refresh
      end
      @value = value
      @bitmap = @@cache[@value.to_s]
      return if @baseSprite.nil?
      refresh
    end
        
    def group; @group end
    def group=(value)
      return if @group == value
      @@group[@group] ||= []
      @@group[@group].delete(self) if @@group[@group].include?(self) and @@group[@group].is_a?(Array)
      @group = value
      @@group[@group] ||= []
      @@group[@group].push(self) unless @@group[@group].include?(self)
      @@group[@group][0].valueProc = true if @@group[@group].size <= 1
      @bitmap = @@cache[@value.to_s]
      return if @baseSprite.nil?
      refresh
    end
    
    def enable=(value)
      if value
        @enable = true
        @baseSprite.tone.set(0, 0, 0)
      else
        @enable = false
        @baseSprite.tone.set(-20, -20, -20, 255)
      end
    end
    
    def bitmapProc=(value); @bitmap = value end
    def valueProc=(value); @value = value end
    
    def refresh
      @baseSprite.bitmap.clear
      @baseSprite.bitmap.blt(0, 0, @bitmap, Rect.new(0, 0, @bitmap.width, @bitmap.height))
    end

    def update
      super
      if click && isSelected
        Game.system.se_play(Config::DECISION_SE)
        self.value = true
      end
    end
    
    def dispose
      super
      @@group[@group].delete(self) if @@group[@group].include?(self)
    end
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ MUI::VScroll
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2015. 02. 11
# --------------------------------------------------------------------------
# Description
# 
#    수직 스크롤바 컨트롤을 담당하는 클래스입니다.
#    바 드래그, 마우스 휠, 버튼 등을 사용할 수 있습니다.
#────────────────────────────────────────────────────────────────────────────
class MUI
  class VScroll < Control
    def initialize(x, y, w, h)
      super(x, y, w, h)
      loadCache(@style = "White")
      @barHeight = @height - (@@cache['VU'].height + @@cache['VD'].height + @@cache['VBU'].height + @@cache['VBD'].height)
      @max = 9
      @min = 0
      @num = @max - @min + 1
      @dh = @barHeight / @num.to_f
      @value = 0
      @scrolling = false
      @focus = nil
    end
    
    def style; @style; end
    def style=(value)
      loadCache(@style = value)
      return if @baseSprite.nil?
      refresh
    end

    def loadCache(style)
      @@cache = {}
      # Base Vertical
      @@cache['VU'] = RPG::Cache.vScroll(style + "/" + "VU")
      @@cache['VM'] = RPG::Cache.vScroll(style + "/" + "VM")
      @@cache['VD'] = RPG::Cache.vScroll(style + "/" + "VD")
      # Bar
      @@cache['VBU'] = RPG::Cache.vScroll(style + "/" + "VBU")
      @@cache['VBM'] = RPG::Cache.vScroll(style + "/" + "VBM")
      @@cache['VBD'] = RPG::Cache.vScroll(style + "/" + "VBD")
      @barHeight = @height - (@@cache['VU'].height + @@cache['VD'].height + @@cache['VBU'].height + @@cache['VBD'].height)
      @dh = @barHeight / @num.to_f
    end

    def setParent(form)
      @parent = form
      @baseSprite = Sprite.new(form.getViewport)
      @baseSprite.bitmap = Bitmap.new(@width, @height)
      @barSprite = Sprite.new(form.getViewport)
      @barSprite.bitmap = Bitmap.new(@width, @height)
      @baseSprite.x = @x
      @baseSprite.y = @y
      @barSprite.x = @x
      @barSprite.y = @y + @@cache['VU'].height
      @realX = @x + form.getViewport.rect.x
      @realY = @y + form.getViewport.rect.y
      refresh
    end
    
    def update
      super
      # 백그라운드 클릭
      if Mouse.trigger? and @visible
        # 포커스 등록
        @focus = isSelected ? self.object_id : nil
        # 클릭으로 조작
        if @focus and isSelected and not isBarSelected and not isUpSelected and not isDownSelected
          self.value = (Mouse.y - @realY - @@cache['VU'].height) / @dh
          Game.system.se_play(Config::BUZZER_SE)
        end
      end
      
      # 키보드로 조작
      if @focus == self.object_id
        # 아래, 오른쪽 키를 눌렀을 때
        if Key.repeat?(KEY_DOWN) or Key.repeat?(KEY_RIGHT)
          # 값 +1
          self.value += 1
        # 위, 왼쪽 키를 눌렀을 때
        elsif Key.repeat?(KEY_UP) or Key.repeat?(KEY_LEFT)
          # 값 -1
          self.value -= 1
        end
      end
      
      # [^], [v] 버튼
      if Mouse.repeat?
        # [^]
        if isUpSelected
          return if @scrolling
          self.value -= 1
          Game.system.se_play(Config::DECISION_SE) if Mouse.trigger?
        # [v]
        elsif isDownSelected
          return if @scrolling
          self.value += 1
          Game.system.se_play(Config::DECISION_SE) if Mouse.trigger?
        end
      end
      
      # 마우스 휠
      if @focus == self.object_id # 포커스가 잡힐 때
        if Mouse.wheel != 0 and not Mouse.wheel.nil?
          self.value += Mouse.wheel
          Mouse.wheel = 0
        end
      end
      
      # 바 드래그
      if isSelected
        @scrolling = Mouse.press? if isBarSelected
      else
        @scrolling = false unless Mouse.press?
      end
      if Mouse.press?
        if @scrolling
          # 폼 드래그 비허용
          @parent.drag = false
          # 증가분 구한 뒤
          dx, dy = Mouse.ox - Mouse.x, Mouse.oy - Mouse.y
          Mouse.x += dx
          Mouse.y += dy
          # 벨류에 더함
          self.value += dy / @dh
          # 마우스 포지션이 [^] 나 [v] 을 넘어가면 돌아올 때까지 최소, 최대값 적용
          if Mouse.y < @realY + @@cache['VU'].height
            self.value = @min
          elsif Mouse.y > @realY + @@cache['VU'].height + @barHeight
            self.value = @max
          end
        end
      else
        # 폼 드래그 허용
        @parent.drag = true
      end
    end
    
    # [^]
    def isUpSelected
      if Mouse.x >= @realX and
        Mouse.x <= @realX + @@cache['VU'].width and
        Mouse.y >= @realY and
        Mouse.y <= @realY + @@cache['VU'].height
        return true
      else
        return false
      end
    end
    
    # [v]
    def isDownSelected
      if Mouse.x >= @realX and
        Mouse.x <= @realX + @@cache['VD'].width and
        Mouse.y >= @realY + @height - @@cache['VD'].height and
        Mouse.y <= @realY + @height
        return true
      else
        return false
      end
    end
    
    # 스크롤바
    def isBarSelected
      if Mouse.x >= @realX and
        Mouse.x <= @realX + @width and
        Mouse.y >= @barSprite.y + @realY - @y and
        Mouse.y < @barSprite.y + @realY - @y + @dh.to_i + @@cache['VBU'].height + @@cache['VBD'].height
        return true
      else
        return false
      end
    end
    
    # 리프레시
    def refresh
      baseRefresh
      barRefresh
      @barSprite.y = @y + @@cache['VU'].height + @value * @dh
      @barSprite.visible = !(@max == @min)
    end
    
    # 바 리프레시
    def barRefresh
      @barSprite.bitmap.clear
      # Up
      @barSprite.bitmap.blt(0, 0, @@cache['VBU'], Rect.new(0, 0, @@cache['VBU'].width, @@cache['VBU'].height))
      # Middle
      @barSprite.bitmap.stretch_blt(
      Rect.new(0, @@cache['VBU'].height, @@cache['VBM'].width, @dh.round),
      @@cache['VBM'],
      Rect.new(0, 0, @@cache['VBM'].width, @@cache['VBM'].height))
      # Down
      @barSprite.bitmap.blt(0, @dh.round + @@cache['VBD'].height, @@cache['VBD'], Rect.new(0, 0, @@cache['VBD'].width, @@cache['VBD'].height))
    end
    
    # 베이스 리프레시
    def baseRefresh
      @baseSprite.bitmap.clear
      # Up
      @baseSprite.bitmap.blt(0, 0, @@cache['VU'], Rect.new(0, 0, @@cache['VU'].width, @@cache['VU'].height))
      # Middle
      @baseSprite.bitmap.stretch_blt(
      Rect.new(0, @@cache['VU'].height, @@cache['VM'].width, @height - (@@cache['VD'].height + @@cache['VU'].height)),
      @@cache['VM'],
      Rect.new(0, 0, @@cache['VM'].width, @@cache['VM'].height))      
      # Down
      @baseSprite.bitmap.blt(0, @height - @@cache['VD'].height, @@cache['VD'], Rect.new(0, 0, @@cache['VD'].width, @@cache['VD'].height))
    end

    # 최대값
    def max; @max end
    def max=(value)
      return if @max == value
      @max = value
      @num = @max - @min + 1
      @dh = @barHeight / @num.to_f
      return if @barSprite.nil?
      refresh
    end
    
    # 최소값 (0 권장)
    def min; @min end
    def min=(value)
      return if @min == value
      @min = value
      @num = @max - @min + 1
      @dh = @barHeight / @num.to_f
      return if @barSprite.nil?
      refresh
    end
    
    # 현재값
    def value; @value end
    def value=(value)
      return if @value == value
      @value = [[@min, value].max, @max].min
      return if @barSprite.nil?
      refresh
    end
    
    # 표시
    def visible; @visible end
    def visible=(value)
      super
      @barSprite.visible = value
      @barSprite.visible = !(@max == @min) if value
    end
    
    # 포커스
    def focus; @focus end
    def focus=(value)
      @focus = value
    end
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ MUI::HScroll
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2015. 02. 15
# --------------------------------------------------------------------------
# Description
# 
#    수평 스크롤바 컨트롤을 담당하는 클래스입니다.
#    바 드래그, 마우스 휠, 버튼 등을 사용할 수 있습니다.
#────────────────────────────────────────────────────────────────────────────
class MUI
  class HScroll < Control
    def initialize(x, y, w, h)
      super(x, y, w, h)
      loadCache(@style = "White")
      @barWidth = @width - (@@cache['VL'].width + @@cache['VR'].width + @@cache['VBL'].width + @@cache['VBR'].width)
      @max = 9
      @min = 0
      @num = @max - @min + 1
      @dw = @barWidth / @num.to_f
      @value = 0
      @scrolling = false
      @focus = nil
    end
    
    def style; @style; end
    def style=(value)
      loadCache(@style = value)
      return if @baseSprite.nil?
      refresh
    end
    
    def loadCache(style)
      @@cache = {}
      # Base Horizontal
      @@cache['VL'] = RPG::Cache.hScroll(style + "/" + "VL")
      @@cache['VM'] = RPG::Cache.hScroll(style + "/" + "VM")
      @@cache['VR'] = RPG::Cache.hScroll(style + "/" + "VR")
      # Bar
      @@cache['VBL'] = RPG::Cache.hScroll(style + "/" + "VBL")
      @@cache['VBM'] = RPG::Cache.hScroll(style + "/" + "VBM")
      @@cache['VBR'] = RPG::Cache.hScroll(style + "/" + "VBR")
      @barWidth = @width - (@@cache['VL'].width + @@cache['VR'].width + @@cache['VBL'].width + @@cache['VBR'].width)
      @dw = @barWidth / @num.to_f
    end

    def setParent(form)
      @parent = form
      @baseSprite = Sprite.new(form.getViewport)
      @baseSprite.bitmap = Bitmap.new(@width, @height)
      @barSprite = Sprite.new(form.getViewport)
      @barSprite.bitmap = Bitmap.new(@width, @height)
      @baseSprite.x = @x
      @baseSprite.y = @y
      @barSprite.x = @x + @@cache['VL'].width
      @barSprite.y = @y
      @realX = @x + form.getViewport.rect.x
      @realY = @y + form.getViewport.rect.y
      refresh
    end

    def update
      super
      # 백그라운드 클릭
      if Mouse.trigger? and @visible
        # 포커스 등록
        @focus = isSelected ? self.object_id : nil
        # 클릭으로 조작
        if @focus and isSelected and not isBarSelected and not isLeftSelected and not isRightSelected
          self.value = (Mouse.x - @realX - @@cache['VL'].width) / @dw
          Game.system.se_play(Config::BUZZER_SE)
        end
      end
      
      # 키보드로 조작
      if @focus == self.object_id
        # 아래, 오른쪽 키를 눌렀을 때
        if Key.repeat?(KEY_DOWN) or Key.repeat?(KEY_RIGHT)
          # 값 +1
          self.value += 1
        # 위, 왼쪽 키를 눌렀을 때
        elsif Key.repeat?(KEY_UP) or Key.repeat?(KEY_LEFT)
          # 값 -1
          self.value -= 1
        end
      end
      
      # [<], [>] 버튼
      if Mouse.repeat?
        # [<]
        if isLeftSelected
          return if @scrolling
          self.value -= 1
          Game.system.se_play(Config::DECISION_SE) if Mouse.trigger?
        # [>]
        elsif isRightSelected
          return if @scrolling
          self.value += 1
          Game.system.se_play(Config::DECISION_SE) if Mouse.trigger?
        end
      end
      
      # 마우스 휠
      if @focus == self.object_id # 포커스가 잡힐 때
        if !Mouse.wheel.nil? and Mouse.wheel != 0 
          self.value += Mouse.wheel
          Mouse.wheel = 0
        end
      end
      
      # 바 드래그
      if isSelected
        @scrolling = Mouse.press? if isBarSelected
      else
        @scrolling = false unless Mouse.press?
      end
      if Mouse.press?
        if @scrolling
          # 폼 드래그 비허용
          @parent.drag = false
          # 증가분 구한 뒤
          dx, dy = Mouse.ox - Mouse.x, Mouse.oy - Mouse.y
          Mouse.x += dx
          Mouse.y += dy
          # 벨류에 더함
          self.value += dx / @dw
          # 마우스 포지션이 [<] 나 [>] 을 넘어가면 돌아올 때까지 최소, 최대값 적용
          if Mouse.x <= @realX + @@cache['VL'].width
            self.value = @min
          elsif Mouse.x > @realX + @@cache['VL'].width + @barWidth
            self.value = @max
          end
        end
      else
        # 폼 드래그 허용
        @parent.drag = true
      end
    end
    
    # [<]
    def isLeftSelected
      if Mouse.x >= @realX and
        Mouse.x <= @realX + @@cache['VL'].width and
        Mouse.y >= @realY and
        Mouse.y <= @realY + @@cache['VL'].height
        return true
      else
        return false
      end
    end
    
    # [>]
    def isRightSelected
      if Mouse.x >= @realX + @width - @@cache['VR'].width and
        Mouse.x <= @realX + @width and
        Mouse.y >= @realY and
        Mouse.y <= @realY + @@cache['VR'].height
        return true
      else
        return false
      end
    end
    
    # 스크롤바
    def isBarSelected
      if Mouse.x >= @barSprite.x + @realX - @x and
        Mouse.x <= @barSprite.x + @realX - @x + @dw.to_i + @@cache['VBL'].width + @@cache['VBR'].width and
        Mouse.y >= @realY and
        Mouse.y < @realY + @height
        return true
      else
        return false
      end
    end
    
    # 리프레시
    def refresh
      baseRefresh
      barRefresh
      @barSprite.x = @x + @@cache['VL'].width + @value * @dw
      @barSprite.visible = !(@max == @min)
    end
    
    # 바 리프레시
    def barRefresh
      @barSprite.bitmap.clear
      # Up
      @barSprite.bitmap.blt(0, 0, @@cache['VBL'], Rect.new(0, 0, @@cache['VBL'].width, @@cache['VBL'].height))
      # Middle
      @barSprite.bitmap.stretch_blt(
      Rect.new(@@cache['VBL'].width, 0, @dw.round, @@cache['VBM'].height),
      @@cache['VBM'],
      Rect.new(0, 0, @@cache['VBM'].width, @@cache['VBM'].height))
      # Down
      @barSprite.bitmap.blt(@dw.round + @@cache['VBR'].width, 0, @@cache['VBR'], Rect.new(0, 0, @@cache['VBR'].width, @@cache['VBR'].height))
    end
    
    # 베이스 리프레시
    def baseRefresh
      @baseSprite.bitmap.clear
      # Up
      @baseSprite.bitmap.blt(0, 0, @@cache['VL'], Rect.new(0, 0, @@cache['VL'].width, @@cache['VL'].height))
      # Middle
      @baseSprite.bitmap.stretch_blt(
      Rect.new(@@cache['VL'].width, 0, @width - (@@cache['VL'].width + @@cache['VR'].width), @@cache['VM'].height),
      @@cache['VM'],
      Rect.new(0, 0, @@cache['VM'].width, @@cache['VM'].height))
      # Down
      @baseSprite.bitmap.blt(@width - @@cache['VR'].height, 0, @@cache['VR'], Rect.new(0, 0, @@cache['VR'].width, @@cache['VR'].height))
    end
    
    # 최대값
    def max; @max end
    def max=(value)
      return if @max == value
      @max = value
      @num = @max - @min + 1
      @dw = @barWidth / @num.to_f
      return if @barSprite.nil?
      refresh
    end
    
    # 최소값 (0 권장)
    def min; @min end
    def min=(value)
      return if @min == value
      @min = value
      @num = @max - @min + 1
      @dw = @barWidth / @num.to_f
      return if @barSprite.nil?
      refresh
    end
    
    # 현재값
    def value; @value end
    def value=(value)
      return if @value == value
      @value = [[@min, value].max, @max].min
      return if @barSprite.nil?
      refresh
    end
    
    # 표시
    def visible; @visible end
    def visible=(value)
      super
      @barSprite.visible = value
      @barSprite.visible = !(@max == @min) if value
    end
    
    # 포커스
    def focus; @focus end
    def focus=(value)
      @focus = value
    end
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ MUI::TabPage
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2015. 02. 17
# --------------------------------------------------------------------------
# Description
# 
#    탭 컨트롤을 담당하는 클래스입니다.
#    탭 길이에 오차가 생기면 자동 조정합니다.
#────────────────────────────────────────────────────────────────────────────
class MUI
  class TabPage < Control
    attr_reader :page
    
    def initialize(x, y, w, h)
      super(x, y, w, h)
      loadCache(@style = "White")
      @align = 1
      @bold = false
      @italic = false
      @color = [Color.gray, Color.white]
      @name = Config::FONT[0]
      @size = Config::FONT_NORMAL_SIZE
      @item = [""]
      @tab = []
      @page = 0
    end
    
    # 정렬 // 왼쪽 0, 가운데 1, 오른쪽 2
    def align; @align end
    def align=(value)
      return if @align == value
      @align = value
      return if @baseSprite.nil?
      refresh
    end
    
    # 굵게
    def bold; @bold end
    def bold=(value)
      return if @bold == value
      @bold = value
      return if @baseSprite.nil?
      @item.each_index { |n| @baseSprite[n].bitmap.font.bold = @bold }
      refresh
    end
    
    # 기울기
    def italic; @italic end
    def italic=(value)
      return if @italic == value
      @italic = value
      return if @baseSprite.nil?
      @item.each_index { |n| @baseSprite[n].bitmap.font.italic = @italic }
      refresh
    end
    
    # 기본 색깔
    def color; @color[0] end
    def color=(value)
      return if @color[0] == value
      @color[0] = value
      return if @baseSprite.nil?
      @item.each_index { |n| @baseSprite[n].bitmap.font.color = @color[0] }
      refresh
    end
    
    # 선택 색깔
    def color2; @color[1] end
    def color2=(value)
      return if @color[1] == value
      @color[1] = value
      return if @baseSprite.nil?
      @item.each_index { |n| @baseSprite[n].bitmap.font.color = @color[1] }
      refresh
    end
    
    # 폰트명
    def name; @name end
    def name=(value)
      return if @name == value
      @name = value
      return if @baseSprite.nil?
      @item.each_index { |n| @baseSprite[n].bitmap.font.name = @name }
      refresh
    end
    
    # 크기
    def size; @size end
    def size=(value)
      return if @size == value
      @size = value
      return if @baseSprite.nil?
      @item.each_index { |n| @baseSprite[n].bitmap.font.size = @size }
      refresh
    end
    
    def item; @item end
    def item=(value)
      return if @item == value
      @item = value
      return if @baseSprite.nil?
      refresh
    end

    def tab; @tab end
    def page; @page end
      
    def style; @style; end
    def style=(value)
      loadCache(@style = value)
      return if @baseSprite.nil?
      refresh
    end
      
    def loadCache(style)
      @@cache = {}
      @@cache['L'] = RPG::Cache.tab(style + "/" + "L")
      @@cache['M'] = RPG::Cache.tab(style + "/" + "M")
      @@cache['R'] = RPG::Cache.tab(style + "/" + "R")
      @@cache['L2'] = RPG::Cache.tab(style + "/" + "L2")
      @@cache['M2'] = RPG::Cache.tab(style + "/" + "M2")
      @@cache['R2'] = RPG::Cache.tab(style + "/" + "R2")
    end
    
    def setParent(form)
      @parent = form
      @tabWidth = @width / @item.size.to_f
      autoSize if @width % @item.size.to_i != 0
      for page in 0...@item.size
        @tab[page] = Tab.new(@parent)
      end
      @baseSprite = []
      for n in 0...@item.size
        @baseSprite[n] = Sprite.new(form.getViewport)
        @baseSprite[n].x = @x + @tabWidth * n
        @baseSprite[n].y = @y
      end
      @realX = @x + form.getViewport.rect.x
      @realY = @y + form.getViewport.rect.y
      refresh
    end

    def set
      for i in 0...@item.size
        next if i == @page
        @tab[i].visible = false
      end
      @tab[@page].visible = true
    end
    
    def refresh
      self.set
      bitmapRefresh
      @item.each_index { |n| baseRefresh(n) }
    end
    
    def baseRefresh(n)
      @baseSprite[n].bitmap = @baseBitmap[@page == n ? 1 : 0].dup
      @baseSprite[n].bitmap.font.color = Color.gray
      @baseSprite[n].bitmap.font.name = @name
      @baseSprite[n].bitmap.font.size = @size
      @baseSprite[n].bitmap.font.bold = @bold
      @baseSprite[n].bitmap.font.italic = @italic
      @baseSprite[n].bitmap.font.color = @color[@page == n ? 1 : 0]
      @baseSprite[n].visible = @visible
      @baseSprite[n].opacity = @opacity
      @baseSprite[n].bitmap.draw_text(0, 0, @baseSprite[n].bitmap.width, @baseSprite[n].bitmap.height, @item[n], @align)
    end
    
    def bitmapRefresh
      @baseBitmap = []
      @baseBitmap[0] = Bitmap.new(@tabWidth, @height)
      @baseBitmap[0].blt(0, 0, @@cache['L'], Rect.new(0, 0, @@cache['L'].width, @@cache['L'].height))
      @baseBitmap[0].blt(@width - @@cache['R'].width, 0, @@cache['R'], Rect.new(0, 0, @@cache['R'].width, @@cache['R'].height))
      @baseBitmap[0].stretch_blt(Rect.new(@@cache['L'].width, 0, width - (@@cache['L'].width + @@cache['R'].width), @@cache['M'].height), @@cache['M'], Rect.new(0, 0, @@cache['M'].width, @@cache['M'].height))
      @baseBitmap[1] = Bitmap.new(@tabWidth, @height)
      @baseBitmap[1].blt(0, 0, @@cache['L2'], Rect.new(0, 0, @@cache['L2'].width, @@cache['L2'].height))
      @baseBitmap[1].blt(@width - @@cache['R2'].width, 0, @@cache['R2'], Rect.new(0, 0, @@cache['R2'].width, @@cache['R2'].height))
      @baseBitmap[1].stretch_blt(Rect.new(@@cache['L2'].width, 0, width - (@@cache['L2'].width + @@cache['R2'].width), @@cache['M2'].height), @@cache['M2'], Rect.new(0, 0, @@cache['M2'].width, @@cache['M2'].height))      
    end
    
    def autoSize
      @tabWidth = @tabWidth.to_i
      self.width = @tabWidth * @item.size
    end
    
    def isSelected?
      for n in 0...@item.size
        if Mouse.x >= @baseSprite[n].x + @realX - @x and
          Mouse.x <= @baseSprite[n].x + @tabWidth + @realX - @x and
          Mouse.y >= @baseSprite[n].y + @realY - @y and
          Mouse.y <= @baseSprite[n].y + @height + @realY - @y and
          select = n
        end
      end
      return select
    end
    
    def update
      super
      if Mouse.trigger?
        if (n = isSelected?) != nil
          @page = n
          refresh
          Game.system.se_play(Config::DECISION_SE)
        end
      end
    end
    
    def dispose
      super
      @baseBitmap[0].dispose
      @baseBitmap[1].dispose
      @baseBitmap = nil
      @item.each_index do |n|
        @baseSprite[n].dispose
      end
    end
    
    # 탭 구성원 컨트롤
    class Tab
      def initialize(form)
        @control = []
        @parent = form
      end
      
      def visible=(value)
        for control in @control
          control.visible = value
        end
      end
      
      def addControl(control)
        @parent.addControl(control)
        @control.push(control)
      end
      
      def dispose
        super
        @control = nil
      end
    end
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ MUI::ListBox
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2015. 02. 18
# --------------------------------------------------------------------------
# Description
# 
#    리스트박스 컨트롤을 담당하는 클래스입니다.
#────────────────────────────────────────────────────────────────────────────
class MUI
  class ListBox < Control
    def initialize(x, y, w, h)
      super(x, y, w, h)
      @name = Config::FONT[0]
      @size = Config::FONT_NORMAL_SIZE
      @color = [Color.gray, Color.system]
      @visible = true
      @opacity = 255
      @list = []
      @vsc = MUI::VScroll.new(@x + @width - 13, @y, 13, @height)
    end
    
    def getItemPerPage
      @lbl = []
      # 페이지에 보이는 요소 갯수 구하기
      @itemPerPage = @height / (@size + 2)# + 1
      @itemPerPage += 1 if @height % (@size + 2) != 0
      # (갯수+1)만큼 레이블 생성
      @vsc.x = @x + @width - @vsc.width
      @vsc.y = @y
      @itemPerPage.times do |n|
        next if @list[n] == nil
        @lbl[n] = MUI::Label.new(@x, @y + n * @size, @width - @vsc.width, @size)
        #@lbl[n].text = @list[n].to_s
        @parent.addControl(@lbl[n])
      end
      @vsc.max = @list.size - @itemPerPage
      @vsc.min = 0
    end
    
    def refresh
      @baseSprite.bitmap.clear
      @baseSprite.bitmap.fill_rect(0, 0, @width, @height, Color.white)
      @baseSprite.visible = @visible
      @baseSprite.opacity = @opacity
    end
    
    def update
      super
      # 스크롤바 포커스
      @vsc.focus = @vsc.id if Mouse.trigger? and isSelected
      @itemPerPage.times do |n|
        @lbl[n].text = @list[n + @vsc.value].to_s
        if @lbl[n].click
          #@lbl[n].color = @color[1]
          @focus = n + @vsc.value
        end
      end
    end
    
    def focus; @focus end
    def focus=(value)
      @focus = value
    end
    
    def addItem(*args)
      # 요소 추가
      @list.push(args)
      # 1차원 배열화
      @list.flatten!
    end
    
    def clear
      @list = []
      @vsc.max = @vsc.min
    end
    
    def removeItem(value)
      @list.delete_at(value)
    end
    
    def list(value); @list[value] end
    def listIndex; @focus; end
    
    def visible=(value)
      super
      @vsc.visible = value
      @lbl.each_index { |n| @lbl[n].visible = value }
    end
    
    def setParent(form)
      @parent = form
      @baseSprite = Sprite.new(form.getViewport)
      @baseSprite.bitmap = Bitmap.new(@width, @height)
      @baseSprite.x = @x
      @baseSprite.y = @y
      @realX = @x + form.getViewport.rect.x
      @realY = @y + form.getViewport.rect.y
      @parent.addControl(@vsc)
      getItemPerPage
      refresh
    end
  end
end

#────────────────────────────────────────────────────────────────────────────
# ▶ MUI::Cursor
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com)
# Date      2015
# --------------------------------------------------------------------------
# Description
# 
#    마우스 커서를 담당하는 클래스입니다.
#────────────────────────────────────────────────────────────────────────────
class MUI
  class Cursor < Sprite
    def initialize
      @viewport = Viewport.new(0, 0, Graphics.getRect[0], Graphics.getRect[1])
      @viewport.z = 9999999
      super(@viewport)
      @route = "Graphics/Icons/"
      @x = Mouse.x
      @y = Mouse.y
      self.bitmap = RPG::Cache.icon(Config::MOUSE)
      self.x = @x
      self.y = @y
      self.z = 1
    end
    
    def setImage(value)
      self.bitmap = value
    end
    
    def setDefaultImage
      self.bitmap = RPG::Cache.icon(Config::MOUSE)
    end
    
    def update
      super
      if Mouse.press?
        if @x != Mouse.ox or @y != Mouse.oy
          @x = Mouse.ox
          @y = Mouse.oy
          self.x = @x
          self.y = @y
        end
      else
        if @x != Mouse.x or @y != Mouse.y
          @x = Mouse.x
          @y = Mouse.y
          self.x = @x
          self.y = @y
        end
      end
    end
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ MUI_HUD
# --------------------------------------------------------------------------
# Author    jubin
# Date      2015. 2. 5
# --------------------------------------------------------------------------
# Description
# 
#    헤드 업 디스플레이를 표시합니다.
#    메뉴 클릭이 가능하며, 단축키를 등록할 수 있습니다.
#────────────────────────────────────────────────────────────────────────────
class MUI_HUD
  
  def loadCache
    @@cache = {}
    @@cache[:hud]       = RPG::Cache.hud(Config::FILE_HUD)
    @@cache[:gauge_hp]  = RPG::Cache.hud(Config::FILE_HP)
    @@cache[:gauge_mp]  = RPG::Cache.hud(Config::FILE_MP)
    @@cache[:gauge_exp] = RPG::Cache.hud(Config::FILE_EXP)
    @@cache[:menu_icon] = []
    for n in 0..5
      @@cache[:menu_icon][n] = RPG::Cache.hud("menu#{n}")
    end
  end
  
  def initialize
    # 표시
    @visible = true
    # Rect
    @rect = {}
    # 이전 값
    @old = {}
    # 캐시
    loadCache()
    # 뷰포트
    @viewport = {}
    @viewport[:hud] = Viewport.new(0, 0, Graphics.getRect[0], Graphics.getRect[1])
    @viewport[:hud].z = 999
    @viewport[:icon_shortcut] = []
    for n in 0...Config::COOLTIME_RECT.size
      @viewport[:icon_shortcut][n] = Viewport.new(Config::COOLTIME_RECT[n])
      @viewport[:icon_shortcut][n].z = 1000
    end
    # 스프라이트 생성
    @sprite = {}
    @@cache.each_key do |key|
      # 아래 캐시 제외
      next if [:gauge_hp, :gauge_mp, :gauge_exp, :menu_icon].include?(key)
      @sprite[key] = Sprite.new(@viewport[:hud])
      @sprite[key].bitmap = Bitmap.new(@@cache[key].width, @@cache[key].height)
      @sprite[key].bitmap.blt(0, 0, @@cache[key], Rect.new(0, 0, @@cache[key].width, @@cache[key].height))
    end
    # 레벨
    @sprite[:txt_lv] = Sprite.new(@viewport[:hud])
    @sprite[:txt_lv].bitmap = Bitmap.new(40, 16)
    @sprite[:txt_lv].bitmap.font.name = Config::FONT[1]
    @sprite[:txt_lv].bitmap.font.size = 14
    @sprite[:txt_lv].x = Config::LV_TEXT_X
    @sprite[:txt_lv].y = Config::LV_TEXT_Y
    @sprite[:txt_lv].z = 1
    # HP
    @sprite[:txt_hp] = Sprite.new(@viewport[:hud])
    @sprite[:txt_hp].bitmap = Bitmap.new(@@cache[:gauge_hp].width, 14)
    @sprite[:txt_hp].bitmap.font.name = Config::FONT[1]
    @sprite[:txt_hp].bitmap.font.size = 12
    @sprite[:txt_hp].x = Config::HP_TEXT_X
    @sprite[:txt_hp].y = Config::HP_TEXT_Y
    @sprite[:txt_hp].z = 1
    # MP
    @sprite[:txt_mp] = Sprite.new(@viewport[:hud])
    @sprite[:txt_mp].bitmap = Bitmap.new(@@cache[:gauge_mp].width, 14)
    @sprite[:txt_mp].bitmap.font.name = Config::FONT[1]
    @sprite[:txt_mp].bitmap.font.size = 12
    @sprite[:txt_mp].x = Config::MP_TEXT_X
    @sprite[:txt_mp].y = Config::MP_TEXT_Y
    @sprite[:txt_mp].z = 1
    # EXP
    @sprite[:txt_exp] = Sprite.new(@viewport[:hud])
    @sprite[:txt_exp].bitmap = Bitmap.new(@@cache[:gauge_exp].width, 14)
    @sprite[:txt_exp].bitmap.font.name = Config::FONT[1]
    @sprite[:txt_exp].bitmap.font.size = 12
    @sprite[:txt_exp].x = Config::EXP_TEXT_X
    @sprite[:txt_exp].y = Config::EXP_TEXT_Y
    @sprite[:txt_exp].z = 1
    # 메뉴
    @sprite[:menu_icon] = []
    for n in 0...6
      @sprite[:menu_icon][n] = Sprite.new(@viewport[:hud])
      @sprite[:menu_icon][n].bitmap = Bitmap.new(@@cache[:menu_icon][n].width, @@cache[:menu_icon][n].height)
      @sprite[:menu_icon][n].bitmap.blt(0, 0, @@cache[:menu_icon][n], Rect.new(0, 0, @@cache[:menu_icon][n].width, @@cache[:menu_icon][n].height))
      @sprite[:menu_icon][n].x = Config::MENU_ICON_X + n * Config::MENU_ICON_GAP
      @sprite[:menu_icon][n].y = Config::MENU_ICON_Y
    end
    # 단축키
    @sprite[:icon_shortcut] = []
    for n in 0...Config::SHORTCUT_RECT.size
      @sprite[:icon_shortcut][n] = Sprite.new(@viewport[:icon_shortcut][n])
    end
    # 쿨타임
    @sprite[:cool] = []
    for n in 0...Config::COOLTIME_RECT.size
      width, height = Config::COOLTIME_RECT[n].width, Config::COOLTIME_RECT[n].height
      @sprite[:cool][n] = Sprite.new(@viewport[:icon_shortcut][n])
      @sprite[:cool][n].bitmap = Bitmap.new(width, height)
      @sprite[:cool][n].zoom_y = 0
      @sprite[:cool][n].bitmap.fill_rect(0,0,32,33, Color.new(150,150,150,100)) 
    end
    # 게이지바
    barDraw(:gauge_hp, Config::HP_X, Config::HP_Y, Config::HP_BORDER)
    barDraw(:gauge_mp, Config::MP_X, Config::MP_Y, Config::MP_BORDER)
    barDraw(:gauge_exp, Config::EXP_X, Config::EXP_Y, Config::EXP_BORDER)
    barRefresh(:gauge_hp, Game.player.hp, Game.player.maxHp)
    barRefresh(:gauge_mp, Game.player.mp, Game.player.maxMp)
    barRefresh(:gauge_exp, Game.player.exp, Game.player.maxExp)
  end
  
  # 메인 업데이트
  def update
    return if not @visible # 숨김 상태에서는 중단
    barRefresh(:gauge_hp, Game.player.hp, Game.player.maxHp)
    barRefresh(:gauge_mp, Game.player.mp, Game.player.maxMp)
    barRefresh(:gauge_exp, Game.player.exp, Game.player.maxExp)
    textRefresh(:txt_lv, Game.player.level)
    textRefresh(:txt_hp, Game.player.hp)
    textRefresh(:txt_mp, Game.player.mp)
    textRefresh(:txt_exp, Game.player.exp)
    ctRefresh(:cool)
    menuSelected
    iconSelected
    keyUpdate
  end
  
  # 슬롯 작동
  def keyUpdate
    return if MUI.nowTyping?
    for i in 0...10
      next if Game.slot.getSlot(i) == -1
      if Key.trigger?(Game.slot.getKey(i))
        Socket.send({'header' => CTSHeader::USE_SKILL, 'no' => Game.getSkill(Game.slot.getSlot(i)).no})
      end
    end
  end
  
  # 게이지바 생성
  def barDraw(key, x, y, border)
    @rect[key] = []
    @viewport[key] = []
    @sprite[key] = []
    # left
    @rect[key][0] = Rect.new(0, 0, border[0], @@cache[key].height)
    # center
    @rect[key][1] = Rect.new(border[0], 0, @@cache[key].width - border[0] - border[1], @@cache[key].height)
    # right
    @rect[key][2] = Rect.new(@@cache[key].width - border[1], 0, border[1], @@cache[key].height)
    3.times do |n|
      begin
        @sprite[key][n] = Sprite.new(@viewport[:hud])
        @sprite[key][n].bitmap = Bitmap.new(@rect[key][n].width, @rect[key][n].height)
        @sprite[key][n].bitmap.blt(0, 0, @@cache[key], @rect[key][n])
        @sprite[key][n].x = x
        @sprite[key][n].y = y
      rescue
        # border == 0
      end
    end
    @sprite[key][1].x = x + @rect[key][0].width
    @sprite[key][2].x = x + @sprite[key][1].src_rect.width + @rect[key][0].width
  end
  
  # 슬롯 리프레시
  def slotRefresh(key)
    @sprite[key] ||= []
    for n in 0...10
      @sprite[key][n] ||= Sprite.new(@viewport[key][n])
      if Game.slot.getSlot(n) == -1
        @viewport[:icon_shortcut][n].visible = false
        next
      else
        @viewport[:icon_shortcut][n].visible = true
      end
      @sprite[key][n].bitmap = RPG::Cache.icon(Game.getSkill(Game.slot.getSlot(n)).image)
      #@sprite[key][n].bitmap = Bitmap.new(@viewport[key][n].rect.width, @viewport[key][n].rect.height)
      #@sprite[key][n].bitmap.blt(0, 0, RPG::Cache.icon(Game.getSkill(Game.slot.getSlot(n)).image), Rect.new(0, 0, 32, 32))
    end
  end
  
  # 쿨타임 리프레쉬
  def ctRefresh(key)
    for i in 0...10
      if Game.slot.getSlot(i) == -1
        @viewport[:icon_shortcut][i].visible = false
        next
      else
        @viewport[:icon_shortcut][i].visible = true
      end
      skill = Game.getSkill(Game.slot.getSlot(i))
      cooltime = Game.cooltime.getCool(i)
      if cooltime.nowCooltime.to_f <= 0
        @sprite[key][i].zoom_y = 0
      else
        @sprite[key][i].zoom_y = cooltime.nowCooltime.to_f / cooltime.fullCooltime.to_f
        @sprite[key][i].y = 26 - 25 * cooltime.nowCooltime.to_f / cooltime.fullCooltime.to_f
      end
    end
  end

  # 게이지바 리프레시
  def barRefresh(key, now, max)
    @old[key] ||= @sprite[key][1].src_rect.width
    if @old[key] != now
      delta = now * @sprite[key][1].bitmap.width / max.to_f - @old[key]
      barSlide(key, delta)
      @old[key] = @sprite[key][1].src_rect.width
    end
  end
  
  # 게이지바 슬라이딩
  def barSlide(key, delta)
    if delta != 0
      @sprite[key][1].src_rect.width += (delta / Config::BAR_SPEED).to_i
      if @sprite[key][1].src_rect.width > @sprite[key][1].bitmap.width
        @sprite[key][1].src_rect.width = @sprite[key][1].bitmap.width
      end
      if @sprite[key][1].src_rect.width < 0
        @sprite[key][1].src_rect.width = 0
      end
      @sprite[key][2].x = @sprite[key][1].x + @sprite[key][1].src_rect.width
    end
  end
  
  # 텍스트 리프레시
  def textRefresh(key, now)
    if @old[key] != now
      case key
      when :txt_lv
        @sprite[key].bitmap.clear
        @sprite[key].bitmap.draw_outline_text(
          0, 0, @sprite[key].bitmap.width, @sprite[key].bitmap.height,
          Game.player.level.to_s, Color.white, Color.new(255, 120, 0), 1)
      when :txt_hp
        n, m = Game.player.hp, Game.player.maxHp
        @sprite[key].bitmap.clear
        @sprite[key].bitmap.draw_outline_text(
          0, 0, @sprite[key].bitmap.width, @sprite[key].bitmap.height,
          "#{n} / #{m}", Color.white, Color.red, 1)
      when :txt_mp
        n, m = Game.player.mp, Game.player.maxMp
        @sprite[key].bitmap.clear
        @sprite[key].bitmap.draw_outline_text(
        0, 0, @sprite[key].bitmap.width, @sprite[key].bitmap.height,
        "#{n} / #{m}", Color.white, Color.new(0, 128, 224), 1)
      when :txt_exp
        n, m = Game.player.exp, Game.player.maxExp
        @sprite[key].bitmap.clear
        @sprite[key].bitmap.draw_outline_text(
        0, 0, @sprite[key].bitmap.width, @sprite[key].bitmap.height,
        "#{n} / #{m} (#{n * 100 / m}%)", Color.white, Color.black(128), 1)
      end
      @old[key] = now
    end
  end
  
  # 메뉴 선택
  def menuSelected
    if (n = menuIndex)
      @sprite[:menu_icon][n].opacity = 128 if @sprite[:menu_icon][n].opacity != 128
      if Mouse.trigger?
        case n
        when 0
          MUI.include?(MUI_Status)    ? MUI.getForm(MUI_Status).dispose    : MUI_Status.new
        when 1
          MUI.include?(MUI_Skill)     ? MUI.getForm(MUI_Skill).dispose     : MUI_Skill.new
        when 2
          MUI.include?(MUI_Inventory) ? MUI.getForm(MUI_Inventory).dispose : MUI_Inventory.new
        when 3
          MUI.include?(MUI_Quest)     ? MUI.getForm(MUI_Quest).dispose     : MUI_Quest.new
        when 4
          MUI.include?(MUI_Community) ? MUI.getForm(MUI_Community).dispose      : MUI_Community.new
        when 5
          MUI.include?(MUI_Option)    ? MUI.getForm(MUI_Option).dispose    : MUI_Option.new
        end
      end
    else
      for n in 0..5
        @sprite[:menu_icon][n].opacity = 255 if @sprite[:menu_icon][n].opacity != 255
      end
    end
  end
  
  # 단축키 선택
  def iconSelected
    if (n = iconIndex)
      # Info
      if Mouse.trigger?(0) && MUI.dragItem
        # 단축키 등록
        if MUI.dragItem.is_a?(Skill)
          Socket.send({'header' => CTSHeader::SET_SLOT, 'index' => iconIndex, 'itemidx' => Game.getSkill(MUI.dragItem.no).no})
        else
          Socket.send({'header' => CTSHeader::SET_SLOT, 'index' => iconIndex, 'itemidx' => MUI.dragItem.index})
        end
        MUI.dragItem = nil
      elsif Mouse.trigger?(1)
        Socket.send({'header' => CTSHeader::DEL_SLOT, 'index' => iconIndex})
        slotRefresh(:icon_shortcut)
      end
    end
  end
  
  # 메뉴 인덱스
  def menuIndex
    for n in 0..5
      sprite = @sprite[:menu_icon][n]
      cache = @@cache[:menu_icon][n]
      if Mouse.x >= sprite.x and Mouse.x <= sprite.x + cache.width and
        Mouse.y >= sprite.y and Mouse.y <= sprite.y + cache.height
        select = n
      end
    end
    return select
  end
  
  # 단축키 인덱스
  def iconIndex
    for n in 0...Config::SHORTCUT_RECT.size
      viewport = @viewport[:icon_shortcut][n]
      if Mouse.x >= viewport.rect.x and Mouse.x <= viewport.rect.x + viewport.rect.width and
        Mouse.y >= viewport.rect.y and Mouse.y <= viewport.rect.y + viewport.rect.height
        select = n
      end
    end
    return select
  end
  
  # 표시
  def visible; @visible end
  def visible=(value)
    return unless value.is_a?(TrueClass) or value.is_a?(FalseClass)
    # 뷰포트
    @viewport.each_key do |key|
      if @viewport[key].is_a?(Array)
        @viewport[key].each_index { |n| @viewport[key][n].visible = value }
      else
        @viewport[key].visible = value
      end
    end
    # 스프라이트
    @sprite.each_key do |key|
      if @sprite[key].is_a?(Array)
        @sprite[key].each_index { |n| @sprite[key][n].visible = value }
      else
        @sprite[key].visible = value
      end
    end
    @visible = value
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ FlashMessage
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com)
# Date      2011. 9. 29
# --------------------------------------------------------------------------
# Description
# 
#    플래시 메시지를 표시합니다. 페이드 인 / 아웃 기능이 있습니다.
#    스크립트 : 메시지("내용", Color.new())
#    색을 지정하지 않으면 디폴트 색 (검정색) 으로 출력됩니다.
#────────────────────────────────────────────────────────────────────────────
class FlashMessage
  attr_accessor :text
  
  def initialize
    @sprite = Sprite.new
    @sprite.bitmap = Bitmap.new(Graphics.getRect[0], 20)
    @sprite.x = 0
    @sprite.y = 100
    @sprite.z = 999999
    @sprite.opacity = 0
    @text = ""
    @fade_in = false
    @fade_out = false
    @wait_count = 40
  end
  
  def change_color(new_color)
    @sprite.bitmap.font.color = new_color
  end
  
  def refresh
    @sprite.bitmap.clear
    @sprite.bitmap.fill_rect(Rect.new(0,0,Graphics.getRect[0],20), Color.new(0, 0, 0, 100))
    @sprite.bitmap.draw_text(1, 3, Graphics.getRect[0], 12, @text, 1)
    @sprite.bitmap.draw_text(1, 4, Graphics.getRect[0], 12, @text, 1)
    @sprite.bitmap.draw_text(1, 5, Graphics.getRect[0], 12, @text, 1)
    @sprite.bitmap.draw_text(-1, 3, Graphics.getRect[0], 12, @text, 1)
    @sprite.bitmap.draw_text(-1, 4, Graphics.getRect[0], 12, @text, 1)
    @sprite.bitmap.draw_text(-1, 5, Graphics.getRect[0], 12, @text, 1)
    @sprite.bitmap.draw_text(0, 3, Graphics.getRect[0], 12, @text, 1)
    @sprite.bitmap.draw_text(0, 5, Graphics.getRect[0], 12, @text, 1)
    @sprite.bitmap.font.color = Color.new(255, 255, 255)
    @sprite.bitmap.draw_text(0, 4, Graphics.getRect[0], 12, @text, 1)
    @sprite.visible = true
    @fade_in = true
  end
  
  def update
    if @fade_in
      if @sprite.opacity < 255
        @sprite.opacity += 10
        return
      elsif @wait_count > 0
        @wait_count -= 1
        return
      else
        @fade_out = true
        @fade_in = false
      end
    end
    if @fade_out
      if @sprite.opacity > 0
        @sprite.opacity -= 10
        return
      else
        @wait_count = 40
        @fade_out = false
        @fade_in = false
        @text = ""
        @sprite.visible = false
      end
    end
  end
  
  def write(msg, new_color = Color.new(0, 0, 0))
    @text = msg
    change_color(new_color)
    refresh
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ MUI_ItemInfo
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2015. 2. 22
# --------------------------------------------------------------------------
# Description
# 
#    아이템의 정보를 띄우는 클래스입니다.
#────────────────────────────────────────────────────────────────────────────
class MUI
  class ItemInfo
    def self.init
      @viewport = Viewport.new(0, 0, 10, 10)
      @viewport.z = 999999 + 1
      @sprite = Sprite.new(@viewport)
      @sprite.bitmap = Bitmap.new(@viewport.rect.width, @viewport.rect.height)
    end
    
    def self.set(item)
      return if not item
      return if @item == item
      clear
      @item = item
      @itemData = Game.getItem(item.itemNo)
      width = 200
      @section = {}
      # 이미지
      @section['@image'] = Bitmap.new(width, 36)
      icon = RPG::Cache.icon(@itemData.image)
      @section['@image'].fill_rect(0, 0, @section['@image'].width, @section['@image'].height, Color.black(128))
      @section['@image'].blt(
        (@section['@image'].width - icon.width) / 2,
        (@section['@image'].height - icon.height) / 2,
        icon, Rect.new(0, 0, icon.width, icon.height))
      
      # 이름 (타입)
      name = @item.reinforce == 0 ? @itemData.name : @itemData.name + " + " + @item.reinforce.to_s
      @section['@name'] = Bitmap.new(width, 24)
      @section['@name'].fill_rect(0, 0, @section['@name'].width, @section['@name'].height, Color.black(192))
      @section['@name'].font.name = Config::FONT[1]
      @section['@name'].font.size = 15
      @section['@name'].draw_text(0, (@section['@name'].height - @section['@name'].font.size) / 2, 
        @section['@name'].width, @section['@name'].font.size, name, 1)
      
      # 설명
      @section['@description'] = Bitmap.new(1, 1)
      line = @section['@description'].get_divided_text(width - 12, @itemData.description).size
      @section['@description'] = Bitmap.new(width, line * 14 + 20)
      @section['@description'].fill_rect(0, 0, @section['@description'].width, @section['@description'].height, Color.black(128))
      @section['@description'].draw_multi_outline_text(
        6, 10, @section['@description'].width - 18, @section['@description'].height,
        @itemData.description, Color.white, Color.black(128))
      
      # 타입
      @section['@type'] = Bitmap.new(width, 16) 
      @section['@type'].fill_rect(0, 0, @section['@type'].width, @section['@type'].height, Color.black(128))
      @section['@type'].draw_outline_text(
        0, 0, @section['@type'].width, @section['@type'].height,
        "(" + Game.getItemType(@itemData.type) + " 아이템)",
        Color.white, Color.black(128), 1)
        
      # 사용 여부
      @section['@consume'] = Bitmap.new(width, 16) 
      @section['@consume'].fill_rect(0, 0, @section['@consume'].width, @section['@consume'].height, Color.black(128))
      @section['@consume'].draw_outline_text(
        0, 0, @section['@consume'].width, @section['@consume'].height,
        @itemData.consume.zero? ? "사용 불가" : "사용 가능",
        @itemData.consume.zero? ? Color.new(255, 160, 0) : Color.white, Color.black(128), 1)
      
      # 거래 여부
      @section['@trade'] = Bitmap.new(width, 16) 
      @section['@trade'].fill_rect(0, 0, @section['@trade'].width, @section['@trade'].height, Color.black(128))
      @section['@trade'].draw_outline_text(
        0, 0, @section['@trade'].width, @section['@trade'].height,
        @itemData.trade.zero? ? "거래 불가" : "거래 가능",
        @itemData.trade.zero? ? Color.new(255, 160, 0) : Color.white, Color.black(128), 1)
        
      # 사용 가능 레벨
      @section['@limitLevel'] = Bitmap.new(width, 20) 
      @section['@limitLevel'].fill_rect(0, 0, @section['@limitLevel'].width, @section['@limitLevel'].height, Color.black(128))
      @section['@limitLevel'].draw_outline_text(
        0, 0, @section['@limitLevel'].width - 5, @section['@limitLevel'].height,
        @itemData.limitLevel.to_s + " 레벨 이상 사용 가능",
        Color.white, Color.black(128), 2)
  
      # 가격
      @section['@price'] = Bitmap.new(width, 20) 
      @section['@price'].fill_rect(0, 0, @section['@price'].width, @section['@price'].height, Color.black(128))
      @section['@price'].draw_outline_text(
        0, 0, @section['@price'].width - 5, @section['@price'].height,
        "\\" + Math.unitMoney(@itemData.price),
        Color.white, Color.black(128), 2)
      
      # STR
      @section['@str'] = Bitmap.new(width, 20) 
      @section['@str'].fill_rect(0, 0, @section['@str'].width, @section['@str'].height, Color.black(128))
      @section['@str'].font.name = Config::FONT[0]
      @section['@str'].draw_outline_text(
        12, 0, @section['@str'].width, @section['@str'].height,
        "STR",
        Color.new(0, 192, 255), Color.black(128), 0)
      @section['@str'].draw_outline_text(
        0, 0, @section['@str'].width - 12, @section['@str'].height,
        @itemData.str.to_s + " ( +" + @item.str.to_s + " )",
        Color.new(0, 192, 255), Color.black(128), 2)
        
      # DEX
      @section['@dex'] = Bitmap.new(width, 20)
      @section['@dex'].fill_rect(0, 0, @section['@dex'].width, @section['@dex'].height, Color.black(128))
      @section['@dex'].font.name = Config::FONT[0]
      @section['@dex'].draw_outline_text(
        12, 0, @section['@dex'].width, @section['@dex'].height,
        "DEX",
        Color.new(0, 192, 255), Color.black(128), 0)
      @section['@dex'].draw_outline_text(
        0, 0, @section['@dex'].width - 12, @section['@dex'].height,
        @itemData.dex.to_s + " ( +" + @item.dex.to_s + " )",
        Color.new(0, 192, 255), Color.black(128), 2)
        
      # AGI
      @section['@agi'] = Bitmap.new(width, 20)
      @section['@agi'].fill_rect(0, 0, @section['@agi'].width, @section['@agi'].height, Color.black(128))
      @section['@agi'].font.name = Config::FONT[0]
      @section['@agi'].draw_outline_text(
        12, 0, @section['@agi'].width, @section['@agi'].height,
        "AGI",
        Color.new(0, 192, 255), Color.black(128), 0)
      @section['@agi'].draw_outline_text(
        0, 0, @section['@agi'].width - 12, @section['@agi'].height,
        @itemData.agi.to_s + " ( +" + @item.agi.to_s + " )",
        Color.new(0, 192, 255), Color.black(128), 2)
        
      # 크리티컬
      @section['@critical'] = Bitmap.new(width, 20)
      @section['@critical'].fill_rect(0, 0, @section['@critical'].width, @section['@critical'].height, Color.black(128))
      @section['@critical'].font.name = Config::FONT[0]
      @section['@critical'].draw_outline_text(
        12, 0, @section['@critical'].width, @section['@critical'].height,
        "크리티컬",
        Color.new(0, 192, 255), Color.black(128), 0)
      @section['@critical'].draw_outline_text(
        0, 0, @section['@critical'].width - 12, @section['@critical'].height,
        @itemData.critical.to_s + " ( +" + @item.critical.to_s + " )",
        Color.new(0, 192, 255), Color.black(128), 2)
        
      # 회피율
      @section['@avoid'] = Bitmap.new(width, 20)
      @section['@avoid'].fill_rect(0, 0, @section['@avoid'].width, @section['@avoid'].height, Color.black(128))
      @section['@avoid'].font.name = Config::FONT[0]
      @section['@avoid'].draw_outline_text(
        12, 0, @section['@avoid'].width, @section['@avoid'].height,
        "회피율",
        Color.new(0, 192, 255), Color.black(128), 0)
      @section['@avoid'].draw_outline_text(
        0, 0, @section['@avoid'].width - 12, @section['@avoid'].height,
        @itemData.avoid.to_s + " ( +" + @item.avoid.to_s + " )",
        Color.new(0, 192, 255), Color.black(128), 2)
        
      # 명중율
      @section['@hit'] = Bitmap.new(width, 20)
      @section['@hit'].fill_rect(0, 0, @section['@hit'].width, @section['@hit'].height, Color.black(128))
      @section['@hit'].font.name = Config::FONT[0]
      @section['@hit'].draw_outline_text(
        12, 0, @section['@hit'].width, @section['@hit'].height,
        "명중율",
        Color.new(0, 192, 255), Color.black(128), 0)
      @section['@hit'].draw_outline_text(
        0, 0, @section['@hit'].width - 12, @section['@hit'].height,
        @itemData.hit.to_s + " ( +" + @item.hit.to_s + " )",
        Color.new(0, 192, 255), Color.black(128), 2)
      
      # 딜레이
      @section['@delay'] = Bitmap.new(width, 20)
      @section['@delay'].fill_rect(0, 0, @section['@delay'].width, @section['@delay'].height, Color.black(128))
      @section['@delay'].font.name = Config::FONT[0]
      @section['@delay'].draw_outline_text(
        12, 0, @section['@delay'].width, @section['@delay'].height,
        "딜레이",
        Color.new(0, 192, 255), Color.black(128), 0)
      @section['@delay'].draw_outline_text(
        0, 0, @section['@delay'].width - 12, @section['@delay'].height,
        @itemData.delay.to_s,
        Color.new(0, 192, 255), Color.black(128), 2)
        
      # 물리공격력
      @section['@damage'] = Bitmap.new(width, 20)
      @section['@damage'].fill_rect(0, 0, @section['@damage'].width, @section['@damage'].height, Color.black(128))
      @section['@damage'].font.name = Config::FONT[0]
      @section['@damage'].draw_outline_text(
        12, 0, @section['@damage'].width, @section['@damage'].height,
        "물리공격력",
        Color.new(0, 192, 255), Color.black(128), 0)
      @section['@damage'].draw_outline_text(
        0, 0, @section['@damage'].width - 12, @section['@damage'].height,
        @itemData.damage.to_s + " ( +" + @item.damage.to_s + " )",
        Color.new(0, 192, 255), Color.black(128), 2)
  
      # 마법공격력
      @section['@magic_damage'] = Bitmap.new(width, 20)
      @section['@magic_damage'].fill_rect(0, 0, @section['@magic_damage'].width, @section['@magic_damage'].height, Color.black(128))
      @section['@magic_damage'].font.name = Config::FONT[0]
      @section['@magic_damage'].draw_outline_text(
        12, 0, @section['@magic_damage'].width, @section['@magic_damage'].height,
        "마법공격력",
        Color.new(0, 192, 255), Color.black(128), 0)
      @section['@magic_damage'].draw_outline_text(
        0, 0, @section['@magic_damage'].width - 12, @section['@magic_damage'].height,
        @itemData.magicDamage.to_s + " ( +" + @item.magicDamage.to_s + " )",
        Color.new(0, 192, 255), Color.black(128), 2)
        
      # 물리방어력
      @section['@defense'] = Bitmap.new(width, 20)
      @section['@defense'].fill_rect(0, 0, @section['@defense'].width, @section['@defense'].height, Color.black(128))
      @section['@defense'].font.name = Config::FONT[0]
      @section['@defense'].draw_outline_text(
        12, 0, @section['@defense'].width, @section['@defense'].height,
        "물리방어력",
        Color.new(0, 192, 255), Color.black(128), 0)
      @section['@defense'].draw_outline_text(
        0, 0, @section['@defense'].width - 12, @section['@defense'].height,
        @itemData.defense.to_s + " ( +" + @item.defense.to_s + " )",
        Color.new(0, 192, 255), Color.black(128), 2)
  
      # 마법방어력
      @section['@magic_defense'] = Bitmap.new(width, 20)
      @section['@magic_defense'].fill_rect(0, 0, @section['@magic_defense'].width, @section['@magic_defense'].height, Color.black(128))
      @section['@magic_defense'].font.name = Config::FONT[0]
      @section['@magic_defense'].draw_outline_text(
        12, 0, @section['@magic_defense'].width, @section['@magic_defense'].height,
        "마법방어력",
        Color.new(0, 192, 255), Color.black(128), 0)
      @section['@magic_defense'].draw_outline_text(
        0, 0, @section['@magic_defense'].width - 12, @section['@magic_defense'].height,
        @itemData.magicDefense.to_s + " ( +" + @item.magicDefense.to_s + " )",
        Color.new(0, 192, 255), Color.black(128), 2)      
        
      # HP
      @section['@hp'] = Bitmap.new(width, 20)
      @section['@hp'].fill_rect(0, 0, @section['@hp'].width, @section['@hp'].height, Color.black(128))
      @section['@hp'].font.name = Config::FONT[0]
      @section['@hp'].draw_outline_text(
        12, 0, @section['@hp'].width, @section['@hp'].height,
        "HP",
        Color.new(0, 192, 255), Color.black(128), 0)      
      @section['@hp'].draw_outline_text(
        0, 0, @section['@hp'].width - 12, @section['@hp'].height,
        @itemData.hp.to_s + " ( +" + @item.hp.to_s + " )",
        Color.new(0, 192, 255), Color.black(128), 2)      
        
      # MP
      @section['@mp'] = Bitmap.new(width, 20)
      @section['@mp'].fill_rect(0, 0, @section['@mp'].width, @section['@mp'].height, Color.black(128))
      @section['@mp'].font.name = Config::FONT[0]
      @section['@mp'].draw_outline_text(
        12, 0, @section['@mp'].width, @section['@mp'].height,
        "MP",
        Color.new(0, 192, 255), Color.black(128), 0)
      @section['@mp'].draw_outline_text(
        0, 0, @section['@mp'].width - 12, @section['@mp'].height,
        @itemData.mp.to_s + " ( +" + @item.mp.to_s + " )",
        Color.new(0, 192, 255), Color.black(128), 2)
      # 섹션 합체
      @viewport = Viewport.new(0, 0, width, Graphics.getRect[1])
      @viewport.z = 999999 + 1
      @sprite = Sprite.new(@viewport)
      @sprite.bitmap = Bitmap.new(@viewport.rect.width, @viewport.rect.height)
      blt(0, 0, '@name')
      blt(0, 24, '@image')
      blt(0, 60, '@type')
      blt(0, 76, '@consume')
      blt(0, 92, '@trade')
      blt(0, 109, '@description')
      h = @section['@description'].height
      batch = ['@str', '@dex', '@agi', '@critical', '@avoid', '@hit', '@delay', '@damage', '@magic_damage', '@defense', '@magic_defense', '@hp', '@mp']
      n = 0
      for i in 0...batch.size
        if @itemData.instance_variable_get(batch[i]) != 0
          blt(0, h + 110 + n * 20, batch[i])
          n += 1
        end
      end
      h2 = h + 110 + n * 20 + 1
      blt(0, h2, '@price')
      blt(0, h2 + 20, '@limitLevel')
    end
    
    def self.blt(x, y, key)
      if @itemData.instance_variable_get(key) != 0 or ['@type', '@consume', '@trade', '@price', '@limitLevel'].include?(key)
        @sprite.bitmap.blt(x, y, @section[key], Rect.new(0, 0, @section[key].width, @section[key].height))
      end
    end
    
    def self.update
      @viewport.rect.x = Mouse.x
      @viewport.rect.y = Mouse.y
    end
    
    def self.clear
      return if not @item
      @item = nil
      @sprite.bitmap.clear
    end
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ MUI_ItemInfo
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), @cheapmunk.naver
# Date      2015. 2. 22
# --------------------------------------------------------------------------
# Description
# 
#    아이템의 정보를 띄우는 클래스입니다.
#────────────────────────────────────────────────────────────────────────────
class MUI
  class SkillInfo
    def self.init
      @viewport = Viewport.new(0, 0, 10, 10)
      @viewport.z = 999999 + 1
      @sprite = Sprite.new(@viewport)
      @sprite.bitmap = Bitmap.new(@viewport.rect.width, @viewport.rect.height)
    end
    
    def self.set(skill)
      return if not skill
      return if @skill == skill
      clear
      @skill = skill
      @skillData = Game.getSkill(skill.no)
      width = 200
      @section = {}
  
      # 이미지
      @section['@image'] = Bitmap.new(width, 36)
      icon = RPG::Cache.icon(@skillData.image)
      @section['@image'].fill_rect(0, 0, @section['@image'].width, @section['@image'].height, Color.black(128))
      @section['@image'].blt(
        (@section['@image'].width - icon.width) / 2,
        (@section['@image'].height - icon.height) / 2,
        icon, Rect.new(0, 0, icon.width, icon.height))
      
      # 이름 (타입)
      name = @skillData.name
      @section['@name'] = Bitmap.new(width, 24)
      @section['@name'].fill_rect(0, 0, @section['@name'].width, @section['@name'].height, Color.black(192))
      @section['@name'].font.name = Config::FONT[1]
      @section['@name'].font.size = 15
      @section['@name'].draw_text(0, (@section['@name'].height - @section['@name'].font.size) / 2, 
        @section['@name'].width, @section['@name'].font.size, name, 1)
      
      # 설명
      @section['@description'] = Bitmap.new(1, 1)
      line = @section['@description'].get_divided_text(width - 12, @skillData.description).size
      @section['@description'] = Bitmap.new(width, line * 14 + 20)
      @section['@description'].fill_rect(0, 0, @section['@description'].width, @section['@description'].height, Color.black(128))
      @section['@description'].draw_multi_outline_text(
        6, 10, @section['@description'].width - 18, @section['@description'].height,
        @skillData.description, Color.white, Color.black(128))
      
      # 타입
      @section['@type'] = Bitmap.new(width, 16) 
      @section['@type'].fill_rect(0, 0, @section['@type'].width, @section['@type'].height, Color.black(128))
      @section['@type'].draw_outline_text(
        0, 0, @section['@type'].width, @section['@type'].height,
        "(" + @skillData.type + ")",
        Color.white, Color.black(128), 1)
        
      # 사용 가능 레벨
      @section['@limitLevel'] = Bitmap.new(width, 20) 
      @section['@limitLevel'].fill_rect(0, 0, @section['@limitLevel'].width, @section['@limitLevel'].height, Color.black(128))
      @section['@limitLevel'].draw_outline_text(
        0, 0, @section['@limitLevel'].width - 5, @section['@limitLevel'].height,
        @skillData.limitLevel.to_s + " 레벨 이상 사용 가능",
        Color.white, Color.black(128), 2)
        
      # 딜레이
      @section['@delay'] = Bitmap.new(width, 20)
      @section['@delay'].fill_rect(0, 0, @section['@delay'].width, @section['@delay'].height, Color.black(128))
      @section['@delay'].font.name = Config::FONT
      @section['@delay'].draw_outline_text(
        12, 0, @section['@delay'].width, @section['@delay'].height,
        "쿨타임",
        Color.new(0, 192, 255), Color.black(128), 0)
      @section['@delay'].draw_outline_text(
        0, 0, @section['@delay'].width - 12, @section['@delay'].height,
        "#{@skillData.delay.to_f / 5}",
        Color.new(0, 192, 255), Color.black(128), 2)
      
 
      # 섹션 합체
      @viewport = Viewport.new(0, 0, width, Graphics.getRect[1])
      @viewport.z = 999999 + 1
      @sprite = Sprite.new(@viewport)
      @sprite.bitmap = Bitmap.new(@viewport.rect.width, @viewport.rect.height)
      blt(0, 0, '@name')
      blt(0, 24, '@image')
      blt(0, 60, '@type')
      blt(0, 76, '@description')
      h = @section['@description'].height
      batch = []
      batch.push('@delay') if @section['@delay']
      batch.push('@damage') if @section['@damage']
      n = 0
      for i in 0...batch.size
        if @skillData.instance_variable_get(batch[i]) != 0
          blt(0, h + 77 + n * 20, batch[i])
          n += 1
        end
      end
      h2 = h + 57 + n * 20 + 1
      blt(0, h2 + 20, '@limitLevel')
    end
    
    def self.blt(x, y, key)
      if @skillData.instance_variable_get(key) != 0 or ['@type', '@consume', '@trade', '@price', '@limitLevel'].include?(key)
        @sprite.bitmap.blt(x, y, @section[key], Rect.new(0, 0, @section[key].width, @section[key].height))
      end
    end
    
    def self.update
      @viewport.rect.x = Mouse.x
      @viewport.rect.y = Mouse.y
    end
    
    def self.clear
      return if not @skill
      @skill = nil
      @sprite.bitmap.clear
    end
  end
end

class MUI
  class Console
    include Config
    def self.init
      viewport = Viewport.new(RECT_CHATBOX)
      viewport.z = 2000
      @backSprite = Sprite.new(viewport)
      @backSprite.bitmap = Bitmap.new(RECT_CHATBOX.width, RECT_CHATBOX.height)
      @backSprite.bitmap.fill_rect(0, 0, RECT_CHATBOX.width, RECT_CHATBOX.height, Color.black(100))
      @sprite = Sprite.new(viewport)
      @sprite.z = 1
      @sprite.bitmap = Bitmap.new(RECT_CHATBOX.width, RECT_CHATBOX.height)
      @sprite.bitmap.font.name = FONT
      @sprite.bitmap.font.size = FONT_NORMAL_SIZE
      @message = []
    end
    
    def self.write(msg, color1 = Color.white, color2 = Color.black)
      @sprite.bitmap.clear
      x = 5
      y = 5
      w = @sprite.viewport.rect.width - x * 2
      h = @sprite.bitmap.font.size
      text = @sprite.bitmap.get_divided_text(w, msg)
      for t in text
        msg = Message.new
        msg.text = t
        msg.color1 = color1
        msg.color2 = color2
        @message.shift if @message.size > 5
        @message.push(msg)
      end
      for i in (@message.size - 6)...@message.size
        next if i < 0
        break if not @message[i]
        @sprite.bitmap.draw_outline_text(x, y + i * h, w, h, 
          @message[i].text, @message[i].color1, @message[i].color2)
      end
    end
  end
  
  class Message
    attr_accessor :text
    attr_accessor :color1
    attr_accessor :color2
  end
end
class MUI
  class ChatBox
    include Config
    def self.init
      @helpText = "대화하시려면 Enter키를 눌러주세요."
      @text = ""
      @ime = IME.new
      @viewport = Viewport.new(*RECT_INPUT.to_a)
      @viewport.z = 2000
      @baseSprite = Sprite.new(@viewport)
      @baseSprite.bitmap = Bitmap.new(RECT_INPUT.width, RECT_INPUT.height)
      @baseSprite.bitmap.fill_rect(0, 0, RECT_INPUT.width, RECT_INPUT.height, Color.black(128))
      @textSprite = Sprite.new(@viewport)
      @textSprite.y = 1
      @textSprite.z = 1
      @textBitmap = Bitmap.new(RECT_INPUT.width, RECT_INPUT.height)
      @focus = false
    end
    
    def self.focus; @focus end
    def self.focus=(value)
      return if @focus == value
      return unless value.is_a?(TrueClass) or value.is_a?(FalseClass)
      @focus = value
      return if @textBitmap.nil?
      refresh
    end
    
    def self.setFocus
      self.focus = true
      @ime.choice = false
      @ime.focus = true
    end
    
    def self.loseFocus
      self.focus = false
      @ime.choice = true
      @ime.focus = false
    end
    
    def self.update
      if Key.trigger?(KEY_RETURN)
        if @focus
          if @text != ""
            Socket.send({'header' => CTSHeader::CHAT, 'message' => @text})
            @text = ""
            @ime.clear
          else
            loseFocus
          end
          textRefresh
        else
          setFocus
        end
      end
      if @focus
        @ime.update
        textRefresh if @text != @ime.getText
      end
    end
        
    def self.refresh
      @textSprite.bitmap = @textBitmap
      textRefresh
    end
    
    def self.textRefresh
      @text = @ime.getText
      @textBitmap.clear
      if @focus
        @textBitmap.draw_outline_text(5, 0, RECT_INPUT.width, RECT_INPUT.height, @text + "_")
        @textSprite.bitmap = @textBitmap
      elsif @helpText != "" and @helpText != nil
        @textBitmap.draw_outline_text(5, 0, 
        RECT_INPUT.width, RECT_INPUT.height, @helpText)
      end
    end
  end
end

#────────────────────────────────────────────────────────────────────────────
# ▶ MUI_Server
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2014. 7. 27
# --------------------------------------------------------------------------
# Description
# 
#    서버 리스트 폼입니다.
#    Config::SERVER 변수에서 서버를 등록 및 수정할 수 있습니다.
#────────────────────────────────────────────────────────────────────────────

class MUI_Server < MUI::Form
  def initialize
    # 폼 생성 (x, y, width, height), ('center' => 가운데 위치)
    super('center', 300, 200, Config::SERVER.size * 58)
    # 드래그, 닫기 비허용
    self.drag = self.close = false
    # 서버 이름, 아이콘 배열 생성
    @lbl_server_name = []; @pic_server = []
    # 서버 리스트 로드
    for n in 0...Config::SERVER.size
      # 서버 이름
      @lbl_server_name[n] = MUI::Label.new(80, 14 + n*48, 100, Config::FONT_NORMAL_SIZE)
      @lbl_server_name[n].text = Config::SERVER[n][2]
      @lbl_server_name[n].color = Color.gray
      # 서버 아이콘
      @pic_server[n] = MUI::PictureBox.new(44, 8 + n*48, 24, 24)
      @pic_server[n].picture = "Graphics/Icons/" + Config::SERVER[n][3]
      # 컨트롤 생성
      addControl(@pic_server[n])
      addControl(@lbl_server_name[n])
      # 텍스트 크기 자동 조절 (생성 후 사용하세요.)
      @lbl_server_name[n].autoSize
      # 툴팁 설정
      @lbl_server_name[n].toolTip = @pic_server[n].toolTip = "#{Config::SERVER[n][2]}"
    end
  end
  
  def refresh
    super
    # 폼 타이틀
    setTitle("서버")
  end
  
  def update
    super
    # 서버 리스트 로드
    for n in 0...Config::SERVER.size
      # 서버에 마우스 올리면 컬러링, 밑줄
      @lbl_server_name[n].color = 
        @pic_server[n].isSelected || @lbl_server_name[n].isSelected ? Color.system : Color.gray
      @lbl_server_name[n].underLine = 
        @pic_server[n].isSelected || @lbl_server_name[n].isSelected
      # 서버 선택 시
      if @lbl_server_name[n].click or @pic_server[n].click
        # 선택 변수에 대입한 뒤
        select = n
        # 다이어로그 표시
        dialog = MUI_Dialog.new(Dialog::SERVER, "알림", "#{Config::SERVER[select][2]}에 입장하시겠습니까?", ["예", "아니오"]) do
          # 예를 누를 시
          if dialog.value == 0
            # 서버 접속
            Socket.connect(Config::SERVER[select][0], Config::SERVER[select][1])
            $scene = Scene_Login.new
            Graphics.transition
            dialog.dispose
          # 아니오를 누를 시
          elsif dialog.value == 1
            dialog.dispose
          end
        end        
      end
    end
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ MUI_Login
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2014. 11. 15
# --------------------------------------------------------------------------
# Description
# 
#    로그인 폼 클래스입니다.
#    관련 패킷 헤더는 CTSHeader::LOGIN 을 참고하세요.
#────────────────────────────────────────────────────────────────────────────

class MUI_Login < MUI::Form
  def initialize
    # 폼 생성
    super('center', 300, 260, 240)
    # 드래그, 닫기 비허용
    self.drag = self.close = false
    
    ## 아이콘
    # 아이디
    @pic_id = MUI::PictureBox.new(43, 32, 9, 9)
    @pic_id.picture = "Graphics/MUI/Login/" + "icon_id"
    addControl(@pic_id)
    # 패스워드
    @pic_pw = MUI::PictureBox.new(43, 71, 9, 9)
    @pic_pw.picture = "Graphics/MUI/Login/" + "icon_pw"
    addControl(@pic_pw)
    
    ## 텍스트박스
    # 아이디
    @tb_id = MUI::TextBox.new(60, 20, 150, 32)
    @tb_id.helpText = "아이디"
    addControl(@tb_id)
    # 패스워드
    @tb_pw = MUI::TextBox.new(60, 60, 150, 32)
    @tb_pw.helpText = "패스워드"
    # 비밀번호용 문자
    @tb_pw.passwordChar = "*"
    addControl(@tb_pw)
    
    ## 버튼
    # 로그인
    @btn_login = MUI::Button.new(60, 100, 150, 32)
    @btn_login.picture = "Graphics/MUI/Login/" + "key.png"
    addControl(@btn_login)
    
    ## 체크박스
    # 아이디
    @chk_id = MUI::CheckBox.new(22, 29, 14, 14)
    # 아이디 문자열 로드
    Win32API::GetPrivateProfileString.call("User", "id", "", id = 0.chr * 20, id.size, "./User.ini")
    id = id.unpack("c*").pack("c*")
    id.gsub!(0.chr, "")
    @chk_id.value = (id != "")
    @tb_id.text = id if id != ""
    addControl(@chk_id)
    
    ## 레이블
    # 계정 생성
    @lbl_regis = MUI::Label.new(0, 160, 200, Config::FONT_NORMAL_SIZE*2)
    @lbl_regis.align = 1
    @lbl_regis.text = "계정이 없습니까?\n이곳을 클릭하십시오."
    addControl(@lbl_regis)
    # 텍스트 크기 자동 조절 후 가운데로 위치
    @lbl_regis.autoSize
    @lbl_regis.x = (self.width - @lbl_regis.width) / 2
    @lbl_regis.color = Color.gray
  end

  def refresh
    super
    # 폼 타이틀
    setTitle("로그인")
  end
  
  def update
    super
    # 컬러링, 밑줄
    @pic_id.picture = "Graphics/MUI/Login/" + "icon_id" + (@tb_id.focus ? "_sel" : "")
    @pic_pw.picture = "Graphics/MUI/Login/" + "icon_pw" + (@tb_pw.focus ? "_sel" : "")
    @lbl_regis.color = @lbl_regis.isSelected ? Color.system : Color.gray
    @lbl_regis.underLine = @lbl_regis.isSelected
    # 회원가입 레이블 누를 시
    if @lbl_regis.click
      # 회원가입 폼 띄움
      Socket.send({'header' => CTSHeader::OPEN_REGISTER_WINDOW})
      self.dispose
    # 로그인 버튼 누를 시
    elsif @btn_login.click
      if @tb_id.text == "" or @tb_pw.text == ""
        dialog = MUI_Dialog.new(Dialog::LOGIN, "로그인 실패", "아이디나 비밀번호를 입력하지 않으셨습니다.", ["닫기"]) do
          dialog.dispose if dialog.value == 0 
        end        
      else
        # 패킷 전송
        Socket.send({
          'header' => CTSHeader::LOGIN,
          'id'     => @tb_id.text,
          'pass'   => @tb_pw.text})
        # 아이디 저장
        if @chk_id.value
          Win32API::WritePrivateProfileString.call("User", "id", @tb_id.text, "./User.ini")
        end
      end
    elsif @chk_id.click
      if not @chk_id.value
        # 아이디 문자열 삭제
        Win32API::WritePrivateProfileString.call("User", "id", @tb_id.text = "", "./User.ini")
      end
    end
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ MUI_Register
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2014. 11. 15
# --------------------------------------------------------------------------
# Description
# 
#    회원가입 폼 클래스입니다.
#    관련 패킷 헤더는 CTSHeader::REGISTER 을 참고하세요.
#────────────────────────────────────────────────────────────────────────────

class MUI_Register < MUI::Form
  def initialize(images, jobs)
    # 서버에서 캐릭터, 직업을 받아 저장
    @images, @jobs = images, jobs
    # 비트맵, 인덱스 변수 초기화
    @bitmap = []; @n = 0
    # 비트맵 로드
    @images.each_index { |n| @bitmap.push (Bitmap.new("Graphics/Characters/#{@images[n]}.png")) }
    
    # 폼 생성
    super('center', 'center', 260, 420)
    # 드래그, 닫기 비허용
    self.drag = self.close = false
    
    # 캐릭터 윈도우
    @pic_window = MUI::PictureBox.new(66, 12, 128, 128)
    @pic_window.picture = Bitmap.new("Graphics/MUI/Register/" + "window.png")
    addControl(@pic_window)
    # 직업 이름
    @lbl_job = MUI::Label.new(66, 110, 128, Config::FONT_NORMAL_SIZE)
    @lbl_job.align = 1 # 가운데 정렬
    @lbl_job.color = Color.gray
    addControl(@lbl_job)    
    # 캐릭터 이미지
    @pic_image = MUI::PictureBox.new(0, 0, 1, 1)
    addControl(@pic_image)
    update_character(@n) # 그래픽 업데이트
    # 왼쪽 버튼
    @pic_left = MUI::PictureBox.new(20, 50, 34, 34)
    @pic_left.picture = Bitmap.new("Graphics/MUI/Register/" + "btn_left")
    addControl(@pic_left)
    # 오른쪽 버튼
    @pic_right = MUI::PictureBox.new(@width - 54, 50, 34, 34)
    @pic_right.picture = Bitmap.new("Graphics/MUI/Register/" + "btn_right")
    addControl(@pic_right)

    ## 아이콘
    # 아이디
    @pic_id = MUI::PictureBox.new(20, 162, 9, 9)
    @pic_id.picture = Bitmap.new("Graphics/MUI/Login/" + "icon_id.png")
    addControl(@pic_id)
    # 패스워드
    @pic_pw = MUI::PictureBox.new(20, @pic_id.y + 40, 9, 9)
    @pic_pw.picture = Bitmap.new("Graphics/MUI/Login/" + "icon_pw.png")
    addControl(@pic_pw)
    # 닉네임
    @pic_name = MUI::PictureBox.new(20, @pic_pw.y + 40 - 5, 9, 13)
    @pic_name.picture = Bitmap.new("Graphics/MUI/Login/" + "icon_name.png")
    addControl(@pic_name)
    # 이메일
    @pic_email = MUI::PictureBox.new(21, @pic_name.y + 40 + 5, 9, 9)
    @pic_email.picture = Bitmap.new("Graphics/MUI/Login/" + "icon_email.png")
    addControl(@pic_email)
    
    ## 텍스트박스
    # 아이디
    @tb_id = MUI::TextBox.new(40, 150, 200, 32)
    @tb_id.helpText = "아이디" # 헬프 텍스트
    addControl(@tb_id)
    # 패스워드
    @tb_pw = MUI::TextBox.new(@tb_id.x, @tb_id.y + 40, 200, 32)
    @tb_pw.helpText = "패스워드"
    @tb_pw.passwordChar = "*"
    addControl(@tb_pw)
    # 닉네임
    @tb_name = MUI::TextBox.new(@tb_pw.x, @tb_pw.y + 40, 200, 32)
    @tb_name.helpText = "닉네임"
    addControl(@tb_name)
    # 이메일
    @tb_email = MUI::TextBox.new(@tb_name.x, @tb_name.y + 40, 200, 32)
    @tb_email.helpText = "이메일"
    addControl(@tb_email)
    
    ## 버튼
    # 생성
    @btn_apply = MUI::Button.new(20, 315, @width - 40, 32)
    @btn_apply.size = 14 # 글자 사이즈
    @btn_apply.bold = true # 굵게
    @btn_apply.picture = ("Graphics/MUI/Register/" + "apply.png")
    addControl(@btn_apply)
    
    ## 레이블
    # 로그인 폼으로
    @lbl_login = MUI::Label.new(113, 360, 34, Config::FONT_NORMAL_SIZE)
    @lbl_login.text = "로그인"
    @lbl_login.color = Color.gray
    addControl(@lbl_login)
  end

  def refresh
    super
    # 폼 타이틀
    setTitle("계정 만들기")
  end
  
  # 캐릭터 정보 업데이트
  def update_character(n)
    @pic_image.picture = @bitmap[n]
    @pic_image.width = @bitmap[n].width / 4
    @pic_image.height = @bitmap[n].height / 4
    @pic_image.x = 54 + (152 - @bitmap[n].width / 4) / 2
    @pic_image.y = @pic_window.y + (128 - @bitmap[n].height / 4) / 2
    @lbl_job.text = Game.getJob(@jobs[n])
  end
  
  def update
    super
    # 컬러링
    @pic_id.picture = "Graphics/MUI/Login/" + "icon_id" + (@tb_id.focus ? "_sel" : "")
    @pic_pw.picture = "Graphics/MUI/Login/" + "icon_pw" + (@tb_pw.focus ? "_sel" : "")
    @pic_name.picture = "Graphics/MUI/Login/" + "icon_name" + (@tb_name.focus ? "_sel" : "")
    @pic_email.picture = "Graphics/MUI/Login/" + "icon_email" + (@tb_email.focus ? "_sel" : "")
    @pic_left.picture = "Graphics/MUI/Register/" + (@pic_left.isSelected ? "btn_left2" : "btn_left")
    @pic_right.picture = "Graphics/MUI/Register/" + (@pic_right.isSelected ? "btn_right2" : "btn_right")
    @lbl_login.color = @lbl_login.isSelected ? Color.system : Color.gray
    # 왼쪽 버튼 누를 시
    if @pic_left.click
      if @n > 0
        update_character(@n -= 1)
      end
    # 오른쪽 버튼 누를 시
    elsif @pic_right.click
      if @n < @bitmap.length - 1
        update_character(@n += 1)
      end
    # 생성 버튼 누를 시
    elsif @btn_apply.click
      # 패킷 전송
      Socket.send({
        'header' => CTSHeader::REGISTER,
        'id'     => @tb_id.text,
        'pass'   => @tb_pw.text,
        'name'   => @tb_name.text,
        'mail'   => @tb_email.text,
        'no'     => @n + 1})
    # 로그인 레이블 누를 시
    elsif @lbl_login.click
      # 로그인 폼으로
      MUI_Login.new
      self.dispose
    end
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ MUI_Dialog
# --------------------------------------------------------------------------
# Author    jubin
# Date      2014. 2. 12
# --------------------------------------------------------------------------
# Description
# 
#    대화상자를 띄우는 폼 클래스입니다.
#────────────────────────────────────────────────────────────────────────────

module Dialog
  SERVER = 0
  LOGIN = 1
  REGISTER = 2
  ITEM_AMOUNT = 3
  TRADE_REQUEST = 4
  PARTY_INVITE = 5
  GUILD_CREATE = 6
  GUILD_INVITE = 7
  RESOLUTION = 101
end

class MUI_Dialog < MUI::Form
  @@id = Array.new
  
  def initialize(id, title, text, button=nil, textbox=nil, &block)
    @id, @title, @text, @button, @textbox = id, title, text, button, textbox
    @@id.include?(@id) ? return : @@id.push(@id)
    # 프록
    @proc = Thread.new do
      loop do
        sleep 0.05
        if @value != nil
          block.call
          break
        end
      end
    end
    
    # 사이즈
    case @id
    when Dialog::LOGIN
      super('center', 'center', 300, 150)
    else
      super('center', 'center', 300, 150)
    end
    
    # Label
    @lbl = MUI::Label.new(0, 0, 1, 1)
    @lbl.text = @text.to_s
    @lbl.color = Color.gray
    addControl(@lbl)
    @lbl.x = 0
    @lbl.y = 10
    @lbl.autoSize
    @lbl.width = self.width
    line = @lbl.baseSprite.bitmap.get_divided_text(@lbl.width, @text).size
    @lbl.height = line * @lbl.size + 2
    @lbl.align = 1
    
    formHeight = getTitleViewport.rect.height + @lbl.y + @lbl.height
    
    # TextBox
    if !@textbox.nil? and @textbox.size > 0
      @tb = Array.new
      gap = @lbl.size * 1.4
      width = @width - gap * 5
      height = @lbl.size * 1.5
      x = (@width - width) / 2
      @textbox.each_index do |i|
        y = formHeight - height
        y += i * (gap + 4)
        @tb[i] = MUI::TextBox.new(x, y, width, height)
        addControl(@tb[i])
      end
      formHeight += (@textbox.size) * height + gap
    end
    
  # Button
    if !@button.nil? and @button.size > 0
      @btn = Array.new
      gap = @lbl.size * 1.4
      width = @width - (gap * 2 + (@button.size - 1) * gap)
      width /= @button.size
      height = @lbl.size * 2
      y = formHeight - height
      @button.each_index do |i|
        x = gap + i * (width + gap)
        @btn[i] = MUI::Button.new(x, y, width, height)
        @btn[i].text = @button[i].to_s
        addControl(@btn[i])
      end
      formHeight += height + gap
    end
    
    self.height = formHeight
  end

  def refresh
    super
    setTitle(@title, 0)
  end

  def update
    super
    @button.each_index do |i|
      if @btn[i].click
        @value = i
      end
    end
  end
  
  def value; @value end
  def button; @btn end
  def textbox; @tb end
  
  def dispose
    super
    @@id.delete(@id) if @@id.include?(@id)
    @proc.kill
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ MUI_Inventory
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2014. 11. 16
# --------------------------------------------------------------------------
# Description
# 
#    유저의 소지품을 보여주는 폼 클래스입니다.
#────────────────────────────────────────────────────────────────────────────

class MUI_Inventory < MUI::Form
  def initialize
    @pic_item = []
    @horizontal = 5; @vertical = 7
    @num = @horizontal * @vertical
    super('center', 'center', 206, 320)
    @pic_window = MUI::PictureBox.new(20, 25, 166, 232) 
    @pic_window.picture = "Graphics/MUI/Inventory/" + "window_item.png"
    addControl(@pic_window)
    for i in 1..35
      @pic_item[i] = MUI::PictureBox.new(
      25 + ((i - 1) % @horizontal) * (33),
      30 + ((i - 1) / @horizontal) * (33), 34, 34)
      #if Game.player.getItem(i)
      #  @pic_item[i].picture = "Graphics/Icons/" + Game.getItem(Game.player.getItem(i).itemNo).image
      #end
      addControl(@pic_item[i])
    end
    
    @lbl_gold = MUI::Label.new(0, 5, 1, 1)
    @lbl_gold.color = Color.new(255, 170, 0)
    addControl(@lbl_gold)
    
    @pic_gold = MUI::PictureBox.new(0, 5, 14, 14)
    @pic_gold.picture = "Graphics/MUI/Inventory/" + "gold.png"
    addControl(@pic_gold)
    
    @lbl_num = []
    for n in 1..35
      @lbl_num[n] = MUI::Label.new(
      @pic_window.x + (n - 1) % @horizontal * 33,
      @pic_window.y + (n - 1) / @horizontal * 33 + 20, 32, 14)
      @lbl_num[n].color = Color.white
      @lbl_num[n].color2 = Color.black
      @lbl_num[n].align = 2
      @lbl_num[n].size -= 1
      #@lbl_num[n].text = Game.player.getItem(n).amount.to_s if Game.player.getItem(n)
      ##puts @lbl_num[n].text
      addControl(@lbl_num[n])
    end
    
    refreshData
  end

  def refresh
    super
    setTitle("소지품", 1)
  end
  
  def refreshData
    for i in 1..35
      @pic_item[i].clear
      @lbl_num[i].text = ""
      if Game.player.getItem(i)
        @pic_item[i].picture = "Graphics/Icons/" + Game.getItem(Game.player.getItem(i).itemNo).image
        @pic_item[i].opacity = Game.player.getItem(i).equipped ? 150 : 255
        @lbl_num[i].text = Game.player.getItem(i).amount.to_s
      end
    end
    @lbl_gold.text = Math.unitMoney(Game.player.gold.to_s)
    @lbl_gold.autoSize
    @lbl_gold.x = @pic_window.x + @pic_window.width - @lbl_gold.width
    @pic_gold.x = @lbl_gold.x - @pic_gold.width - 3
  end

  def update
    super
    if Mouse.trigger?
      if MUI.dragItem.is_a?(Item)
        for i in 1..35
          if @pic_item[i].isSelected
            next if Game.player.getItem(i) && Game.player.getItem(i).equipped
            Socket.send({'header' => CTSHeader::CHANGE_ITEM_INDEX, 'type' => 0, 
                        'index1' => MUI.dragItem.index, 'index2' => i})
            MUI.dragItem = nil
            return
          end
        end
        return if MUI.include?(MUI_Trade)
        if !isMouseOver
          index = MUI.dragItem.index
          dialog = MUI_Dialog.new(Dialog::ITEM_AMOUNT, "갯수 입력", "아이템 갯수를 입력하세요", ["확인", "취소"], ["갯수 입력"]) do
            if dialog.value == 0
              amount = dialog.textbox[0].text
              if amount != nil && amount != ""
                amount = amount.to_i
                Socket.send({'header' => CTSHeader::DROP_ITEM, 'index' => index, 
                            'amount' => amount}) if amount <= Game.player.getItem(index).amount
              end
              dialog.dispose
              MUI.dragItem = nil
            elsif dialog.value == 1
              dialog.dispose
              MUI.dragItem = nil
            end
          end
        end
        MUI.dragItem = nil
      else
        for i in 1..35
          if @pic_item[i].isSelected
            next if Game.player.getItem(i) && Game.player.getItem(i).equipped
            MUI.dragItem = Game.player.getItem(i)
            return
          end
        end
      end
    elsif Mouse.trigger?(1)
      for i in 1..35
        if @pic_item[i].isSelected
            Socket.send({'header' => CTSHeader::USE_ITEM, 'index' => i, 'amount' => 1})
            MUI.dragItem = nil
            return
        end
      end
    end
    for i in 1..35
      if @pic_item[i].isSelected && Game.player.getItem(i)
        MUI::ItemInfo.set(Game.player.getItem(i))
        return
      end
    end
    MUI::ItemInfo.clear
  end
  
  def dispose
    super
    MUI::ItemInfo.clear
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ MUI_Status
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2014. 11. 22
# --------------------------------------------------------------------------
# Description
# 
#    유저의 상태를 보여주는 폼 클래스입니다.
#────────────────────────────────────────────────────────────────────────────

class MUI_Status < MUI::Form
  def initialize
    @kind = []
    # TODO : getStatus 방식 수정 요망
    (0..5).each { |i| @kind[i] = Game.getStatus(i + 3)}
    @data = [Game.player.str, Game.player.dex, Game.player.agi, 
            Game.player.critical, Game.player.hit, Game.player.avoid]
    @old = {}
    @old['hp'] = 0
    @old['mp'] = 0
    @old['exp'] = 0
    super('center', 100, 292, 250)
    @drag = true
    # 베이스
    @pic_base = MUI::PictureBox.new(20, 20, 252, 170)
    @pic_base.picture = "Graphics/MUI/Status/" + "window_base.png"
    addControl(@pic_base)
    # 캐릭터
    @pic_char = MUI::PictureBox.new(0, 0, 1, 1)
    addControl(@pic_char)
    # 레벨
    @lbl_level = MUI::Label.new(99+25, 26, 34, 14)
    @lbl_level.size = 12
    @lbl_level.align = 1
    @lbl_level.color = Color.system
    addControl(@lbl_level)
    # 포인트량
    @lbl_point = MUI::Label.new(191, 26, 30, 14)
    @lbl_point.size = 12
    @lbl_point.align = 1
    @lbl_point.color = Color.system
    addControl(@lbl_point)
    # 장비
    @pic_weapon = MUI::PictureBox.new(28, 161, 24, 24)
    @pic_shield = MUI::PictureBox.new(28 + 33 * 1, 161, 24, 24)
    @pic_helmet = MUI::PictureBox.new(41 + 33 * 2, 161, 24, 24)
    @pic_armor = MUI::PictureBox.new(41 + 33 * 3, 161, 24, 24)
    @pic_cape = MUI::PictureBox.new(41 + 33 * 4, 161, 24, 24)
    @pic_shoes = MUI::PictureBox.new(41 + 33 * 5, 161, 24, 24)
    @pic_accessory = MUI::PictureBox.new(41 + 33 * 6, 161, 24, 24)
    addControl(@pic_weapon)
    addControl(@pic_shield)
    addControl(@pic_helmet)
    addControl(@pic_armor)
    addControl(@pic_cape)
    addControl(@pic_shoes)
    addControl(@pic_accessory)
    
    # 능력치
    # 종류별 이름
    @lbl_kind = []
    @kind.each_index do |i|
      x = i >= 3 ? 170 : 26
      y = (i >= 3 ? 29 : 92) + 21 * i
      @lbl_kind[i] = MUI::Label.new(x, y, 1, 1)
      @lbl_kind[i].text = @kind[i]
      @lbl_kind[i].color = Color.gray
      addControl(@lbl_kind[i])
      @lbl_kind[i].autoSize
    end
    
    # 값
    @lbl_value = []
    @data.each_index do |i|
      x = i >= 3 ? 234 : 90
      y = (i >= 3 ? 29 : 92) + 21 * i
      @lbl_value[i] = MUI::Label.new(x, y, 32, 14)
      @lbl_value[i].color = Color.system
      @lbl_value[i].align = 2
      addControl(@lbl_value[i])
    end
    
    # 게이지바
    @pic_bar_hp = MUI::PictureBox.new(96, 44, 170, 8)
    @pic_bar_mp = MUI::PictureBox.new(96, 56, 170, 8)
    @pic_bar_exp = MUI::PictureBox.new(96, 68, 170, 8)
    @pic_bar_hp.picture = "Graphics/MUI/Status/" + "bar_hp.png"
    @pic_bar_mp.picture = "Graphics/MUI/Status/" + "bar_mp.png"
    @pic_bar_exp.picture = "Graphics/MUI/Status/" + "bar_exp.png"
    addControl(@pic_bar_hp)
    addControl(@pic_bar_mp)
    addControl(@pic_bar_exp)
    
    # 포인트
    # -
    @pic_minus = MUI::PictureBox.new(225, 24, 21, 16)
    @pic_minus.picture = "Graphics/MUI/Status/" + "-.png"
    addControl(@pic_minus)
    
    # +
    @pic_plus = MUI::PictureBox.new(245, 24, 21, 16)
    @pic_plus.picture = "Graphics/MUI/Status/" + "+.png"
    addControl(@pic_plus)
    refreshData
  end

  def refresh
    super
    # 이름 (직업)
    setTitle("#{Game.player.name} (#{Game.getJob(Game.player.job)})", 1)
    if @controls.size > 2
      refreshData
    end
  end
  
  def refreshData
    icon = "Graphics/Icons/"
    @pic_weapon.picture = Game.player.weapon > 0 ? icon + Game.getItem(Game.player.getItem(Game.player.weapon).itemNo).image : ""
    @pic_shield.picture = Game.player.shield > 0 ? icon + Game.getItem(Game.player.getItem(Game.player.shield).itemNo).image : ""
    @pic_helmet.picture = Game.player.helmet > 0 ? icon + Game.getItem(Game.player.getItem(Game.player.helmet).itemNo).image : ""
    @pic_armor.picture = Game.player.armor > 0 ? icon + Game.getItem(Game.player.getItem(Game.player.armor).itemNo).image : ""
    @pic_cape.picture = Game.player.cape > 0 ? icon + Game.getItem(Game.player.getItem(Game.player.cape).itemNo).image : ""
    @pic_shoes.picture = Game.player.shoes > 0 ? icon + Game.getItem(Game.player.getItem(Game.player.shoes).itemNo).image : ""
    @pic_accessory.picture = Game.player.accessory > 0 ? icon + Game.getItem(Game.player.getItem(Game.player.accessory).itemNo).image : ""
    @lbl_level.text = Game.player.level.to_s
    @lbl_point.text = Game.player.statPoint.to_s
    @data[0] = Game.player.str
    @data[1] = Game.player.dex
    @data[2] = Game.player.agi
    @data[3] = Game.player.critical
    @data[4] = Game.player.hit
    @data[5] = Game.player.avoid
    @pic_char.picture = "Graphics/Characters/" + Game.player.image
    @pic_char.width = @pic_char.picture.width / 4
    @pic_char.height = @pic_char.picture.height / 4
    @pic_char.x = 20 + (64 - @pic_char.picture.width / 4) / 2
    @pic_char.y = 20 + (64 - @pic_char.picture.height / 4) / 2
    @data.each_index do |i|
      @lbl_value[i].text = @data[i].to_s
    end
  end

  def update
    super
    drawGaugeBar
    @pic_minus.picture = "Graphics/MUI/Status/" + (@pic_minus.isSelected ? "-2.png" : "-.png")
    @pic_plus.picture = "Graphics/MUI/Status/" + (@pic_plus.isSelected ? "+2.png" : "+.png")
    
    if Mouse.trigger?
      @selectOtherArea = true
      for i in 0...@data.size
        if not @lbl_kind[i].isSelected
          @lbl_kind[i].color = Color.gray
        end
        if @lbl_kind[i].click
          @index = i
          @lbl_kind[@index].color = Color.red
          @selectOtherArea = false
        end
      end
    elsif Mouse.trigger?(1)
      if @pic_weapon.click(1)
        if Game.player.weapon > 0
          Socket.send({'header' => CTSHeader::REMOVE_EQUIP_ITEM, 'type' => Game::ItemType::WEAPON})
          refreshData
        end
      elsif @pic_shield.click(1)
        if Game.player.shield > 0
          Socket.send({'header' => CTSHeader::REMOVE_EQUIP_ITEM, 'type' => Game::ItemType::SHIELD})
          refreshData
        end
      elsif @pic_helmet.click(1)
        if Game.player.helmet > 0
          Socket.send({'header' => CTSHeader::REMOVE_EQUIP_ITEM, 'type' => Game::ItemType::HELMET})
          refreshData
        end
      elsif @pic_armor.click(1)
        if Game.player.armor > 0
          Socket.send({'header' => CTSHeader::REMOVE_EQUIP_ITEM, 'type' => Game::ItemType::ARMOR})
          refreshData
        end
      elsif @pic_cape.click(1)
        if Game.player.cape > 0
          Socket.send({'header' => CTSHeader::REMOVE_EQUIP_ITEM, 'type' => Game::ItemType::CAPE})
          refreshData
        end
      elsif @pic_shoes.click(1)
        if Game.player.shoes > 0
          Socket.send({'header' => CTSHeader::REMOVE_EQUIP_ITEM, 'type' => Game::ItemType::SHOES})
          refreshData
        end
      elsif @pic_accessory.click(1)
        if Game.player.accessory > 0
          Socket.send({'header' => CTSHeader::REMOVE_EQUIP_ITEM, 'type' => Game::ItemType::ACCESSORY})
          refreshData
        end
      end
    else
      item = nil
      if @pic_weapon.isSelected
        item = Game.player.getItem(Game.player.weapon) if Game.player.weapon > 0
      elsif @pic_shield.isSelected
        item = Game.player.getItem(Game.player.shield) if Game.player.shield > 0
      elsif @pic_helmet.isSelected
        item = Game.player.getItem(Game.player.helmet) if Game.player.helmet > 0
      elsif @pic_armor.isSelected
        item = Game.player.getItem(Game.player.armor) if Game.player.armor > 0
      elsif @pic_cape.isSelected
        item = Game.player.getItem(Game.player.cape) if Game.player.cape > 0
      elsif @pic_shoes.isSelected
        item = Game.player.getItem(Game.player.shoes) if Game.player.shoes > 0
      elsif @pic_accessory.isSelected
        item = Game.player.getItem(Game.player.accessory) if Game.player.accessory > 0
      end
      item == nil ? MUI::ItemInfo.clear : MUI::ItemInfo.set(item)
    end

    # 포인트
    if Game.player.statPoint > 0 && @index
      if @pic_plus.click
        Socket.send({'header' => CTSHeader::USE_STAT_POINT, 'type' => @index + 3})
        @selectOtherArea = false
        @lbl_kind[@index].color = Color.red
        return
      elsif @pic_minus.click
        
      end
    end
    
    @index = nil if @selectOtherArea
  end
  
  def drawGaugeBar
    if @old['hp'] != Game.player.hp
      @pic_bar_hp.width = Game.player.hp == 0 ? 1 : @pic_bar_hp.picture.width * Game.player.hp / Game.player.maxHp
      @old['hp'] = Game.player.hp
    end
    if @old['mp'] != Game.player.mp
      @pic_bar_mp.width = Game.player.mp == 0 ? 1 : @pic_bar_mp.picture.width * Game.player.mp / Game.player.maxMp
      @old['mp'] = Game.player.mp
    end
    if @old['exp'] != Game.player.exp
      @pic_bar_exp.width = Game.player.exp == 0 ? 1 : @pic_bar_exp.picture.width * Game.player.exp / Game.player.maxExp
      @old['exp'] = Game.player.exp
    end
  end
  
  def dispose
    super
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ MUI_Skill
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2015. 02. 01
# --------------------------------------------------------------------------
# Description
#
#    유저의 기술을 보여주는 폼 클래스입니다. 
#────────────────────────────────────────────────────────────────────────────

class MUI_Skill < MUI::Form
  def initialize
    super('center', 'center', 300, 220)
    @pic_window = MUI::PictureBox.new(24, 30, 251, 133) 
    @pic_window.picture = "Graphics/MUI/Skill/" + "window.png"
    addControl(@pic_window)
    
    @pic_point = MUI::PictureBox.new(@pic_window.x + @pic_window.width - 16, 6, 16, 16) 
    @pic_point.picture = "Graphics/MUI/Skill/" + "point.png"
    addControl(@pic_point)
    
    @lbl_point = MUI::Label.new(@pic_window.x, 6, @pic_window.width - 20, 14)
    @lbl_point.text = Math.unitMoney(Game.player.skillPoint)
    @lbl_point.align = 2
    @lbl_point.color = Color.system
    addControl(@lbl_point)
    
    @skill_data = []
    @pic_icon = []; @pic_plus = []; @lbl_rank = []
    for i in 1..20
    # Icon
      @pic_icon[i] = MUI::PictureBox.new(
      @pic_window.x + 5 + ((i - 1) % 5) * (50),
      @pic_window.y + 5 + ((i - 1) / 5) * (33), 32, 32)
      addControl(@pic_icon[i])
    # +
      @pic_plus[i] = MUI::PictureBox.new(
      58 + ((i - 1) % 5) * (50),
      30 + ((i - 1) / 5) * (33), 16, 16) 
      @pic_plus[i].picture = "Graphics/MUI/Skill/" + "+.png"
      addControl(@pic_plus[i])
    # Lv
      @lbl_rank[i] = MUI::Label.new(
      58 + ((i - 1) % 5) * (50),
      47 + ((i - 1) / 5) * (33), 16, 16) 
      @lbl_rank[i].align = 1
      @lbl_rank[i].size -= 2
      addControl(@lbl_rank[i])
    end
    refreshData
  end
  
  def refresh
    super
    setTitle("기술")
  end
  
  def refreshData
    n = 1
    for skill in Game.player.getSkillList.values
      @pic_icon[n].picture = RPG::Cache.icon(Game.getSkill(skill.no).image)
      @lbl_rank[n].text = skill.rank.to_s
      @skill_data[n] = skill.no
      n += 1
    end
  end
  
  def update
    super
    for i in 1..20
      if @pic_icon[i].click(0)
        MUI.dragItem = Game.player.getSkill(i)
      end
    end
    for i in 1..20
      if @pic_icon[i].isSelected && Game.player.getSkill(i)
        MUI::SkillInfo.set(Game.player.getSkill(i))
        return
      end
    end
    MUI::SkillInfo.clear
    opSelect
  end
  
  def opSelect
    if not @op.nil?
      if @pic_plus[@op].isSelected
        @pic_plus[@op].picture = "Graphics/MUI/Skill/+2.png"
        if @pic_plus[@op].click
          p "plus : #{@op}"
        end
      else
        @pic_plus[@op].picture = "Graphics/MUI/Skill/+.png"
      end
    end
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ MUI_Option
# --------------------------------------------------------------------------
# Author    jubin
# Date      2016. 01. 11
# --------------------------------------------------------------------------
# Description
# 
#    게임의 환경설정을 도와주는 폼 클래스입니다.
#    옵션값은 Config::OPTION_PATH 경로에 저장됩니다.
#────────────────────────────────────────────────────────────────────────────

class MUI_Option < MUI::Form
  def initialize
    super('center', 'center', 250, 200)
    # 레이블
    @lbl = {}
    # BGM
    @lbl[:bgm] = MUI::Label.new(35, 24, 1, 1)
    @lbl[:bgm].text = "BGM"
    @lbl[:bgm].color = Color.gray
    addControl(@lbl[:bgm])
    @lbl[:bgm].autoSize
    # BGS
    @lbl[:bgs] = MUI::Label.new(35, 24+25, 1, 1)
    @lbl[:bgs].text = "BGS"
    @lbl[:bgs].color = Color.gray
    addControl(@lbl[:bgs])
    @lbl[:bgs].autoSize
    # ME
    @lbl[:me] = MUI::Label.new(35, 24+50, 1, 1)
    @lbl[:me].text = "ME"
    @lbl[:me].color = Color.gray
    addControl(@lbl[:me])
    @lbl[:me].autoSize
    # SE
    @lbl[:se] = MUI::Label.new(35, 24+75, 1, 1)
    @lbl[:se].text = "SE"
    @lbl[:se].color = Color.gray
    addControl(@lbl[:se])
    @lbl[:se].autoSize
    # 풀스크린
    @lbl[:fullscreen] = MUI::Label.new(35, 74+50, 1, 1)
    @lbl[:fullscreen].text = "풀스크린"
    @lbl[:fullscreen].color = Color.gray
    addControl(@lbl[:fullscreen])
    @lbl[:fullscreen].autoSize
    # on
    @lbl[:fullscreen_on] = MUI::Label.new(110, 75+50, 1, 1)
    @lbl[:fullscreen_on].text = "On"
    @lbl[:fullscreen_on].color = Color.gray
    addControl(@lbl[:fullscreen_on])
    @lbl[:fullscreen_on].autoSize
    # off
    @lbl[:fullscreen_off] = MUI::Label.new(170, 75+50, 1, 1)
    @lbl[:fullscreen_off].text = "Off"
    @lbl[:fullscreen_off].color = Color.gray
    addControl(@lbl[:fullscreen_off])
    @lbl[:fullscreen_off].autoSize
    
    # 수평 스크롤바
    @hs = {}
    # BGM
    @hs[:bgm] = MUI::HScroll.new(@lbl[:bgm].x + 55, @lbl[:bgm].y+1, 120, 13)
    @hs[:bgm].max, @hs[:bgm].min = 100, 0
    @hs[:bgm].value = Game.system.bgm_load
    addControl(@hs[:bgm])
    # BGS
    @hs[:bgs] = MUI::HScroll.new(@lbl[:bgs].x + 55, @lbl[:bgs].y+1, 120, 13)
    @hs[:bgs].max, @hs[:bgs].min = 100, 0
    @hs[:bgs].value = Game.system.bgs_load
    addControl(@hs[:bgs])
    # ME
    @hs[:me] = MUI::HScroll.new(@lbl[:me].x + 55, @lbl[:me].y+1, 120, 13)
    @hs[:me].max, @hs[:me].min = 100, 0
    @hs[:me].value = Game.system.me_load
    addControl(@hs[:me])
    # SE
    @hs[:se] = MUI::HScroll.new(@lbl[:se].x + 55, @lbl[:se].y+1, 120, 13)
    @hs[:se].max, @hs[:se].min = 100, 0
    @hs[:se].value = Game.system.se_load
    addControl(@hs[:se])
    
    # 라디오 박스
    @rb = {}
    # 풀스크린 on
    @rb[:fullscreen_on] = MUI::RadioBox.new(@lbl[:fullscreen].x + 55, @lbl[:fullscreen].y+1, 14, 14)
    addControl(@rb[:fullscreen_on])
    # 풀스크린 off
    @rb[:fullscreen_off] = MUI::RadioBox.new(@rb[:fullscreen_on].x + 60, @lbl[:fullscreen].y+1, 14, 14)
    addControl(@rb[:fullscreen_off])
    # 그룹화
    @rb[:fullscreen_off].group = @rb[:fullscreen_on].group = 'fullscreen'
    if Game.system.fullscreen_load
      @rb[:fullscreen_on].value = true
    else
      @rb[:fullscreen_off].value = true
    end
  end
  
  def refresh
    super
    setTitle("옵션")
  end
  
  def update
    super
    @hs[:bgm].toolTip = @hs[:bgm].value.to_i.to_s if @hs[:bgm].isSelected
    @hs[:bgs].toolTip = @hs[:bgs].value.to_i.to_s if @hs[:bgs].isSelected
    @hs[:me].toolTip = @hs[:me].value.to_i.to_s if @hs[:me].isSelected
    @hs[:se].toolTip = @hs[:se].value.to_i.to_s if @hs[:se].isSelected
    if @bgm != @hs[:bgm].value.to_i
      Game.system.bgm_save(@hs[:bgm].value.to_i)
      @bgm = @hs[:bgm].value.to_i
    end
    if @bgs != @hs[:bgs].value.to_i
      Game.system.bgs_save(@hs[:bgs].value.to_i)
      @bgs = @hs[:bgs].value.to_i
    end
    if @me != @hs[:me].value.to_i
      Game.system.me_save(@hs[:me].value.to_i)
      @me = @hs[:me].value.to_i
    end
    if @se != @hs[:se].value.to_i
      Game.system.se_save(@hs[:se].value.to_i)
      @se = @hs[:se].value.to_i
    end
    
    if @rb[:fullscreen_on].click && @rb[:fullscreen_on].value
      if not Graphics.isFullScreen
        b = Graphics.resize_screen2(Graphics.width, Graphics.height, true)
        Game.system.fullscreen_save(b)
        if b
          @rb[:fullscreen_on].value = true
        else
          @rb[:fullscreen_off].value = true
        end
      end
    elsif @rb[:fullscreen_off].click && @rb[:fullscreen_off].value
      if Graphics.isFullScreen
        b = Graphics.resize_screen2(Graphics.width, Graphics.height)
        Game.system.fullscreen_save(b)
        if b
          @rb[:fullscreen_on].value = true
        else
          @rb[:fullscreen_off].value = true
        end
      end
    end
  end
  
  def updateData
    
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ MUI_Message
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2015. 1. 25
# --------------------------------------------------------------------------
# Description
#
#    NPC 와의 대화상자를 띄우는 폼 클래스입니다. 
#────────────────────────────────────────────────────────────────────────────

class MUI_Message < MUI::Form
  def initialize(no)
    super(48, 350, Graphics.getRect[0] - 200, 200)
    self.style = "Black"
    self.opacity /= 1.1
    @msg = File.open("./GameData/npc/" + "#{no}.txt").readlines
    for i in 0...@msg.size
      msg = @msg[i].to_u
      @msg[i] = msg
    end
    # 드래그, 닫기 비허용
    @drag = @close = false
    @lbl_text = MUI::Label.new(24, 24, 50, 50)
    @lbl_text.text = ""
    @lbl_text.size = 20
    @lbl_text.color = Color.white
    addControl(@lbl_text)
    @btn = MUI::Button.new(24, 120, 96, 32)
    @btn.style = "Black"
    @btn.text = "닫기"
    addControl(@btn)
    @lbl_selects = []
    drawFace
  end
  
  def set(line, selects)
    text = ""
    for i in 1...5
      text += @msg[line + i]
    end
    for label in @lbl_selects
      label.dispose
    end
    @btn.visible = true
    case selects
    when -1
      @btn.text = "닫기"
    when 0
      @btn.text = "다음"
    else
      for i in 0...selects
        @lbl_selects[i] = MUI::Label.new(24, 24, 50, 50)
        @lbl_selects[i].text = @msg[line + 4 - i].gsub("\n", "")
        @lbl_selects[i].size = 20
        @lbl_selects[i].color = Color.yellow
        addControl(@lbl_selects[i])
        @lbl_selects[i].y = 120 - i * 20
        @lbl_selects[i].autoSize
      end
      text = ""
      for i in 1...(5 - selects)
        text += @msg[line + i]
      end
      @btn.visible = false
    end
    @lbl_text.text = text
    @lbl_text.autoSize
    setTitle(@msg[line], 0)
  end
  
  def refresh
    super
    setTitle("대화", 0)
  end
  
  def drawFace
    @bitmap = Bitmap.new("Graphics/Pictures/togi.png")
    @sprite = Sprite.new
    @sprite.z = 999999
    @sprite.x = Graphics.getRect[0] - @bitmap.width
    @sprite.y = Graphics.getRect[1] - @bitmap.height
    @sprite.bitmap = @bitmap
  end
  
  def update
    super
    if Mouse.trigger?
      if @btn.click
        Socket.send({'header' => CTSHeader::SELECT_MESSAGE, 'select' => 0})
      end
      for i in 0...@lbl_selects.size
        if @lbl_selects[i].click
          Socket.send({'header' => CTSHeader::SELECT_MESSAGE, 'select' => i})
        end
      end
    end
    for select in @lbl_selects
      select.color = select.isSelected ? Color.red : Color.yellow
    end
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ MUI_Trade
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2015. 2. 20
# --------------------------------------------------------------------------
# Description
# 
#    상대방과 거래를 하는 폼 클래스입니다.
#────────────────────────────────────────────────────────────────────────────

class MUI_Trade < MUI::Form
  attr_reader :user
  
  def initialize(user)
    super('center', 'center', 285, 280)
    self.close = false
    # [0]:me, [1]:partner
    @user = user
    @myStatus = 0
    @partnerStatus = 0
    @myItem = {}
    @partnerItem = {}
    
    @pic_window = []
    @pic_window[0] = MUI::PictureBox.new(24, 60, 100, 124) 
    @pic_window[0].picture = "Graphics/MUI/Trade/" + "window.png"
    addControl(@pic_window[0])

    @pic_window[1] = MUI::PictureBox.new(160, 60, 100, 124) 
    @pic_window[1].picture = "Graphics/MUI/Trade/" + "window.png"
    addControl(@pic_window[1])
    
    @lbl_name = []
    @lbl_name[0] = MUI::Label.new(24, 42, 100, 14)
    @lbl_name[0].text = Game.player.name
    @lbl_name[0].color = Color.system
    @lbl_name[0].align = 1
    addControl(@lbl_name[0])
    
    @lbl_name[1] = MUI::Label.new(160, 42, 100, 14)
    @lbl_name[1].text = @user.name
    @lbl_name[1].color = Color.system
    @lbl_name[1].align = 1
    addControl(@lbl_name[1])
    
    @lbl_gold = []
    @lbl_gold[0] = MUI::Label.new(24, 166, 95, 20)
    @lbl_gold[0].text = Math.unitMoney("0")
    @lbl_gold[0].align = 2
    addControl(@lbl_gold[0])
    
    @lbl_gold[1] = MUI::Label.new(160, 166, 95, 20)
    @lbl_gold[1].text = Math.unitMoney("0")
    @lbl_gold[1].align = 2
    addControl(@lbl_gold[1])
    
    @pic_gold = []
    @pic_gold[0] = MUI::PictureBox.new(27, 167, 14, 14)
    @pic_gold[0].picture = "Graphics/MUI/Trade/gold.png"
    addControl(@pic_gold[0])
    @pic_gold[1] = MUI::PictureBox.new(163, 167, 14, 14)
    @pic_gold[1].picture = "Graphics/MUI/Trade/gold.png"
    addControl(@pic_gold[1])
    
    @pic_state = []
    @pic_state[0] = MUI::PictureBox.new(62, 13, 24, 24)
    @pic_state[0].picture = "Graphics/MUI/Trade/wait.png"
    addControl(@pic_state[0])
    @pic_state[1] = MUI::PictureBox.new(197, 14, 24, 24)
    @pic_state[1].picture = "Graphics/MUI/Trade/wait.png"
    addControl(@pic_state[1])
    
    @pic_icon = []
    @pic_icon[0] = []
    @pic_icon[1] = []
    for i in 1..9
      @pic_icon[0][i] = MUI::PictureBox.new(
      @pic_window[0].x + 5 + ((i - 1) % 3) * (33),
      @pic_window[0].y + 5 + ((i - 1) / 3) * (33), 32, 32)
      addControl(@pic_icon[0][i])
      
      @pic_icon[1][i] = MUI::PictureBox.new(
      @pic_window[1].x + 5 + ((i - 1) % 3) * (33),
      @pic_window[1].y + 5 + ((i - 1) / 3) * (33), 32, 32)
      addControl(@pic_icon[1][i])
    end
    
    @lbl_num = []
    @lbl_num[0] = []
    @lbl_num[1] = []
    for n in 1..9
      @lbl_num[0][n] = MUI::Label.new(
      @pic_window[0].x + ((n - 1) % 3) * (33),
      @pic_window[0].y + ((n - 1) / 3) * (33) + 20, 32, 14)
      @lbl_num[0][n].color = Color.white
      @lbl_num[0][n].color2 = Color.black
      @lbl_num[0][n].align = 2
      @lbl_num[0][n].size -= 1
      addControl(@lbl_num[0][n])
      
      @lbl_num[1][n] = MUI::Label.new(
      @pic_window[1].x + ((n - 1) % 3) * (33),
      @pic_window[1].y + ((n - 1) / 3) * (33) + 20, 32, 14)
      @lbl_num[1][n].color = Color.white
      @lbl_num[1][n].color2 = Color.black
      @lbl_num[1][n].align = 2
      @lbl_num[1][n].size -= 1
      addControl(@lbl_num[1][n])
    end
    
    @btn = MUI::Button.new(25, 194, 234, 30)
    @btn.style = "Black"
    @btn.text = "거래 준비"
    addControl(@btn)
    
    refreshData
  end
  
  def addMyItem(index, item)
    @myItem[index] = item
    refreshData
  end
  
  def removeMyItem(index)
    return if not @myItem.has_key?(index)
    @myItem.delete(index)
    refreshData
  end
  
  def addPartnerItem(index, item)
    @partnerItem[index] = item
    refreshData
  end
  
  def removePartnerItem(index)
    return if not @partnerItem.has_key?(index)
    @partnerItem.delete(index)
    refreshData
  end
  
  def setGold(no, amount)
    @lbl_gold[no == Game.player.no ? 0 : 1].text = Math.unitMoney(amount.to_s)
  end
  
  def acceptTrade(no)
    if no == Game.player.no
      @pic_state[0].picture = "Graphics/MUI/Trade/accept.png"
      @myStatus = 1
    else
      @pic_state[1].picture = "Graphics/MUI/Trade/accept.png"
      @partnerStatus = 1
    end
    if isFinish
      dispose
    end
  end
  
  def isFinish
    return (@myStatus == @partnerStatus && @myStatus == 1) ? true : false
  end
  
  def refreshData
    for i in 1..9
      @pic_icon[0][i].clear
      @pic_icon[1][i].clear
      @lbl_num[0][i].text = ""
      @lbl_num[1][i].text = ""
      if @myItem.has_key?(i)
        @pic_icon[0][i].picture = "Graphics/Icons/" + Game.getItem(@myItem[i].itemNo).image
        @lbl_num[0][i].text = @myItem[i].amount.to_s
      end
      if @partnerItem.has_key?(i)
        @pic_icon[1][i].picture = "Graphics/Icons/" + Game.getItem(@partnerItem[i].itemNo).image
        @lbl_num[1][i].text = @partnerItem[i].amount.to_s
      end
    end
  end
  
  def refresh
    super
    setTitle("거래")
  end
  
  def update
    super
    if @btn.click
      Socket.send({'header' => CTSHeader::FINISH_TRADE})
    elsif @lbl_gold[0].click
      dialog = MUI_Dialog.new(Dialog::ITEM_AMOUNT, "액수 입력", "원하는 액수를 입력하세요.", ["확인", "취소"], ["액수 입력"]) do
        if dialog.value == 0
          amount = dialog.textbox[0].text
          if amount != nil && amount != ""
            amount = amount.to_i
            Socket.send({'header' => CTSHeader::CHANGE_TRADE_GOLD, 'amount' => amount})
          end
          dialog.dispose
        elsif dialog.value == 1
          dialog.dispose
        end
      end
    end
    if Mouse.trigger?
      return if not MUI.dragItem.is_a?(Item)
      for i in 1..9
        if @pic_icon[0][i].isSelected
          index = MUI.dragItem.index
          tradeIndex = i
          dialog = MUI_Dialog.new(Dialog::ITEM_AMOUNT, "갯수 입력", "아이템 갯수를 입력하세요.", ["확인", "취소"], ["갯수 입력"]) do
            if dialog.value == 0
              amount = dialog.textbox[0].text
              if amount != nil && amount != ""
                amount = amount.to_i
                Socket.send({'header' => CTSHeader::LOAD_TRADE_ITEM, 'index' => index, 'tradeIndex' => tradeIndex,
                            'amount' => amount}) if amount <= Game.player.getItem(index).amount
              end
              dialog.dispose
              MUI.dragItem = nil
            elsif dialog.value == 1
              dialog.dispose
              MUI.dragItem = nil
            end
          end
        end
      end
      MUI.dragItem = nil
    elsif Mouse.trigger?(1)
      for i in 1..9
        if @pic_icon[0][i].isSelected
          Socket.send({'header' => CTSHeader::DROP_TRADE_ITEM, 'index' => i})
        end
      end
    else
      for i in 1..9
        if @pic_icon[0][i].isSelected && @myItem.has_key?(i)
          MUI::ItemInfo.set(@myItem[i])
          return
        elsif @pic_icon[1][i].isSelected && @partnerItem.has_key?(i)
          MUI::ItemInfo.set(@partnerItem[i])
          return
        end
      end
    end
    MUI::ItemInfo.clear
  end
  
  def dispose
    super
    Socket.send({'header' => CTSHeader::CANCEL_TRADE}) if !isFinish
    MUI::ItemInfo.clear
  end
end

#────────────────────────────────────────────────────────────────────────────
# ▶ MUI_Shop
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2015. 2. 16
# --------------------------------------------------------------------------
# Description
# 
#    아이템을 사고 파는 상점 폼 클래스입니다.
#────────────────────────────────────────────────────────────────────────────

class MUI_Shop < MUI::Form
  def initialize
    # 인벤토리 실행
    MUI_Inventory.new unless MUI.include?(MUI_Inventory)
    super('center', 'center', 230, 260)
    @pic_window = MUI::PictureBox.new(32, 32, 166, 166)
    @pic_window.picture = "./Graphics/MUI/Shop/" + "Window.png"
    addControl(@pic_window)
    @pic_item = []
    for n in 1..25
      @pic_item[n] = MUI::PictureBox.new(
      @pic_window.x + 5 + ((n - 1) % 5) * (33),
      @pic_window.y + 5 + ((n - 1) / 5) * (33), 32, 32)
      addControl(@pic_item[n])
    end
    refreshData
  end
  
  def refresh
    super
    setTitle("상점")
  end
  
  def refreshData
    # 상점 아이템 아이콘
    for i in 1..25
      @pic_item[i].clear
      if Game.player.getShopItem(i)
        @pic_item[i].picture = "./Graphics/Icons/" + Game.getItem(Game.player.getShopItem(i).itemNo).image
      end
    end
  end
  
  def update
    super
    if Mouse.trigger?
      for i in 1..25
        if @pic_item[i].isSelected && Game.player.getShopItem(i)
          index = i
          dialog = MUI_Dialog.new(Dialog::ITEM_AMOUNT, "갯수 입력", "아이템 갯수를 입력하세요.", ["확인", "취소"], ["갯수 입력"]) do
            if dialog.value == 0
              amount = dialog.textbox[0].text
              if amount != nil && amount != ""
                amount = amount.to_i
                Socket.send({'header' => CTSHeader::BUY_SHOP_ITEM, 'shopNo' => Game.player.shopNo, 'index' => index,
                            'amount' => amount}) if amount > 0
              end
              dialog.dispose
            elsif dialog.value == 1
              dialog.dispose
            end
          end
        end
      end
    end
    for i in 1..25
      if @pic_item[i].isSelected && Game.player.getShopItem(i)
        MUI::ItemInfo.set(Game.player.getShopItem(i))
        return
      end
    end
    MUI::ItemInfo.clear
  end
  
  def dispose
    super
    MUI::ItemInfo.clear
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ MUI_Community
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2015. 2. 17
# --------------------------------------------------------------------------
# Description
# 
#    유저에게 등록되어 있는 다른 유저들을 관리하는 폼입니다.
#────────────────────────────────────────────────────────────────────────────

class MUI_Community < MUI::Form
  def initialize
    @btn = {}
    super('center', 'center', 214, 287)
    # 탭페이지
    @tab = MUI::TabPage.new(2, 0, @width - 4, 32)
    @tab.item = ["파티", "길드", "친구"]
    addControl(@tab)
    # 유저 리스트
    @pic_user_list = []
    @pic_user_image = []
    @lbl_user_info = []
    @btn_user_delete = []
    for i in 0...4
      @pic_user_list[i] = MUI::PictureBox.new(7, 39 + 46 * i, 200, 40)
      @pic_user_list[i].picture = "Graphics/MUI/Community/" + "item_win.png"
      @pic_user_list[i].visible = false
      addControl(@pic_user_list[i])
      @pic_user_image[i] = MUI::PictureBox.new(11, 43 + 46 * i, 32, 32)
      addControl(@pic_user_image[i])
      @lbl_user_info[i] = MUI::Label.new(46, 43 + 46 * i, 162, 14)
      addControl(@lbl_user_info[i])
      @btn_user_delete[i] = MUI::Button.new(171, 42 + 46 * i, 34, 34)
      @btn_user_delete[i].text = "X"
      @btn_user_delete[i].visible = false
      addControl(@btn_user_delete[i])
    end
    ## 페이지
    @page = 0
    # 파티
    @btn_party_create = MUI::Button.new(8, 222, 50, 24)
    @btn_party_create.text = "생성"
    @tab.tab[0].addControl(@btn_party_create)
    @btn_party_quit = MUI::Button.new(156, 222, 50, 24)
    @btn_party_quit.text = "탈퇴"
    @tab.tab[0].addControl(@btn_party_quit)
    # 길드
    @lbl_guild_page = MUI::Label.new(0, 226, @width, 14)
    @lbl_guild_page.align = 1
    @tab.tab[1].addControl(@lbl_guild_page)
    @btn_guild_page_left = MUI::Button.new(8, 222, 24, 24)
    @btn_guild_page_left.text = "◀"
    @tab.tab[1].addControl(@btn_guild_page_left)
    @btn_guild_page_right = MUI::Button.new(182, 222, 24, 24)
    @btn_guild_page_right.text = "▶"
    @tab.tab[1].addControl(@btn_guild_page_right)
    # 친구
    @lbl_friend_page = MUI::Label.new(0, 226, @width, 14)
    @lbl_friend_page.align = 1
    @tab.tab[2].addControl(@lbl_friend_page)
    @btn_friend_page_left = MUI::Button.new(8, 222, 24, 24)
    @btn_friend_page_left.text = "◀"
    @tab.tab[2].addControl(@btn_friend_page_left)
    @btn_friend_page_right = MUI::Button.new(182, 222, 24, 24)
    @btn_friend_page_right.text = "▶"
    @tab.tab[2].addControl(@btn_friend_page_right)
    @tab.set
    refreshData
  end
  
  def refreshData
    case @tab.page
    when 0
      @user_list = Game.player.party_member
    when 1
      @user_list = Game.player.guild_member
      @lbl_guild_page.text = (@page + 1).to_s + " / " +((@user_list.size - 1) / 4 + 1).to_s
    when 2
      @user_list = Game.player.friend
      @lbl_friend_page.text = (@page + 1).to_s + " / " +((@user_list.size - 1) / 4 + 1).to_s
    end
    for i in (@page * 4)...(@page * 4 + 4)
      user = @user_list[i]
      index = i - @page * 4
      @pic_user_list[index].visible = false
      @pic_user_image[index].clear
      @lbl_user_info[index].text = ""
      @btn_user_delete[index].visible = false
      next if not user
      @pic_user_list[index].visible = true
      bitmap = Bitmap.new(32, 32)
      bitmap.blt(0, 0, RPG::Cache.load_bitmap("Graphics/Characters/", user.image), Rect.new(0, 0, 32, 32))
      @pic_user_image[index].picture = bitmap
      @lbl_user_info[index].text = user.name + "(Lv. " + user.level.to_s + " " + Game.getJob(user.job) + ")"
      @btn_user_delete[index].visible = true
    end
  end
  
  def refresh
    super
    setTitle("커뮤니티")
  end
  
  def update
    super
    #if @btn['friend_add'].click
    #  @lst.removeItem 0
      #@lst.clear
    #end
    if Mouse.trigger?
      if @tab.isSelected
        @page = 0
        refreshData
      end
      case @tab.page
      when 0
        if @btn_party_create.click
          Socket.send({'header' => CTSHeader::CREATE_PARTY}) if Game.player.partyNo == 0
        elsif @btn_party_quit.click
          Socket.send({'header' => (Game.player.partyNo == Game.player.no ? 
            CTSHeader::BREAK_UP_PARTY : CTSHeader::QUIT_PARTY)}) if Game.player.partyNo > 0
        end
        for i in (@page * 4)...(@page * 4 + 4)
          user = @user_list[i]
          index = i - @page * 4
          next if not user
          if @btn_user_delete[index].click && Game.player.partyNo == Game.player.no
            Socket.send({'header' => CTSHeader::KICK_PARTY, 'member' => user.no})
          end
        end
      when 1
        if @btn_guild_page_left.click
          if @page > 0
            @page -= 1
            refreshData
          end
        elsif @btn_guild_page_right.click
          if (@user_list.size - 1) / 4 > @page
            @page += 1 
            refreshData
          end
        end
        for i in (@page * 4)...(@page * 4 + 4)
          user = @user_list[i]
          index = i - @page * 4
          next if not user
          if @btn_user_delete[index].click
            if Game.player.no == Game.player.guildNo
              Socket.send({'header' => CTSHeader::KICK_GUILD, 'member' => user.no})
            elsif Game.player.no == user.no
              Socket.send({'header' => CTSHeader::QUIT_GUILD})
            end
          end
        end
      when 2
        if @btn_friend_page_left.click
          if @page > 0
            @page -= 1
            refreshData
          end
        elsif @btn_friend_page_right.click
          if (@user_list.size - 1) / 4 > @page
            @page += 1 
            refreshData
          end
        end
      end
    end
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ MUI_ClickMenu
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2015. 2. 15
# --------------------------------------------------------------------------
# Description
# 
#    다른 유저에게 신청이나 정보를 얻을 수 있는 폼 클래스입니다.
#    오른쪽 마우스를 누르면 표시됩니다.
#────────────────────────────────────────────────────────────────────────────

class MUI_ClickMenu < MUI::Form
  def initialize(userNo)
    super(Mouse.x, Mouse.y, 100, 230)
    @user = Game.map.getNetplayer(userNo)
    # 정보 보기
    @btn_info = MUI::Button.new(10, 10, 80, 20)
    @btn_info.text = "정보 보기"
    addControl(@btn_info)
    # 파티 초대
    @btn_party = MUI::Button.new(10, 40, 80, 20)
    @btn_party.text = "파티 초대"
    addControl(@btn_party)
    # 길드 초대
    @btn_guild = MUI::Button.new(10, 70, 80, 20)
    @btn_guild.text = "길드 초대"
    addControl(@btn_guild)
    # 친구 추가
    @btn_friend = MUI::Button.new(10, 100, 80, 20)
    @btn_friend.text = "친구 추가"
    addControl(@btn_friend)
    # 거래
    @btn_trade = MUI::Button.new(10, 130, 80, 20)
    @btn_trade.text = "거래 요청"
    addControl(@btn_trade)
    # 귓속말
    @btn_whisper = MUI::Button.new(10, 160, 80, 20)
    @btn_whisper.text = "귓속말"
    addControl(@btn_whisper)
  end
  
  def refresh
    super
    setTitle("메뉴")
  end
  
  def update
    super
    if @btn_info.click
    elsif @btn_party.click
      if Game.player.partyNo > 0
        Socket.send({'header' => CTSHeader::INVITE_PARTY, "other" => @user.no})
        dispose
      end
    elsif @btn_guild.click
      if Game.player.guildNo > 0
        Socket.send({'header' => CTSHeader::INVITE_GUILD, "other" => @user.no})
        dispose
      end
    elsif @btn_friend.click
    elsif @btn_trade.click
      Socket.send({'header' => CTSHeader::REQUEST_TRADE, "partner" => @user.no})
      dispose
    elsif @btn_whisper.click
    end
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ MUI_Quest
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2014. 3. 9
# --------------------------------------------------------------------------
# Description
# 
#    퀘스트를 관리하는 폼 클래스입니다.
#────────────────────────────────────────────────────────────────────────────

class MUI_Quest < MUI::Form
  def initialize
    super(200, 200, 400, 300)
    # 픽쳐_윈도우
    @pic_win = MUI::PictureBox.new(150, 210, 170, 34)
    @pic_win.picture = "Graphics/MUI/Quest/" + "window.png"
    addControl(@pic_win)
    @lbl_index = []
    for i in 0..4
      @lbl_index[i] = MUI::Label.new(28, 20+i*16, 100, 20)
      @lbl_index[i].text = "퀘스트 #{i}"
      @lbl_index[i].color = Color.gray
      addControl(@lbl_index[i])
    end
    # 라벨_제목
    @lbl_title = MUI::Label.new(150, 20, 224, 20)
    @lbl_title.text = "제목을 입력하세요."
    @lbl_title.color = Color.system
    @lbl_title.size += 6
    addControl(@lbl_title)
    # 라벨_미션
    @lbl_mission = MUI::Label.new(150, 50, 224, 20)
    @lbl_mission.text = "다람쥐를 잡아라"
    @lbl_mission.size += 2
    addControl(@lbl_mission)
    # 라벨_내용
    @lbl_subject = MUI::Label.new(150, 75, 224, 100)
    @lbl_subject.text = "다람쥐를 잡아서 구워먹자 허허허허허ㅓ헣ㄹㅇㅎㅇㅀㄹㅇㄹ"*5
    @lbl_subject.color = Color.gray
    addControl(@lbl_subject)
    # 라벨_보상
    @lbl_reward = MUI::Label.new(150, 190, 1, 1)
    @lbl_reward.text = "보상 내역"
    @lbl_reward.color = Color.system
    addControl(@lbl_reward)
    @lbl_reward.autoSize
    # 보상 아이콘
    @pic_icon = []
    for i in 0..4
      @pic_icon[i] = MUI::PictureBox.new(155+i*34, 215, 24, 24)
      @pic_icon[i].picture = "Graphics/Icons/" + "042-Item11.png"
      addControl(@pic_icon[i])
    end
  end

  def refresh
    super
    setTitle("임무 (Quest)")
  end
  
  def update
    super
    for i in 0..4
      if @lbl_index[i].click
        @lbl_title.text = "퀘스트제목 #{i}"
        @lbl_mission.text = "퀘스트미션 #{i}"
        @lbl_subject.text = "퀘스트내용 #{i}"
      end
    end
  end
end




#────────────────────────────────────────────────────────────────────────────
# ▶ AllKey_Module
# --------------------------------------------------------------------------
# Author    ?
# Modify    ?
# Date      ?
# --------------------------------------------------------------------------
# Description
#
#    전체 키를 관리하는 모듈입니다.
#────────────────────────────────────────────────────────────────────────────

  MOUSE_BUTTON_L = 0x01       # left mouse button
  MOUSE_BUTTON_R = 0x02       # right mouse button
  MOUSE_BUTTON_M = 0x04       # middle mouse button
  MOUSE_BUTTON_4 = 0x05       # 4th mouse button 
  MOUSE_BUTTON_5 = 0x06       # 5th mouse button

  KEY_BACK      = 0x08        # BACKSPACE key
  KEY_TAB       = 0x09        # TAB key
  KEY_RETURN    = 0x0D        # ENTER key
  KEY_SHIFT     = 0x10        # SHIFT key
  KEY_CTRL      = 0x11        # CTRL key
  KEY_ALT       = 0x12        # ALT key
  KEY_PAUSE     = 0x13        # PAUSE key
  KEY_CAPITAL   = 0x14        # CAPS LOCK key
  KEY_ESCAPE    = 0x1B        # ESC key
  KEY_SPACE     = 0x20        # SPACEBAR
  KEY_PRIOR     = 0x21        # PAGE UP key
  KEY_NEXT      = 0x22        # PAGE DOWN key
  KEY_END       = 0x23        # END key
  KEY_HOME      = 0x24        # HOME key
  KEY_LEFT      = 0x25        # LEFT ARROW key
  KEY_UP        = 0x26        # UP ARROW key
  KEY_RIGHT     = 0x27        # RIGHT ARROW key
  KEY_DOWN      = 0x28        # DOWN ARROW key
  KEY_SELECT    = 0x29        # SELECT key
  KEY_PRINT     = 0x2A        # PRINT key
  KEY_SNAPSHOT  = 0x2C        # PRINT SCREEN key
  KEY_INSERT    = 0x2D        # INS key
  KEY_DELETE    = 0x2E        # DEL key

  KEY_0         = 0x30        # 0 key
  KEY_1         = 0x31        # 1 key
  KEY_2         = 0x32        # 2 key
  KEY_3         = 0x33        # 3 key
  KEY_4         = 0x34        # 4 key
  KEY_5         = 0x35        # 5 key
  KEY_6         = 0x36        # 6 key
  KEY_7         = 0x37        # 7 key
  KEY_8         = 0x38        # 8 key
  KEY_9         = 0x39        # 9 key

  KEY_A         = 0x41        # A key
  KEY_B         = 0x42        # B key
  KEY_C         = 0x43        # C key
  KEY_D         = 0x44        # D key
  KEY_E         = 0x45        # E key
  KEY_F         = 0x46        # F key
  KEY_G         = 0x47        # G key
  KEY_H         = 0x48        # H key
  KEY_I         = 0x49        # I key
  KEY_J         = 0x4A        # J key
  KEY_K         = 0x4B        # K key
  KEY_L         = 0x4C        # L key
  KEY_M         = 0x4D        # M key
  KEY_N         = 0x4E        # N key
  KEY_O         = 0x4F        # O key
  KEY_P         = 0x50        # P key
  KEY_Q         = 0x51        # Q key
  KEY_R         = 0x52        # R key
  KEY_S         = 0x53        # S key
  KEY_T         = 0x54        # T key
  KEY_U         = 0x55        # U key
  KEY_V         = 0x56        # V key
  KEY_W         = 0x57        # W key
  KEY_X         = 0x58        # X key
  KEY_Y         = 0x59        # Y key
  KEY_Z         = 0x5A        # Z key

  KEY_LWIN      = 0x5B        # Left Windows key (Microsoft Natural keyboard) 
  KEY_RWIN      = 0x5C        # Right Windows key (Natural keyboard)
  KEY_APPS      = 0x5D        # Applications key (Natural keyboard)

  KEY_NUMPAD0   = 0x60        # Numeric keypad 0 key
  KEY_NUMPAD1   = 0x61        # Numeric keypad 1 key
  KEY_NUMPAD2   = 0x62        # Numeric keypad 2 key
  KEY_NUMPAD3   = 0x63        # Numeric keypad 3 key
  KEY_NUMPAD4   = 0x64        # Numeric keypad 4 key
  KEY_NUMPAD5   = 0x65        # Numeric keypad 5 key
  KEY_NUMPAD6   = 0x66        # Numeric keypad 6 key
  KEY_NUMPAD7   = 0x67        # Numeric keypad 7 key
  KEY_NUMPAD8   = 0x68        # Numeric keypad 8 key
  KEY_NUMPAD9	  = 0x69        # Numeric keypad 9 key
  KEY_MULTIPLY  = 0x6A        # Multiply key (*)
  KEY_ADD       = 0x6B        # Add key (+)
  KEY_SEPARATOR = 0x6C        # Separator key
  KEY_SUBTRACT  = 0x6D        # Subtract key (-)
  KEY_DECIMAL   = 0x6E        # Decimal key
  KEY_DIVIDE    = 0x6F        # Divide key (/)

  KEY_F1        = 0x70        # F1 key
  KEY_F2        = 0x71        # F2 key
  KEY_F3        = 0x72        # F3 key
  KEY_F4        = 0x73        # F4 key
  KEY_F5        = 0x74        # F5 key
  KEY_F6        = 0x75        # F6 key
  KEY_F7        = 0x76        # F7 key
  KEY_F8        = 0x77        # F8 key
  KEY_F9        = 0x78        # F9 key
  KEY_F10       = 0x79        # F10 key
  KEY_F11       = 0x7A        # F11 key
  KEY_F12       = 0x7B        # F12 key

  KEY_NUMLOCK   = 0x90        # NUM LOCK key
  KEY_SCROLL    = 0x91        # SCROLL LOCK key

  KEY_LSHIFT    = 0xA0        # Left SHIFT key
  KEY_RSHIFT	  = 0xA1        # Right SHIFT key
  KEY_LCTRL     = 0xA2        # Left CONTROL key
  KEY_RCTRL     = 0xA3        # Right CONTROL key
  KEY_LALT	    = 0xA4        # Left ALT key
  KEY_RALT	    = 0xA5        # Right ALT key

  KEY_SEP	      = 0xBC        # , key
  KEY_DASH	    = 0xBD        # - key
  KEY_DOTT	    = 0xBE        # . key
  
module Key
  module_function
  
  #--------------------------------------------------------------------------
  # * 단축키 설정
  #--------------------------------------------------------------------------
  SLOT = []
  SLOT[0] = KEY_Q
  SLOT[1] = KEY_W
  SLOT[2] = KEY_E
  SLOT[3] = KEY_R
  SLOT[4] = KEY_T
  SLOT[5] = KEY_A
  SLOT[6] = KEY_S
  SLOT[7] = KEY_D
  SLOT[8] = KEY_F
  SLOT[9] = KEY_G
  #--------------------------------------------------------------------------
  # * Key Functions
  #--------------------------------------------------------------------------
  def init
    @key_states = []
    for i in 0..255
      @key_states[i] = 0
    end
  end
  
  def update
    return unless Graphics.focus
    for i in 0..255
      if press?(i)
        if @key_states[i] == 0
          @key_states[i] = 1
        else
          @key_states[i] = [@key_states[i]+1, 2].max
        end
      else
        @key_states[i] = 0
      end
    end
  end
  
  def trigger?(key)
    return unless Graphics.focus
    return @key_states[key] == 1
  end
  
  def press?(key)
    return unless Graphics.focus
    return Win32API::GetKeyState.call(key) != 0
  end
  
  def repeat?(key)
    return unless Graphics.focus
    return (trigger?(key) or @key_states[key] >= 20)
  end
  
  def dir4
    return unless Graphics.focus
    if press?(KEY_DOWN)
      return 2
    elsif press?(KEY_LEFT)
      return 4
    elsif press?(KEY_RIGHT)
      return 6
    elsif press?(KEY_UP)
      return 8
    end
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ Mouse Input (7.0) 
# --------------------------------------------------------------------------
# Author    Near Fantastica, SephirothSpawn
# Modify    
# Date      2014. . 
# --------------------------------------------------------------------------
# Description
#
#   0:Left, 1:Right, 2:Center
#────────────────────────────────────────────────────────────────────────────

module Mouse
  Mouse_to_Input_Triggers = {0 => Input::C, 1 => Input::B, 2 => Input::A} 
  
  @@frame = [Win32API::GetSystemMetrics.call(32), Win32API::GetSystemMetrics.call(33), Win32API::GetSystemMetrics.call(4)]  
  @triggers     =   [0, 1], [0, 2], [0, 4]
  @old_pos      =   0
  @pos_i        =   0
    
  def self.grid    
    return nil if @pos.nil?
    x = (@pos[0] + Game.map.display_x / 4) / 32
    y = (@pos[1] + Game.map.display_y / 4) / 32
    return [x, y]
  end

  def self.position
    return @pos == nil ? [0, 0] : @pos
  end

  def self.global_pos
    pos = [0, 0].pack('ll')
    return Win32API::GetCursorPos.call(pos) == 0 ? nil : pos.unpack('ll')
  end

  def self.screen_to_client(x=0, y=0)
    pos = [x, y].pack('ll')
    return Win32API::ScreenToClient.call(Game::HWND, pos) == 0 ? nil : pos.unpack('ll')
  end  

  def self.pos
    global_pos = [0, 0].pack('ll')    
    gx, gy = Win32API::GetCursorPos.call(global_pos) == 0 ? nil : global_pos.unpack('ll')
    local_pos = [gx, gy].pack('ll')
    x, y = Win32API::ScreenToClient.call(Game::HWND, local_pos) == 0 ? nil : local_pos.unpack('ll')
    begin
      #if (x >= -@@frame[0] && y >= -@@frame[2] && x <= Graphics.getRect[0] + @@frame[0] && y <= Graphics.getRect[1] + @@frame[1])
      return x, y
      #end
    rescue
      return 0, 0
    end
  end  
    
  def self.update
    return unless Graphics.focus
    old_pos = @pos
    @pos = self.pos
    for i in @triggers
      n = Win32API::GetAsyncKeyState.call(i[1])
      if [0, 1].include?(n)
        i[0] = (i[0] > 0 ? i[0] * -1 : 0)
      else
        i[0] = (i[0] > 0 ? i[0] + 1 : 1)
      end
    end
    
    x, y = @pos
    (x == nil or y == nil) ? return : 0
    if self.press?
      @ox = x; @oy = y
    else
      @x = x; @y = y
    end
  end
  
  def self.pos_y
    y = (@pos[1])
    return y
  end
  
  def self.pos_x
    x = (@pos[0])
    return x
  end

  def self.trigger?(id = 0)
    return unless Graphics.focus
    if @triggers[id][0] == 1
      return true
    end
  end

  def self.repeat?(id = 0)
    return unless Graphics.focus
    if @triggers[id][0] <= 0
      return false
    else
      return @triggers[id][0] % 5 == 1 && @triggers[id][0] % 5 != 2
    end
  end

  def self.press?(id = 0)
    return unless Graphics.focus
    return @triggers[id][0] > 0
  end

  WHEEL_DELTA = 120
  def self.on_wheel(delta, keys, x, y)
    return unless Graphics.focus
    @@delta += delta
    if @@delta.abs >= WHEEL_DELTA
      delta_idx = - @@delta / WHEEL_DELTA
      @@delta %= WHEEL_DELTA
    end
    @wheel = delta_idx
  end
  if defined? Wheel
    Wheel.Call
    @@delta = 0
  end
  
  def self.screen_to_client(x=0, y=0)
    pos = [x, y].pack('ll')
    return Win32API::ScreenToClient.call(Game::HWND, pos) == 0 ? nil : pos.unpack('ll')
  end
  
  module_function
  
  def x
    return @x
  end
  
  def y
    return @y
  end

  def ox
    return @ox
  end

  def oy
    return @oy
  end

  def x=(x)
    @x = x
  end

  def y=(y)
    @y = y
  end

  def ox=(x)
    @ox = x
  end

  def oy=(y)
    @oy = y
  end
  
  def wheel
    @wheel
  end
  
  def wheel=(w)
    @wheel = w
  end
  
  @x = 0
  @y = 0
  @ox = 0
  @oy = 0
  @wheel = 0
  
  def arrive_rect?(x = 0, y = 0, width = 1, height = 1)
    if x.rect?
      y = x.y
      width = x.width
      height = x.height
      x = x.x
    end
    return (@x > x and @x < x + width and @y > y and @y < y + height)
  end
  
  def arrive_sprite_rect?(sprite)
    x = sprite.viewport.x + sprite.x - sprite.viewport.ox
    y = sprite.viewport.y + sprite.y - sprite.viewport.oy
    return self.arrive_rect?(x, y, sprite.bitmap.width, sprite.bitmap.height)
  end
  
  def arrive_sprite?(sprite)
    x = sprite.viewport.x + sprite.x - sprite.viewport.ox
    y = sprite.viewport.y + sprite.y - sprite.viewport.oy
    self.arrive_rect?(x, y, sprite.bitmap.width, sprite.bitmap.height) ? 0 : return
    color = sprite.bitmap.get_pixel(@x - x, @y - y)
    return ((color.red != 0 and color.green != 0 and color.blue != 0 and color.alpha != 0) ? true : false)
  end
  
  def map_x
    return (((Game.map.display_x.to_f/4.0).floor + @x.to_f)/32.0).floor
  end

  def map_y
    return (((Game.map.display_y.to_f/4.0).floor + @y.to_f)/32.0).floor
  end
end

class << Input
  unless self.method_defined?(:seph_mouse_input_update)
    alias_method :seph_mouse_input_update,   :update
    alias_method :seph_mouse_input_trigger?, :trigger?
    alias_method :seph_mouse_input_repeat?,  :repeat?
  end

  def update
    seph_mouse_input_update
  end

  def trigger?(constant)
    return true if seph_mouse_input_trigger?(constant)
    unless Mouse.pos.nil?
      if Mouse::Mouse_to_Input_Triggers.has_value?(constant)
        mouse_trigger = Mouse::Mouse_to_Input_Triggers.index(constant)
        return true if Mouse.trigger?(mouse_trigger)      
      end
    end
    return false
  end

  def repeat?(constant)
    return true if seph_mouse_input_repeat?(constant)
    unless Mouse.pos.nil?
      if Mouse::Mouse_to_Input_Triggers.has_value?(constant)
        mouse_trigger = Mouse::Mouse_to_Input_Triggers.index(constant)     
        return true if Mouse.repeat?(mouse_trigger)
      end
    end
    return false
  end
end
#────────────────────────────────────────────────────────────────────────────
# ▶ IME
# --------------------------------------------------------------------------
# Author    카에데
# Modify    뮤 (mu29gl@gmail.com), jubin
# Date      2015
# --------------------------------------------------------------------------
# Description
#
#    다국어 입력기 IME를 담당하는 클래스입니다.
#────────────────────────────────────────────────────────────────────────────

class IME
  attr_accessor :focus
  attr_accessor :multiline
  attr_accessor :choice
  attr_accessor :text
  attr_accessor :cstr
  attr_accessor :settext
  attr_accessor :gettext
  attr_accessor :setlong
  attr_accessor :getlong
  attr_accessor :change
  attr_accessor :setcstr
  
  def initialize
    @settext = Win32API.new(Config::DLL_PATH + 'IME.dll', 'SetIMEText', 'lp', '')
    @gettext = Win32API.new(Config::DLL_PATH + 'IME.dll', 'GetIMEText', 'l', 'p')
    @setlong = Win32API.new(Config::DLL_PATH + 'IME.dll', 'SetIMELong', 'l', 'l')
    @getlong = Win32API.new(Config::DLL_PATH + 'IME.dll', 'GetIMELong', '', 'l')
    @setflag = Win32API.new(Config::DLL_PATH + 'IME.dll', 'SetIMEFlag', 'l', '')
    @getflag = Win32API.new(Config::DLL_PATH + 'IME.dll', 'GetIMEFlag', '', 'l')
    @setcstr = Win32API.new(Config::DLL_PATH + 'IME.dll', 'SetIMECstr', 'p', 'l')
    @getcstr = Win32API.new(Config::DLL_PATH + 'IME.dll', 'GetIMECstr', '', 'p')
    @change  = Win32API.new(Config::DLL_PATH + 'IME.dll', 'ChangeIME', 'l', 'l')
    @getstate = Win32API.new(Config::DLL_PATH + 'IME.dll', 'GetStateIME', '', 'l')
    @choice = false
    @focus = false
    @multiline = false
    @text = []
    @cstr = ""
    MUI.addInput(self)
  end
  
  def getText
    t = ""
    for i in 0...@text.size
      if @text[i] != nil
        t += @text[i]
      end
    end
    t += @cstr.to_s
    return t
  end
  
  def setText
    for i in 0...0#@getlong.call()
      @settext.call(i, @text[i])
      if @gettext.call(i) == ""
        @text[i] = @getcstr.call()
      else
        @text[i] = @gettext.call(i)
      end
    end
  end
  
  def getState
    return @getstate.call()
  end
  
  # 0e 1k
  def setIMEMode=(a)
    @change.call(a)
  end
  
  def clear(i = 1)
    if i == 1
      i = 0 if @cstr.size != 3
    end
    Win32API.new(Config::DLL_PATH + 'IME.dll', 'ClearIME', 'l', '').call(i)
  end
  
  def update
    if @focus == true
      if @choice == false
        for i in 0...@text.size
          @settext.call(i, @text[i])
        end
        @setlong.call(@text.size)
        @setcstr.call(@cstr)
        @choice = true
      else
        if @multiline == true
          @setflag.call(0x01)
        else
          @setflag.call(0)
        end
        for i in 0...@text.size
          @text[i] = ""
        end
        for i in 0...@getlong.call()
          @text[i] = @gettext.call(i)
        end
        @cstr = @getcstr.call()
      end
    end
  end
  
  def dispose
    MUI.deleteInput(self)
  end
end




#────────────────────────────────────────────────────────────────────────────
# ▶ Map Extractor
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com)
# Date      2015. 1. 23
#────────────────────────────────────────────────────────────────────────────

def blockMapExtract
  $data_tilesets = load_data("Data/Tilesets.rxdata")
  Game.init
  Dir.mkdir("./Map") if !FileTest.exist?("./Map")
  map_infos = load_data('Data/MapInfos.rxdata')
  map_infos.each do |k, v|
    Game.map.setup(k)
    mapfile = sprintf("Map/Map%d.map", k)
    File.open(mapfile, "w") do |fw|
      writeMapData(fw, k, v)
    end
  end
  print "맵 데이터 추출 완료"
  exit
end

def writeMapData(fw, id, info)
  map = load_data(sprintf("Data/Map%03d.rxdata", id))
  fw.write("#{id},#{info.name},#{Game.map.width},#{Game.map.height},")
  for y in 0...(Game.map.height)
    for x in 0...(Game.map.width)
      flag = Game.map.passable?(x, y, 0) ? 0 : 1
      fw.write("#{flag},")
    end
  end
end

blockMapExtract if Config::EXTRACT_MAP
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

