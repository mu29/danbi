#────────────────────────────────────────────────────────────────────────────

# ▶ Map Extractor

# --------------------------------------------------------------------------

# Author    뮤 (mu29gl@gmail.com)

# Date      2015. 1. 23

#────────────────────────────────────────────────────────────────────────────



def blockMapExtract

  $data_tilesets = load_data("Data/Tilesets.rxdata")

  Game.init

  Dir.mkdir("./Map") if !FileTest.exist?("./Map")

  map_infos = load_data('Data/MapInfos.rxdata')

  map_infos.each do |k, v|

    Game.map.setup(k)

    mapfile = sprintf("Map/Map%d.map", k)

    File.open(mapfile, "w") do |fw|

      writeMapData(fw, k, v)

    end

  end

  print "맵 데이터 추출 완료"

  exit

end



def writeMapData(fw, id, info)

  map = load_data(sprintf("Data/Map%03d.rxdata", id))

  fw.write("#{id},#{info.name},#{Game.map.width},#{Game.map.height},")

  for y in 0...(Game.map.height)

    for x in 0...(Game.map.width)

      flag = Game.map.passable?(x, y, 0) ? 0 : 1

      fw.write("#{flag},")

    end

  end

end



blockMapExtract if Config::EXTRACT_MAP