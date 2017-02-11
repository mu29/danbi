# encoding: utf-8

$:.push(Dir.pwd)

require "zlib"

def load_data(filename)
  File.open(filename, "rb") { |f|
    obj = Marshal.load(f)
  }
end

data = load_data("Data/Scripts.rxdata")

for i in 0...data.size
	name = data[i][1].force_encoding("UTF-8")
	script = Zlib::Inflate.inflate(data[i][2]).force_encoding("UTF-8")
	Dir.mkdir("update_log") rescue nil
	name.gsub!("\\", "￦")
	name.gsub!("/", "／")
	name.gsub!(":", "：")
	name.gsub!("*", "＊")
	name.gsub!("?", "？")
	name.gsub!("\"", "＂")
	name.gsub!("<", "〈")
	name.gsub!(">", "〉")
	name.gsub!("|", "｜")
	#name.gsub!(" ", "")
	filename = sprintf("update_log/%03d_#{name}.rb", i)
	f = File.open(filename, "wb")
	f.write(script.gsub("\r", "\r\n"))
	f.close
end
