# encoding: utf-8

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