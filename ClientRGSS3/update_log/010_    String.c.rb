#────────────────────────────────────────────────────────────────────────────

# * String, 66rpg, joe59491, 2015. 01. 19

#

#   "가".to_m       => "\260\241"

#   "\260\241".to_u => "가"

#────────────────────────────────────────────────────────────────────────────



class String

  

  CP_UTF8 = 65001

  

  def to_u

    len = MultiByteToWideChar.call(0, 0, self, -1, nil, 0)

    buf = "\0" * (len*2)

    MultiByteToWideChar.call(0, 0, self, -1, buf, buf.size/2)

    len = WideCharToMultiByte.call(CP_UTF8, 0, buf, -1, nil, 0, nil, nil)

    ret = "\0" * (len*2)

    WideCharToMultiByte.call(CP_UTF8, 0, buf, -1, ret, ret.size, nil, nil)

    return ret.unpack('C*').select{|s| s != 0}.pack('C*')

  end

  

  def to_m

    len = MultiByteToWideChar.call(CP_UTF8, 0, self, -1, nil, 0)

    buf = "\0" * (len*2)

    MultiByteToWideChar.call(CP_UTF8, 0, self, -1, buf, buf.size/2)

    len = WideCharToMultiByte.call(0, 0, buf, -1, nil, 0, nil, nil)

    ret = "\0" * len

    WideCharToMultiByte.call(0, 0, buf, -1, ret, ret.size, nil, nil)

    return ret

  end



  #--------------------------------------------------------------------------

  # ● 유니 코드 문자열 인코딩 후 루비 UTF-8 문자열 객체를 (자체)를 돌려줍니다

  #--------------------------------------------------------------------------

  def to_unicode

    len = MultiByteToWideChar.call(CP_UTF8, 0, self, -1, 0, 0) << 1

    buf = "\0" * len

    # CP_UTF8 : UTF-8 문자 세트 인코딩 (코드 페이지)

    MultiByteToWideChar.call(CP_UTF8, 0, self, -1, buf, len)

    return buf

  end

  #--------------------------------------------------------------------------

  # ● 반환 값은 UTF-8 문자열을 디코딩 한 후 유니 코드 문자열 개체 (자체)로 인코딩됩니다

  #--------------------------------------------------------------------------

  def to_UTF8

    len = WideCharToMultiByte.call(CP_UTF8, 0, self, -1, 0, 0, 0, 0)

    buf = "\0" * len

    WideCharToMultiByte.call(CP_UTF8, 0, self, -1, buf, len, 0, 0)

    # 제거 '\0' 문자열 터미네이터 (때문에 만 루비 문자열 변환 후)

    buf.slice!(-1, 1)

    return buf

  end



  def to_b

    return self == 'true'

  end

end