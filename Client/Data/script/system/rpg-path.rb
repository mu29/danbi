# encoding: utf-8

#────────────────────────────────────────────────────────────────────────────
# * RTP, joe59491
#────────────────────────────────────────────────────────────────────────────
module RPG::Path
  
  module_function

  def findP(*paths)
    for p in paths
      findFileData = Win32API::FindFirstFile.call(p.to_unicode)
      unless findFileData == "" # INVALID_HANDLE_VALUE
        return File.dirname(p) + "/" + findFileData
      end
    end
    return ""
  end

  def RTP(path)
    @list ||= Hash.new
    return @list[path] if @list.include?(path)
    check = File.extname(path).empty?
    rtp = []
    for i in 0...3
      unless $RTP[i].empty?
        rtp.push($RTP[i] + path)
        if check
          rtp.push($RTP[i] + path + ".*")
        end
      end
    end
    pa = findP(*rtp)
    if pa == ""
      @list[path] = path
    else
      @list[path] = pa
    end
    return @list[path]
  end
end