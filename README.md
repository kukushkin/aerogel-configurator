# Configurator
Configuration files for Ruby applications made easy.

* Does not mess with environment. No global variables, no modified core classes.
* Use simple yet flexible DSL to define your configuration
parameters.
* Load configuration from multiple files or ruby *Hash*es.
* No external dependencies.

## Installation
Add this line to your application's Gemfile:
```ruby
gem 'aerogel-configurator'
```

And then execute:
```
$ bundle
```

Or install it yourself as:
```
$ gem install aerogel-configurator
```

## Usage

### 1. Simple config files
Store your configuration parameters in a separate file
using simple DSL:
```ruby
# my.conf
foo 'bar'

group {
    # use block syntax to create groups of parameters...
    a 1
    b {
        # ...and nested groups
        c true
    }
}
```

Then load configuration file and access parameters:
```ruby
# my_app.rb
require 'aerogel/configurator'

config = Configurator.new "my.conf"

# using simple chainable syntax:
config.foo # => 'bar'
config.group.a # => 1
config.group.b.c # => true

# accessing underlying Hash:
config.to_hash # => { :foo => 'bar', :group => { ... } }
config.group.to_hash # => { :a => 1, :b => { :c => true } }

# accessing undefined parameter will not return nil:
config.foobar # => Configurator::Parameter::Undefined
# however:
config.foobar.nil? # => true

```

### 2. Setting configuration parameters in your ruby code
You can totally skip the config files —
create an empty Configurator object and populate it yourself
using chainable parameter access methods:
```ruby
# my_app.rb
require 'aerogel/configurator'

config = Configurator.new

config.a.b.c = 'hello'
config.a.b.c # => 'hello'

# or alternatively assigning Hashes as groups of parameters
config.group = { :foo => 123, :bar => 'abc' }
config.group.foo # => 123
```

### 3. Loading configuration from multiple sources
Is your configuration stored in several config files? No worry, you can load them one-by-one and all the parameters will be deep-merged.
```ruby
# my_defaults.conf
a 123
b {
  c 'hello'
}
```
```ruby
# my_config.conf
a 456
b {
  d {
    e 'abc'
  }
}
```
```ruby
# my_app.rb
require 'aerogel/configurator'

config = Configurator.new
config.load "my_defaults.conf"
config.load "my_config.conf"

config.a # => 456
config.b.c # => 'hello'
config.b.d.e # => 'abc'

```

### 4. Loading configuration from a Hash
Use Hash as a source for your configuration parameters with any call
to ```#new``` or ```#load```:
```ruby
# my_app.rb
require 'aerogel/configurator'

DEFAULTS = {
  :a => 'hello',
  :foo => {
    :bar => 'abc'
  }
}

config = Configurator.new DEFAULTS

config.foo.bar # => 'abc'
```

### 5. DSL: Using previously defined parameters
In a config file you can access previously defined parameters:
```ruby
# my.conf
value1 'abc'
value2 value1 # will refer to 'value1' at previous line

# you can even access parameters from elsewhere,
# assuming they are defined at the moment of loading 'my.conf'
value3 previously.defined.one
```
```ruby
# my_app.rb
require 'aerogel/configurator'

config = Configurator.new

# this should be defined before loading "my.conf"
config.previously.defined.one = 123

config.load "my.conf"

config.value2 # => 'abc'
config.value3 # => 123
```

### 6. DSL: Deferred parameters
But what if you need to reuse the parameter value, that may change after the config file is loaded? There is a way to do exactly that and more — *deferred parameters*, using ```lambda{}``` syntax.
```ruby
# my.conf
logging {
    filename lambda{ app_root+"/log/my_app.log" }
}
```
```ruby
# my_app.rb
require 'aerogel/configurator'

# first, configuration file is loaded
config = Configurator.new "my.conf"

# then goes some code ...

# then app_root is set
config.app_root = "/path/to/my_app"

# and the result is
config.logging.filename # => "/path/to/my_app/log/my_app.log"
```

A deferred parameter is re-evaluated each time it is accessed.

### 7. Config files are Ruby
So you can do virtually anything.
```ruby
# my.conf
if environment == :release
    debug false
    logging :warn
else
    debug true
    logging :debug
end
```
```ruby
# my_app.rb
require 'aerogel/configurator'

config = Configurator.new
config.environment = :release
config.load "my.conf"

config.debug # => false
```

### 8. Loading from YAML
Although not directly supported by Configurator, you can store configuration in a YAML file and load it as Hash:
```yaml
# my.yml
# Note the Symbol keys, not strings
:foo: 123
:bar: 'abc'
```
```ruby
# my_app.rb
require 'aerogel/configurator'
require 'yaml'

config = Configurator.load YAML.load_file("my.yml")
config.foo # => 123
config.bar # => 'abc'
```

### 9. More examples?
See ```examples/``` folder.

## Feedback

Any feedback is really appreciated.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
