# encoding: utf-8

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
  CDS_UPDATEREGISTRY = 0x1
  CDS_TEST = 0x2
  CDS_FULLSCREEN = 0x4
  CDS_GLOBAL = 0x8
  CDS_SET_PRIMARY = 0x10
  CDS_RESET = 0x40000000
  CDS_SETRECT = 0x20000000
  CDS_NORESET = 0x10000000
  DISP_CHANGE_SUCCESSFUL = 0
  DISP_CHANGE_BADMODE = -2
  
  MOD_ALT = 0x0001
  VK_RETURN = 0x0D
  KEY_LALT = 0xA4
  KEY_RETURN = 0x0D
  
  module_function

  def init
    const_set(:WIN_STYLE, get_window_style)
    const_set(:WIN_RECT, get_monitor_rect)
    const_set(:TASKBAR_RECT, get_taskbar_rect)
    const_set(:RESOLUTION_LIST, get_usable_resolution)
    resize_screen(Config::WINDOW_WIDTH, Config::WINDOW_HEIGHT)
    #resize_screen2(Config::WINDOW_WIDTH, Config::WINDOW_HEIGHT, File.iniGet(Config::OPTION_PATH, Config::OPTION_KEY, "fullscreen", false, 10))
  end

  # 윈도우 스타일
  def get_window_style
    return Win32API::GetWindowLong.call(GameWindow::HWND, GWL_STYLE)
  end
  
  # 컴퓨터 해상도
  def get_monitor_rect
    return [Win32API::GetSystemMetrics.call(0), Win32API::GetSystemMetrics.call(1)]
  end
  
  # 작업표시줄
  def get_taskbar_rect
    rect = [0, 0, 0, 0].pack('l4')
    Win32API::GetWindowRect.call(Win32API::FindWindow.call('Shell_TrayWnd', 0), rect)
    rect = rect.unpack('l4')
    w, h = (rect[2] - rect[0]).abs, (rect[3] - rect[1]).abs
    return [(w >= WIN_RECT[0] ? 0 : w), (h >= WIN_RECT[1] ? 0 : h)]
  end
  
  # 풀스크린 사용 가능한 해상도
  def get_usable_resolution
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

  # 해상도 변경
  def resize_screen2(width, height, fullscreen = false)
    @width, @height = width, height
    if fullscreen
      unless RESOLUTION_LIST.include?([width, height])
        if defined? MUI_Dialog
          dialog = MUI_Dialog.new(Dialog::RESOLUTION, "알림", "#{width}*#{height} 의 해상도는 풀스크린을 지원하지 않습니다.", ["확인"]) do
            dialog.dispose if dialog.value == 0
          end
        end
        return false
      end
      case Win32API::ChangeDisplaySettings.call(get_devmode(width, height), CDS_FULLSCREEN)
      when DISP_CHANGE_SUCCESSFUL
        Win32API::SetWindowLong.call(GameWindow::HWND, GWL_STYLE, WIN_STYLE ^ (WS_BORDER | WS_DLGFRAME))
        Win32API::SetWindowPos.call(GameWindow::HWND, HWND_TOPMOST, 0, 0, width, height, SWP_SHOWWINDOW)
        Win32API::ChangeDisplaySettings.call(0, 0x40000000)
        Win32API::ClipCursor.call([0, 0, self.width, self.height].pack('l4'))
        Win32API::SetCursorPos.call(GameWindow.get_client_rect[2] + Graphics.width / 2, GameWindow.get_client_rect[3] + Graphics.height / 2)
        return true
      when DISP_CHANGE_BADMODE
        Win32API::ClipCursor.call(0)
        Win32API::ChangeDisplaySettings.call(0, 0)
        Win32API::SetCursorPos.call(GameWindow.get_client_rect[2] + Graphics.width / 2, GameWindow.get_client_rect[3] + Graphics.height / 2)
        return false
      end
    else
      Win32API::ClipCursor.call(0)
      Win32API::ChangeDisplaySettings.call(0, 0)
      Win32API::SetWindowLong.call(GameWindow::HWND, GWL_STYLE, WIN_STYLE)
      Win32API::SetCursorPos.call(WIN_RECT[0] / 2, WIN_RECT[1] / 2)
      return set_window_center(width, height) == 1
    end
  end
  
  # DEVMODE 구조체
  def get_devmode(width, height, bit=32)
    devmode =
    [0,0,0,0,0,0,0,0,0,220,0,BITSPERPEL|PELSWIDTH|PELSHEIGHT|PEDTH,
     0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,bit,width,height,0,0,0,0,0]
    return devmode.pack('Q8 L S2 L Q2 S5 Q8 S L3 Q5')
  end

  # 윈도우 가운데 정렬
  def set_window_center(width, height)
    Win32API::AdjustWindowRect.call(rect=[0, 0, width, height].pack('l4'), WIN_STYLE, 0)
    rect = rect.unpack('l4'); rect = rect[2] - rect[0], rect[3] - rect[1]
    x = WIN_RECT[0] - TASKBAR_RECT[0] - rect[0]
    y = WIN_RECT[1] - TASKBAR_RECT[1] - rect[1]
    Win32API::SetWindowPos.call(GameWindow::HWND, HWND_NOTOPMOST, x/2, y/2, rect[0], rect[1], SWP_SHOWWINDOW)
  end

  # 풀스크린 상태
  def is_full_screen?
    rect = [0, 0, 0, 0].pack('l4')
    Win32API::GetWindowRect.call(GameWindow::HWND, rect)
    return rect.unpack('l4') == [0, 0, *WIN_RECT]
  end
    
  # Rect
  def getRect
    return [Graphics.width, Graphics.height]
  end

  def update_alt_enter
    if Config::USE_ALT_ENTER && GameWindow.is_active?
      if Key.press?(Key::KB_LALT) && Key.trigger?(Key::KB_RETURN)
        #Graphics.resize_screen2(self.width, self.height, !is_full_screen?)
        toggle_fullscreen
      end
    end
  end

  class << self
    alias :update_danbi :update if !$@
    def update
      GameWindow.set_focus_state
      update_alt_enter
      update_danbi
    end
  end
end

# Fullscreen++ v2.2 for VX and VXace by Zeus81
# Free for non commercial and commercial use
# Licence : http://creativecommons.org/licenses/by-sa/3.0/
# Contact : zeusex81@gmail.com
# (fr) Manuel d'utilisation : http://pastebin.com/raw.php?i=1TQfMnVJ
# (en) User Guide           : http://pastebin.com/raw.php?i=EgnWt9ur

class << Graphics

  CreateWindowEx            = Win32API.new('user32'  , 'CreateWindowEx'           , 'ippiiiiiiiii', 'i')
  GetClientRect             = Win32API.new('user32'  , 'GetClientRect'            , 'ip'          , 'i')
  GetDC                     = Win32API.new('user32'  , 'GetDC'                    , 'i'           , 'i')
  GetSystemMetrics          = Win32API.new('user32'  , 'GetSystemMetrics'         , 'i'           , 'i')
  GetWindowRect             = Win32API.new('user32'  , 'GetWindowRect'            , 'ip'          , 'i')
  FillRect                  = Win32API.new('user32'  , 'FillRect'                 , 'ipi'         , 'i')
  FindWindow                = Win32API.new('user32'  , 'FindWindow'               , 'pp'          , 'i')
  ReleaseDC                 = Win32API.new('user32'  , 'ReleaseDC'                , 'ii'          , 'i')
  SendInput                 = Win32API.new('user32'  , 'SendInput'                , 'ipi'         , 'i')
  SetWindowLong             = Win32API.new('user32'  , 'SetWindowLong'            , 'iii'         , 'i')
  SetWindowPos              = Win32API.new('user32'  , 'SetWindowPos'             , 'iiiiiii'     , 'i')
  ShowWindow                = Win32API.new('user32'  , 'ShowWindow'               , 'ii'          , 'i')
  SystemParametersInfo      = Win32API.new('user32'  , 'SystemParametersInfo'     , 'iipi'        , 'i')
  UpdateWindow              = Win32API.new('user32'  , 'UpdateWindow'             , 'i'           , 'i')
  GetPrivateProfileString   = Win32API.new('kernel32', 'GetPrivateProfileString'  , 'ppppip'      , 'i')
  WritePrivateProfileString = Win32API.new('kernel32', 'WritePrivateProfileString', 'pppp'        , 'i')
  CreateSolidBrush          = Win32API.new('gdi32'   , 'CreateSolidBrush'         , 'i'           , 'i')
  DeleteObject              = Win32API.new('gdi32'   , 'DeleteObject'             , 'i'           , 'i')
 
  unless method_defined?(:zeus_fullscreen_update)
    HWND     = FindWindow.call('RGSS Player', 0)
    BackHWND = CreateWindowEx.call(0x08000008, 'Static', '', 0x80000000, 0, 0, 0, 0, 0, 0, 0, 0)
    alias zeus_fullscreen_resize_screen resize_screen
    alias zeus_fullscreen_update        update
  end
private
  def initialize_fullscreen_rects
    @borders_size    ||= borders_size
    @fullscreen_rect ||= screen_rect
    @workarea_rect   ||= workarea_rect
  end
  def borders_size
    GetWindowRect.call(HWND, wrect = [0, 0, 0, 0].pack('l4'))
    GetClientRect.call(HWND, crect = [0, 0, 0, 0].pack('l4'))
    wrect, crect = wrect.unpack('l4'), crect.unpack('l4')
    Rect.new(0, 0, wrect[2]-wrect[0]-crect[2], wrect[3]-wrect[1]-crect[3])
  end
  def screen_rect
    Rect.new(0, 0, GetSystemMetrics.call(0), GetSystemMetrics.call(1))
  end
  def workarea_rect
    SystemParametersInfo.call(0x30, 0, rect = [0, 0, 0, 0].pack('l4'), 0)
    rect = rect.unpack('l4')
    Rect.new(rect[0], rect[1], rect[2]-rect[0], rect[3]-rect[1])
  end
  def hide_borders() SetWindowLong.call(HWND, -16, 0x14000000) end
  def show_borders() SetWindowLong.call(HWND, -16, 0x14CA0000) end
  def hide_back()    ShowWindow.call(BackHWND, 0)              end
  def show_back
    ShowWindow.call(BackHWND, 3)
    UpdateWindow.call(BackHWND)
    dc    = GetDC.call(BackHWND)
    rect  = [0, 0, @fullscreen_rect.width, @fullscreen_rect.height].pack('l4')
    brush = CreateSolidBrush.call(0)
    FillRect.call(dc, rect, brush)
    ReleaseDC.call(BackHWND, dc)
    DeleteObject.call(brush)
  end
  def resize_window(w, h, ow, oh)
    if @fullscreen
      x, y, z = (@fullscreen_rect.width-w)/2, (@fullscreen_rect.height-h)/2, -1
      Win32API::ClipCursor.call([x, y, x + ow + 1, y + oh + 1].pack('l4'))
    else
      w += @borders_size.width
      h += @borders_size.height
      x = @workarea_rect.x + (@workarea_rect.width  - w) / 2
      y = @workarea_rect.y + (@workarea_rect.height - h) / 2
      z = -2
    end
    SetWindowPos.call(HWND, z, x, y, w, h, 0)
  end
  def release_alt
    inputs = [1,18,2, 1,164,2, 1,165,2].pack('LSx2Lx16'*3)
    SendInput.call(3, inputs, 28)
  end
public
  def load_fullscreen_settings
    @fullscreen       = 0
    @fullscreen_ratio = 0
    @windowed_ratio   = 1
    fullscreen? ? windowed_mode : fullscreen_mode
  end
  def fullscreen?
    @fullscreen or vx_fullscreen?
  end
  def vx_fullscreen?
    rect = screen_rect
    rect.width == 640 and rect.height == 480
  end
  def toggle_fullscreen
    fullscreen? ? windowed_mode : fullscreen_mode
  end
  def vx_fullscreen_mode
    return if vx_fullscreen?
    toggle_vx_fullscreen
  end
  def fullscreen_mode
    return if vx_fullscreen?
    initialize_fullscreen_rects
    show_back
    hide_borders
    @fullscreen = true
    self.ratio += 0 # refresh window size
  end
  def windowed_mode
    toggle_vx_fullscreen if vx_fullscreen?
    initialize_fullscreen_rects
    hide_back
    show_borders
    @fullscreen = false
    self.ratio += 0 # refresh window size
    Win32API::ClipCursor.call(0)
  end
  def ratio
    return 1 if vx_fullscreen?
    @fullscreen ? @fullscreen_ratio : @windowed_ratio
  end
  def ratio=(r)
    return if vx_fullscreen?
    initialize_fullscreen_rects
    r = 0 if r < 0
    if @fullscreen
      @fullscreen_ratio = r
      w_max, h_max = @fullscreen_rect.width, @fullscreen_rect.height
    else
      @windowed_ratio = r
      w_max = @workarea_rect.width  - @borders_size.width
      h_max = @workarea_rect.height - @borders_size.height
    end
    if r == 0
      w, h = w_max, w_max * height / width
      h, w = h_max, h_max * width / height if h > h_max
    else
      w, h = width * r, height * r
      return self.ratio = 0 if w > w_max or h > h_max
    end
    resize_window(w, h, width, height)
  end
  def update
    zeus_fullscreen_update
  end
  def resize_screen(width, height)
    zeus_fullscreen_resize_screen(width, height)
    self.ratio += 0 # refresh window size
  end
end

Graphics.load_fullscreen_settings