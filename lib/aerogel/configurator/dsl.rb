class Configurator
private

  class DSL
    attr_accessor :params

    # +source+ can be either Hash (preprocessed parameters),
    #   Block (a nested block to be invoked in a context of the object)
    #   or a String (a config file contents to be evaluated in a context of the object)
    def initialize( source, root = nil )
      # @root = root || self
      @params = {}
      @root = root || @params
      if source.is_a? Hash
        @params = source
      elsif source.is_a? String
        self.instance_eval( source )
      else
        self.instance_eval( &source )
      end
    end

    def method_missing( method, *args, &block )
      if (not block_given?) && (args.empty?)
        # puts "DSL: get '#{method}' params:#{@params}"
        Parameter.new( @root ).send method, *args
      elsif block_given?
        nested_set = DSL.new( block, @root )
        @params[method] = nested_set.params
      elsif args.size > 1
        @params[method] = args
      else
        @params[method] = args.first
      end
    end

  end # class DSL
end # class Configurator

