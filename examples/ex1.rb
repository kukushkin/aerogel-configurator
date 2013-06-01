require 'aerogel/configurator'

config = Configurator.new

config.a.foo.bar = "hello"

puts "config: #{config.to_hash}"
