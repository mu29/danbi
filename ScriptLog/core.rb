# filename core.rb
Game.SubClassing

class Sprite
  def isPointInRect?(_x, _y)
    return false unless self.visible
    return false unless self.opacity > 0
    return false unless (_x + self.ox >= self.x && _x + self.ox < self.x + self.width)
    return false unless (_y + self.oy >= self.y && _y + self.oy < self.y + self.height)
    return true
  end
end

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
      # 개행문자 빼고 더함
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
    text = if str.is_a?(Array)
      str
    else
      get_divided_text(width, str, esn)
    end
    text.each_index do |n|
      next if text[n] == ""
      # 비트맵 세로 크기보다 크면 중단
      return if y + n * text_size(text[n]).height > height
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