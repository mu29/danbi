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

    return GetWindowLong.call(Game::hWnd, GWL_STYLE)

  end

  

  # 컴퓨터 해상도

  def getMonitorRect

    return [GetSystemMetrics.call(0), GetSystemMetrics.call(1)]

  end

  

  # 작업표시줄

  def getTaskBarRect

    rect = [0, 0, 0, 0].pack('l4')

    GetWindowRect.call(FindWindow.call('Shell_TrayWnd', 0), rect)

    rect = rect.unpack('l4')

    w, h = (rect[2] - rect[0]).abs, (rect[3] - rect[1]).abs

    return [(w >= WIN_RECT[0] ? 0 : w), (h >= WIN_RECT[1] ? 0 : h)]

  end

  

  # 풀스크린 사용 가능한 해상도

  def getMonitorsRect

    display, devmode, n = [], '\0'*64, 0

    loop do

      if EnumDisplaySettings.call(0, n, devmode) == 0

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

      case ChangeDisplaySettings.call(getDevmode(width, height), CDS_FULLSCREEN)

      when DISP_CHANGE_SUCCESSFUL

        SetWindowLong.call(Game::hWnd, GWL_STYLE, WIN_STYLE ^ (WS_BORDER | WS_DLGFRAME))

        SetWindowPos.call(Game::hWnd, HWND_TOPMOST, 0, 0, width, height, SWP_SHOWWINDOW)

        ChangeDisplaySettings.call(0, 0x40000000)

        ClipCursor.call([0, 0, self.width, self.height].pack('l4'))

        SetCursorPos.call(Game.getRect[0] + Graphics.width / 2, Game.getRect[1] + Graphics.height / 2)

        return true

      when DISP_CHANGE_BADMODE

        ClipCursor.call(0)

        ChangeDisplaySettings.call(0, 0)

        SetCursorPos.call(Game.getRect[0] + Graphics.width / 2, Game.getRect[1] + Graphics.height / 2)

        return false

      end

    else

      ClipCursor.call(0)

      ChangeDisplaySettings.call(0, 0)

      SetWindowLong.call(Game::hWnd, GWL_STYLE, WIN_STYLE)

      SetCursorPos.call(WIN_RECT[0] / 2, WIN_RECT[1] / 2)

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

    AdjustWindowRect.call(rect=[0, 0, width, height].pack('l4'), WIN_STYLE, 0)

    rect = rect.unpack('l4'); rect = rect[2] - rect[0], rect[3] - rect[1]

    x = WIN_RECT[0] - TASKSIZE[0] - rect[0]

    y = WIN_RECT[1] - TASKSIZE[1] - rect[1]

    SetWindowPos.call(Game::hWnd, HWND_NOTOPMOST, x/2, y/2, rect[0], rect[1], SWP_SHOWWINDOW)

  end



  # 풀스크린 상태

  def isFullScreen

    rect = [0, 0, 0, 0].pack('l4')

    GetWindowRect.call(Game::hWnd, rect)

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



RegisterHotKey.call(Game::hWnd, 0, Graphics::MOD_ALT, Graphics::VK_RETURN)

Graphics.resize_screen(Config::WINDOW_WIDTH, Config::WINDOW_HEIGHT)

Graphics.resize_screen2(Config::WINDOW_WIDTH, Config::WINDOW_HEIGHT, File.iniGet(Config::OPTION_PATH, Config::OPTION_KEY, "fullscreen", false, 10))