require 'aerogel/configurator'

def test( config, param_chain )
  config_param = "config.#{param_chain}"
  begin
    value = eval config_param
    puts "#{config_param}: #{value.inspect}"
  rescue StandardError => e
    puts "#{config_param}: <error>: #{e}"
  end
end

config = Configurator.load File.dirname( __FILE__ )+"/ex10.conf"


puts "config: #{config.to_hash}"

test config, "foo!"
test config, "foo?"
test config, "bar!"
test config, "bar?"
test config, "foobar!"
test config, "foobar?"
test config, "fuu!"
test config, "fuu?"
test config, "fuu.fuu.fuu!"
test config, "fuu.fuu.fuu?"
