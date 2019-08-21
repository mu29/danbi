# encoding: utf-8

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