require 'aerogel/configurator'
require 'yaml'

config = Configurator.load YAML.load_file(File.dirname( __FILE__ )+"/ex7.yml")
puts "config.foo: #{config.foo}"
puts "config.bar: #{config.bar}"
