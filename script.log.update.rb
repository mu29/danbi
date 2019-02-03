# encoding: utf-8

app_path = File.dirname(__FILE__)

require "zlib"

def load_data(filename)
  File.open(filename, "rb") { |f|
    obj = Marshal.load(f)
  }
end

def create_log(filename, logname)

	data = load_data(filename)

	log = ""

	for i in 0...data.size
		script = Zlib::Inflate.inflate(data[i][2]).force_encoding("UTF-8")
		script.gsub!("\r\n", "\n")
		log << script + "\n"
	end

	filename = sprintf(logname, i)
	f = File.open(filename, "wb")
	f.write(log)
	f.close

end

create_log(app_path + "/Client/Data/Scripts.rxdata", app_path + "/script.log.rb")

puts "finished"