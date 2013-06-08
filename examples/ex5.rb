require 'aerogel/configurator'


config = Configurator.load File.dirname( __FILE__ )+"/ex5.conf"

puts config.current.time
sleep 1
puts config.current.time
sleep 1
puts config.current.time