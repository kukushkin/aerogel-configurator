require 'aerogel/configurator'


config = Configurator.load File.dirname( __FILE__ )+"/ex4.conf"

puts "before: #{config.path_to_file}"
config.root_path = "/B/C"
puts " after: #{config.path_to_file}"
