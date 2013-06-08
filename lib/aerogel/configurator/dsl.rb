class Configurator
private

  class DSL
    attr_accessor :params

    # +source+ can be either Hash (preprocessed parameters),
    #   Block (a nested block to be invoked in a context of the object)
    #   or a String (a config file contents to be evaluated in a context of the object)
    # +root+ is a root hash, holding all parameters
    # +path+ is a part of root hash, which corresponds to current block
    def initialize( source, root = nil, path = nil )
      @root = root || {}
      @path = path.nil? ? @root : path
      if source.is_a? Hash
        @root = source
      elsif source.is_a? String
        self.instance_eval( source )
      else
        self.instance_eval( &source )
      end
      @params = @root
    end

    def method_missing( method, *args, &block )
      if (not block_given?) && (args.empty?)
        Parameter.new( @root ).send method, *args
      elsif block_given?
        # block is given, create new section or reuse previously created
        @path[method] ||= {}
        nested_set = DSL.new( block, @root, @path[method] )
      elsif args.size > 1
        @path[method] = args
      else
        @path[method] = args.first
      end
    end

  end # class DSL
end # class Configurator

