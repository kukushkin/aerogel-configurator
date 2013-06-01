require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Configurator do

  before(:all) do
    @default_params = {
      :foo => "abc",
      :bar => 123,
      :group => {
        :a => 1,
        :b => 2
      }
    }
  end

  it "should respond to 'load' and return a Configurator instance" do
    Configurator.should respond_to(:load)
    Configurator.load( test_filename( 'conf/a.conf' ) ).should be_instance_of Configurator
  end

  describe ".new" do

    it 'should allow no parameters' do
      config = nil
      expect { config = Configurator.new }.to_not raise_error
      config.params.should be_empty # empty Hash
    end
    it 'should accept Hash as a set of default parameters' do
      config = nil
      expect { config = Configurator.new @default_params }.to_not raise_error
    end
  end

  describe ".load" do
    it "should load parameters from a configuration file" do
      config = Configurator.load( test_filename( 'conf/a.conf' ) )
      config.should be_instance_of Configurator
      config.params.should eql( {:foo=>"hello", :bar=>42.0} )
    end
  end

  describe "#params" do
    it 'should provide access to raw parameters' do
      config = Configurator.new @default_params
      config.should respond_to(:params)
      config.params.should eql( @default_params )
    end
  end

  describe "method chaining" do
    it 'should allow access to parameters and nested parameters for retrieval' do
      config = Configurator.new @default_params
      config.foo.should eql "abc"
      config.bar.should eql 123
      config.fuu.should be_nil
      config.group.a.should eql 1
      config.group.b.should eql 2
      config.group.c.should be_nil
    end
    it 'should allow storing new parameters and nested parameters' do
      config = Configurator.new
      config.foo.should be_nil
      expect do
        config.foo = "abc"
        config.bar = 123
        config.group.a = 1
        config.group.b = 2
      end.not_to raise_error
      config.foo.should eql "abc"
      config.bar.should eql 123
      config.fuu.should be_nil
      config.group.a.should eql 1
      config.group.b.should eql 2
      config.group.c.should be_nil
    end
  end

  describe "instance" do
    it { should respond_to :load }
    it "should load parameters" do
      config = Configurator.new
      config.params.should eql({})
      config.load test_filename( 'conf/a.conf' )
      config.params.should eql( {:foo=>"hello", :bar=>42.0} )
    end
    it "should load and overwrite only defined members" do
      config = Configurator.new @default_params
      config.foo.should eql "abc"
      config.bar.should eql 123
      config.group.a.should eql 1
      config.group.b.should eql 2
      config.load test_filename( 'conf/b.conf' )
      config.foo.should eql "hello"
      config.bar.should eql 123 # not overwritten
      config.group.a.should eql 123
      config.group.b.should eql 2 # not overwritten
    end

    it { should respond_to :clear! }
    it "should clear all parameters on request" do
      config = Configurator.new @default_params
      config.foo.should eql "abc"
      config.clear!
      config.params.should eql({})
    end

    it "should respond to #to_hash on each level" do
      config = Configurator.new @default_params
      expect { config.to_hash }.to_not raise_error
      config.to_hash.should be_instance_of Hash
      config.to_hash.should eql @default_params
      config.group.to_hash.should be_instance_of Hash
      config.group.to_hash.should eql @default_params[:group]
    end

  end
end # describe Configurator

