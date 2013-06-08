require 'aerogel/configurator'

unless ARGV.size == 1
  puts "Usage: #{__FILE__} <release|development>"
  exit
end


config = Configurator.new
config.environment = ARGV.first.to_sym
config.load File.dirname( __FILE__ )+"/ex6.conf"

puts "config: #{config.to_hash}"
