require 'configurator'


config = Configurator.load File.dirname( __FILE__ )+"/ex2.conf"

puts "config: #{config.to_hash}"
