require 'aerogel/configurator'


config = Configurator.load File.dirname( __FILE__ )+"/ex3.conf"

puts "config: #{config.to_hash}"
