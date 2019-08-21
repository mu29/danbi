# encoding: utf-8

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