# encoding: utf-8

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
    @settext = Win32API.new('Library/IME.dll', 'SetIMEText', 'lp', '')
    @gettext = Win32API.new('Library/IME.dll', 'GetIMEText', 'l', 'p')
    @setlong = Win32API.new('Library/IME.dll', 'SetIMELong', 'l', 'l')
    @getlong = Win32API.new('Library/IME.dll', 'GetIMELong', '', 'l')
    @setflag = Win32API.new('Library/IME.dll', 'SetIMEFlag', 'l', '')
    @getflag = Win32API.new('Library/IME.dll', 'GetIMEFlag', '', 'l')
    @setcstr = Win32API.new('Library/IME.dll', 'SetIMECstr', 'p', 'l')
    @getcstr = Win32API.new('Library/IME.dll', 'GetIMECstr', '', 'p')
    @change  = Win32API.new('Library/IME.dll', 'ChangeIME', 'l', 'l')
    @getstate = Win32API.new('Library/IME.dll', 'GetStateIME', '', 'l')
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
    Win32API.new('Library/IME.dll', 'ClearIME', 'l', '').call(i)
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