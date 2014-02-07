class Configurator
private
  class Parameter

    METHOD_NAME_REGEXP = /^([^\[\]=!?]*)[\[\]=!?]?$/

    def initialize( data = {}, fullname = "" )
      @data = data
      @fullname = fullname
    end

    def method_missing(method, *args)
      param_name = method.to_s.match(METHOD_NAME_REGEXP)[1].to_sym
      force_value = false
      force_boolean = false
      # puts "Parameter.method_missing: #{@fullname}.#{method} '(#{param_name}) in #{@data}"
      if method.to_s =~ /=$/
        return @data[param_name] = args.first
      elsif method.to_s =~ /\!$/
        force_value = true
      elsif method.to_s =~ /\?$/
        force_boolean = true
      end

      # evaluate param
      if @data[param_name].is_a?(Hash)
        force_boolean ? true : Parameter.new( @data[param_name], "#{@fullname}.#{param_name}" )
      elsif @data[param_name].nil?
        raise ArgumentError.new "Undefined parameter: #{@fullname}.#{param_name}" if force_value
        force_boolean ? false : Undefined.new( @data, [param_name], "#{@fullname}.#{param_name}" )
      elsif @data[param_name].is_a? Proc
        force_boolean ? !!@data[param_name].call : @data[param_name].call
      else
        # it's a leaf
        force_boolean ? !!@data[param_name] : @data[param_name]
      end
    end

    def respond_to?( method, include_private = false )
      super || respond_to_missing?( method, include_private )
    end

    # any valid identifier ending with '=', '!' or '?' is a valid method
    def respond_to_missing?( method, include_private = false )
      super || (method.to_s =~ METHOD_NAME_REGEXP ) || true
    end

    def raw
      @data
    end

    def to_hash
      @data
    end

    def inspect
      @data.inspect
    end

    # Iterates over parameter group.
    #
    def each( &block )
      @data.keys.each do |method|
        value = send method
        yield method, value
      end
    end

    # Undefined is a parameter that was not set yet.
    # It allows accessing its sub-parameters and defines the entire
    # chain once an assignement method on a sub-parameter is called.
    #
    # +root+ is where parameter will be 'mounted' on assignement
    # +name+ is an Array of chained names starting from mount point
    #
    class Undefined
      def initialize( root, name, fullname )
        # puts "Undefined.new: root=#{root} name=#{name.to_s} "
        @root = root
        @name = name # convert to array
        @fullname = fullname
      end

      def method_missing(method, *args)
        param_name = method.to_s.match(METHOD_NAME_REGEXP)[1].to_sym
        # puts "Undefined.method_missing: #{method} root=#{@root} names=#{@names}"
        if method.to_s =~ /!$/
          raise ArgumentError.new "Undefined parameter: #{@fullname}.#{param_name}"
        elsif method.to_s =~ /\?$/
          false
        elsif method.to_s =~ /=$/
          method = method.to_s.match(/^(.*)=$/)[1].to_sym
          # deep assign
          d = ( @root[@name.shift] ||= {} )
          @name.each do |n|
            d = ( d[n] ||= {} )
          end
          d[method] = args.first
        else
          Undefined.new( @root, @name+[method], "#{@fullname}.#{@name.shift}" )
        end
      end

      def defined?; false; end
      def nil?; true; end
      def empty?; true; end
      def to_s; ''; end
      def raw; nil; end

      # to_ary defined basically to keep rspec happy
      def to_ary; []; end

    end # class Undefined

  end # class Parameter


end # class Configurator
