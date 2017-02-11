#────────────────────────────────────────────────────────────────────────────

# * FileTest, jubin, 2014. 12. 29

#────────────────────────────────────────────────────────────────────────────



module FileTest

  module_function

  

  def exist?(filename)

    PathFileExists.call(filename.to_m) == 0x1

  end

  

  def directory?(filename)

    PathIsDirectory.call(filename.to_m) == 0x10

  end

  

  def file?(filename)

    PathIsDirectory.call(filename.to_m) == 0

  end

  

  def size(filename)

    h = CreateFile.call(filename.to_m, 0x80000000, 0, 0, 3, 0, 0)

    size = GetFileSize.call(h, 0)

    CloseHandle.call(h)

    size

  end

end