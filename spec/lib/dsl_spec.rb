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

  describe "<param>! method" do
    it "should be provided for existing and non-existing parameters" do
      config = Configurator.load test_filename('conf/f.conf')
      config.should respond_to(:foo!)
      config.should respond_to(:nofoo!)
    end

    it "should return parameter value for existing parameter" do
      config = Configurator.load test_filename('conf/f.conf')
      config.foo!.should eql("hello")
    end

    it "should raise ArgumentError for undefined parameter" do
      config = Configurator.load test_filename('conf/f.conf')
      expect { config.nofoo! }.to raise_error(ArgumentError)
    end

    it "should work at the end of a chain of undefined parameters" do
      config = Configurator.load test_filename('conf/f.conf')
      expect { config.nofoo.nofoo }.not_to raise_error
      expect { config.nofoo.nofoo! }.to raise_error(ArgumentError)
    end
  end

  describe "<param>? method" do
    it "should be provided for existing and non-existing parameters" do
      config = Configurator.load test_filename('conf/f.conf')
      config.should respond_to(:foo?)
      config.should respond_to(:nofoo?)
    end

    it "should return value coerced to Boolean for existing parameter" do
      config = Configurator.load test_filename('conf/f.conf')
      config.foo?.should be true
      config.bar?.should be true
      config.foobar?.should be false
    end

    it "should return false for non-existing parameter" do
      config = Configurator.load test_filename('conf/f.conf')
      config.nofoo?.should be false
    end

    it "should work at the end of a chain of undefined parameters" do
      config = Configurator.load test_filename('conf/f.conf')
      config.nofoo.nofoo.should be_nil
      config.nofoo.nofoo?.should be false
    end

  end

end # describe Configurator::DSL