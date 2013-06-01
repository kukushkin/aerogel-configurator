# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aerogel/configurator/version'

Gem::Specification.new do |spec|
  spec.name          = "aerogel-configurator"
  spec.version       = Configurator::VERSION
  spec.authors       = ["Alex Kukushkin"]
  spec.email         = ["alex@kukushk.in"]
  spec.summary       = %q{Simple configuration files for Ruby applications}
  spec.description   = %q{Store your application configuration in separate files using simple DSL or YAML. Access your configuration settings in a simple way}
  spec.homepage      = "https://github.com/kukushkin/aerogel-configurator"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end