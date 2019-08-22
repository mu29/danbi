# encoding: utf-8

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

module Key

  MOUSE_BUTTON_L = 0x01       # left mouse button
  MOUSE_BUTTON_R = 0x02       # right mouse button
  MOUSE_BUTTON_M = 0x04       # middle mouse button
  MOUSE_BUTTON_4 = 0x05       # 4th mouse button 
  MOUSE_BUTTON_5 = 0x06       # 5th mouse button

  KB_BACK      = 0x08        # BACKSPACE key
  KB_TAB       = 0x09        # TAB key
  KB_RETURN    = 0x0D        # ENTER key
  KB_SHIFT     = 0x10        # SHIFT key
  KB_CTRL      = 0x11        # CTRL key
  KB_ALT       = 0x12        # ALT key
  KB_PAUSE     = 0x13        # PAUSE key
  KB_CAPITAL   = 0x14        # CAPS LOCK key
  KB_ESCAPE    = 0x1B        # ESC key
  KB_SPACE     = 0x20        # SPACEBAR
  KB_PRIOR     = 0x21        # PAGE UP key
  KB_NEXT      = 0x22        # PAGE DOWN key
  KB_END       = 0x23        # END key
  KB_HOME      = 0x24        # HOME key
  KB_LEFT      = 0x25        # LEFT ARROW key
  KB_UP        = 0x26        # UP ARROW key
  KB_RIGHT     = 0x27        # RIGHT ARROW key
  KB_DOWN      = 0x28        # DOWN ARROW key
  KB_SELECT    = 0x29        # SELECT key
  KB_PRINT     = 0x2A        # PRINT key
  KB_SNAPSHOT  = 0x2C        # PRINT SCREEN key
  KB_INSERT    = 0x2D        # INS key
  KB_DELETE    = 0x2E        # DEL key

  KB_0         = 0x30        # 0 key
  KB_1         = 0x31        # 1 key
  KB_2         = 0x32        # 2 key
  KB_3         = 0x33        # 3 key
  KB_4         = 0x34        # 4 key
  KB_5         = 0x35        # 5 key
  KB_6         = 0x36        # 6 key
  KB_7         = 0x37        # 7 key
  KB_8         = 0x38        # 8 key
  KB_9         = 0x39        # 9 key

  KB_A         = 0x41        # A key
  KB_B         = 0x42        # B key
  KB_C         = 0x43        # C key
  KB_D         = 0x44        # D key
  KB_E         = 0x45        # E key
  KB_F         = 0x46        # F key
  KB_G         = 0x47        # G key
  KB_H         = 0x48        # H key
  KB_I         = 0x49        # I key
  KB_J         = 0x4A        # J key
  KB_K         = 0x4B        # K key
  KB_L         = 0x4C        # L key
  KB_M         = 0x4D        # M key
  KB_N         = 0x4E        # N key
  KB_O         = 0x4F        # O key
  KB_P         = 0x50        # P key
  KB_Q         = 0x51        # Q key
  KB_R         = 0x52        # R key
  KB_S         = 0x53        # S key
  KB_T         = 0x54        # T key
  KB_U         = 0x55        # U key
  KB_V         = 0x56        # V key
  KB_W         = 0x57        # W key
  KB_X         = 0x58        # X key
  KB_Y         = 0x59        # Y key
  KB_Z         = 0x5A        # Z key

  KB_LWIN      = 0x5B        # Left Windows key (Microsoft Natural keyboard) 
  KB_RWIN      = 0x5C        # Right Windows key (Natural keyboard)
  KB_APPS      = 0x5D        # Applications key (Natural keyboard)

  KB_NUMPAD0   = 0x60        # Numeric keypad 0 key
  KB_NUMPAD1   = 0x61        # Numeric keypad 1 key
  KB_NUMPAD2   = 0x62        # Numeric keypad 2 key
  KB_NUMPAD3   = 0x63        # Numeric keypad 3 key
  KB_NUMPAD4   = 0x64        # Numeric keypad 4 key
  KB_NUMPAD5   = 0x65        # Numeric keypad 5 key
  KB_NUMPAD6   = 0x66        # Numeric keypad 6 key
  KB_NUMPAD7   = 0x67        # Numeric keypad 7 key
  KB_NUMPAD8   = 0x68        # Numeric keypad 8 key
  KB_NUMPAD9	 = 0x69        # Numeric keypad 9 key
  KB_MULTIPLY  = 0x6A        # Multiply key (*)
  KB_ADD       = 0x6B        # Add key (+)
  KB_SEPARATOR = 0x6C        # Separator key
  KB_SUBTRACT  = 0x6D        # Subtract key (-)
  KB_DECIMAL   = 0x6E        # Decimal key
  KB_DIVIDE    = 0x6F        # Divide key (/)

  KB_F1        = 0x70        # F1 key
  KB_F2        = 0x71        # F2 key
  KB_F3        = 0x72        # F3 key
  KB_F4        = 0x73        # F4 key
  KB_F5        = 0x74        # F5 key
  KB_F6        = 0x75        # F6 key
  KB_F7        = 0x76        # F7 key
  KB_F8        = 0x77        # F8 key
  KB_F9        = 0x78        # F9 key
  KB_F10       = 0x79        # F10 key
  KB_F11       = 0x7A        # F11 key
  KB_F12       = 0x7B        # F12 key

  KB_NUMLOCK   = 0x90        # NUM LOCK key
  KB_SCROLL    = 0x91        # SCROLL LOCK key

  KB_LSHIFT    = 0xA0        # Left SHIFT key
  KB_RSHIFT	   = 0xA1        # Right SHIFT key
  KB_LCTRL     = 0xA2        # Left CONTROL key
  KB_RCTRL     = 0xA3        # Right CONTROL key
  KB_LALT	     = 0xA4        # Left ALT key
  KB_RALT	     = 0xA5        # Right ALT key

  KB_SEP	     = 0xBC        # , key
  KB_DASH	     = 0xBD        # - key
  KB_DOTT	     = 0xBE        # . key

  module_function
  #--------------------------------------------------------------------------
  # * 단축키 설정
  #--------------------------------------------------------------------------
  SLOT = []
  SLOT[0] = Key::KB_Q
  SLOT[1] = Key::KB_W
  SLOT[2] = Key::KB_E
  SLOT[3] = Key::KB_R
  SLOT[4] = Key::KB_T
  SLOT[5] = Key::KB_A
  SLOT[6] = Key::KB_S
  SLOT[7] = Key::KB_D
  SLOT[8] = Key::KB_F
  SLOT[9] = Key::KB_G
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
    return unless GameWindow.is_active?
    for i in 0..255
      if press?(i)
        if @key_states[i] == 0
          @key_states[i] = 1
        else
          @key_states[i] = [@key_states[i] + 1, 2].max
        end
      else
        @key_states[i] = 0
      end
    end
  end
  
  def trigger?(key)
    return false unless GameWindow.is_active?
    return @key_states[key] == 1
  end
  
  def press?(key)
    return false unless GameWindow.is_active?
    return Win32API::GetKeyState.call(key) != 0
  end
  
  def repeat?(key)
    return false unless GameWindow.is_active?
    return (trigger?(key) or @key_states[key] >= 20)
  end
  
  def dir4
    return 0 unless GameWindow.is_active?
    if press?(KB_DOWN)
      return 2
    elsif press?(KB_LEFT)
      return 4
    elsif press?(KB_RIGHT)
      return 6
    elsif press?(KB_UP)
      return 8
    end
    return 0
  end
end