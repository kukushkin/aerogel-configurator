# Configurator

Configuration files for Ruby applications made easy.

## Installation

Add this line to your application's Gemfile:

    gem 'rb-configurator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rb-configurator

## Usage

Configuration parameters as chain:

    config = Configurator.load "my.conf"

    config.group.a # => 1

Configuration is a HASH:

    config = Configurator.load "my.conf"

    config['group'] # => { :a => 1, :b => 2 }

Store your configuration in the separate file(s) using simple DSL:

    # my.conf
    foo "hello"
    bar 42
    a_group {
      boolean_param true
      a_nested_group {
        inner bar
        ar_var [1, 2, "three"]
      }
    }


Load configuration file(s) in your application:

    require 'configurator'
    config = Configurator.load "my.conf"

    # Access settings:
    puts config.foo # => "hello"
    puts config.a_group.a_nested_group.inner # => 42


TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
