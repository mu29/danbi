# encoding: utf-8

$:.unshift << File.dirname(__FILE__)

require "zlib"
require "fileutils"

def load_data(filename)
  File.open(filename, "rb") { |f|
    obj = Marshal.load(f)
  }
end

def create_log(load_filename, save_dirname)
	FileUtils.rm_r(save_dirname) if File.directory?(save_dirname)
	FileUtils.mkdir_p(save_dirname)

	bin = load_data(load_filename)
	for script in bin
		script = Zlib::Inflate.inflate(script[2]).force_encoding("UTF-8")
		script.gsub!("\r\n", "\n")
		if script =~ /# filename (.*)$/
			if $1.include?("/")
				arr = $1.split("/")
				arr.pop
				FileUtils.mkdir_p("ScriptLog/" + arr.join("/"))
			end
			f = File.open("ScriptLog/#{$1}", "w")
			f.write(script)
			f.close
		end
	end
end

create_log("Client/Data/Scripts.rxdata", "ScriptLog")

puts "Log extraction is successfully finished."