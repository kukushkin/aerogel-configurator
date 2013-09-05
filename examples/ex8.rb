require 'aerogel/configurator'


config = Configurator.load File.dirname( __FILE__ )+"/ex8.conf"


puts "config: #{config.to_hash}"

puts "config.each:"
config.each do |name, value|
  puts "#{name}: #{value}"
end
