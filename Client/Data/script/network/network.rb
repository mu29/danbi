# encoding: utf-8

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

  WSADATA = Struct.new(:w_version, :w_high_version, :sz_description, :sz_systemstatus)
  HOSTENT = Struct.new(:h_name, :h_aliases, :h_addrtype, :h_length, :h_addr_list)

  AF_INET = 2
  SOCK_STREAM = 1
  IPPROTO_TCP = 6

  @client_socket = -1

  def self.init
    @closesocket = Win32API.new('ws2_32', 'closesocket', 'p', 'l')
    @connect = Win32API.new('ws2_32', 'connect', 'ppl', 'l')
    @gethostbyname = Win32API.new('ws2_32', 'gethostbyname', 'p', 'l')
    @recv = Win32API.new('ws2_32', 'recv', 'ppll', 'l')
    @select = Win32API.new('ws2_32', 'select', 'lpppp', 'l')
    @send = Win32API.new('ws2_32', 'send', 'ppll', 'l')
    @socket = Win32API.new('ws2_32', 'socket', 'lll', 'l')
    @wsa_get_last_error = Win32API.new('ws2_32', 'WSAGetLastError', 'v', 'l')
    @wsa_startup = Win32API.new('ws2_32', 'WSAStartup', 'pp', 'i')
    @winsock = get_winsock(2, 2)
  end
  
  def self.get_winsock(major_ver, minor_ver)
    buf = "\0" * 390 #(2 + 2 + 256 + 1 + 128 + 1)
    ret = @wsa_startup.call([minor_ver, major_ver].pack('ll'), buf)
    wsa_data = WSADATA.new
    wsa_data.w_version = [buf[0].ord, buf[1].ord]
    wsa_data.w_high_version = [buf[2].ord, buf[3].ord]
    wsa_data.sz_description = buf[4, 256].delete("\0")
    wsa_data.sz_systemstatus = buf[261, 128].delete("\0")
    if ret != 0
      raise "Winsock #{major_ver}.#{minor_ver} 을 초기화할 수 없습니다. code: #{ret}"
    end
    if wsa_data.w_version != [minor_ver, major_ver]
      raise "지원하지 않는 버전의 Winsock 입니다."
    end
    return wsa_data
  end

  def self.close
    ret = @closesocket.call(@client_socket)
    raise_error if ret != 0
    return ret
  end
  
  def self.connect(ip, port)
    @client_socket = @socket.call(AF_INET, SOCK_STREAM, IPPROTO_TCP)
    raise_error if @client_socket == -1
    sockaddr = sockaddr_in(port, ip)
    ret = @connect.call(@client_socket, sockaddr, sockaddr.size)
    raise_error if ret == -1
    return ret
  end
  
  def self.gethostbyname(name)
    data = @gethostbyname.call(name)
    raise_error if data == 0
    host = data.ref(16).unpack('LLssL')
    hostent = HOSTENT.new
    hostent.h_name = host[0].ref(256)
    hostent.h_name = hostent.h_name[0..hostent.h_name.index("\0")]
    hostent.h_aliases = host[1]
    hostent.h_addrtype = host[2]
    hostent.h_length = host[3]
    hostent.h_addr_list = (host[4] + 8).ref(4).unpack("c*").pack("c*")
    return hostent
  end
  
  def self.recv(len, flags = 0)
    buf = "\0" * len
    len = @recv.call(@client_socket, buf, buf.size, flags)
    raise_error if len == -1
    return buf, len
  end
  
  def self.select(timeout)
    ret = @select.call(1, [1, @client_socket].pack('ll'), 0, 0, [timeout, timeout * 1000000].pack('ll'))
    raise_error if ret == -1
    return ret
  end
  
  def self.send(msg, flags = 0)
    ret = @send.call(@client_socket, msg, msg.size, flags)
    raise_error if ret == -1
    return ret
  end
  
  def self.sockaddr_in(port, host)
    return [AF_INET, port].pack('sn') + gethostbyname(host).h_addr_list + [].pack('x8')
  end
  
  def self.ready?
    if select(0) != 0
      return true
    end
    return false
  end
  
  def self.raise_error
    errno = @wsa_get_last_error.call
    case errno
    when 10053
      desc = "연결이 사용자의 호스트 시스템에 의해 중단되었습니다."

    when 10054
      desc = "서버에서 현재 연결을 강제로 끊었습니다."

    when 10061
      desc = "서버가 열리지 않아서 연결이 불가능 합니다."

    when 10065
      desc = "네트워크 장애등에 의해 서버와 연결이 불가능 합니다."
    
    when 10038
      return

    else
      desc = "시스템이 판단할 수 없는 에러입니다."
    end
    raise desc << " code: #{errno}"
  end
end