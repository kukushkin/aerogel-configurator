require 'rubygems'
require 'rspec'

require File.join(File.dirname(__FILE__), '..', 'lib', 'configurator')

def test_filename( name )
  File.expand_path( File.join( File.dirname(__FILE__), name ))
end