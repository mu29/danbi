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

    check RegOpenKeyEx.call(hkey, name, opt, desired, result)

    @reg_jb = unpackdw(result)

  end

  

  def QueryValue(hkey, name)

    size = [256].pack('l')

    data = "\0" * 256

    RegQueryValueExW.call(hkey, name.to_unicode, 0, 0, data, size)

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