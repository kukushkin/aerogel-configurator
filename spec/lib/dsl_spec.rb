require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "Configurator::DSL" do

  it "should allow nested groups" do
    config = Configurator.load test_filename('conf/c.conf')
    config.a.b.c.should eql "foo"
  end

  it "should handle deferred parameters" do
    config = Configurator.load test_filename('conf/d.conf')
    config.foo.should eql "fuu"
    config.bar.should eql "fuubar"
    config.foo = "foo"
    config.bar.should eql "foobar"
  end

  it "should allow reuse of parameters" do
    config = Configurator.new :bar => '123'
    config.load test_filename('conf/e.conf')
    config.foo.should eql "hello"
    config.bar.should eql "hello"
  end

end # describe Configurator::DSL