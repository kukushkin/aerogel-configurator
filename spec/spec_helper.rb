require 'rubygems'
require 'rspec'

require File.join(File.dirname(__FILE__), '..', 'lib', 'aerogel', 'configurator')

def test_filename( name )
  File.expand_path( File.join( File.dirname(__FILE__), name ))
end