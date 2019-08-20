# encoding: utf-8

$:.unshift << File.dirname(__FILE__)

require "zlib"
require "fileutils"

def load_data(filename)
  File.open(filename, "rb") { |f|
    obj = Marshal.load(f)
  }
end

def create_require_script(load_filename, save_filename)
  new_script = []
	original_script = load_data(load_filename)
	for i in 0...original_script.size
    script = original_script[i].dup
		content = Zlib::Inflate.inflate(script[2]).force_encoding("UTF-8")
		if content =~ /# filename (.*)\r\n/
      content = "require \"#{$1}\""
		end
    script[2] = Zlib::Deflate.deflate(content)
    new_script.push(script)
  end
  obj = Marshal.dump(new_script)
  output = File.new(save_filename, "wb+")
  output.write(obj)
  output.close
end

def create_require_to_content(load_filename, save_filename, load_path)
  new_script = []
  original_script = load_data(load_filename)
  for i in 0...original_script.size
    script = original_script[i].dup
    content = Zlib::Inflate.inflate(script[2]).force_encoding("UTF-8")
    if content =~ /require \"(.*)\"/
      s = File.read("#{load_path}/#{$1}")
      content = s
    end
    script[2] = Zlib::Deflate.deflate(content)
    new_script.push(script)
  end
  obj = Marshal.dump(new_script)
  output = File.new(save_filename, "wb+")
  output.write(obj)
  output.close
end

# require version to compress version
create_require_to_content("Client/Data/Scripts.rxdata", "Client/Data/Scripts-extract.rxdata", "Client/Data/script")