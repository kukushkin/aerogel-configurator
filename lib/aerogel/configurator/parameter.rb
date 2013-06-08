class Configurator
private
  class Parameter

    def initialize( data = {} )
      @data = data
    end

    def method_missing(method, *args)
      # puts "Parameter.method_missing: '#{method}' in #{@data}"
      if method.to_s =~ /=$/
        @data[method.to_s.match(/^(.*)=$/)[1].to_sym] = args.first
      elsif @data[method].is_a?(Hash)
        Parameter.new @data[method]
      elsif @data[method].nil?
        Undefined.new @data, [method]
      elsif @data[method].is_a? Proc
        @data[method].call
      else
        # it's a leaf
        @data[method]
      end
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

    # Undefined is a parameter that was not set yet.
    # It allows accessing its sub-parameters and defines the entire
    # chain once an assignement method on a sub-parameter is called.
    #
    # +root+ is where parameter will be 'mounted' on assignement
    # +name+ is an Array of chained names starting from mount point
    #
    class Undefined
      def initialize( root, name )
        # puts "Undefined.new: root=#{root} name=#{name.to_s} "
        @root = root
        @name = name # convert to array
      end

      def method_missing(method, *args)
        # puts "Undefined.method_missing: #{method} root=#{@root} names=#{@names}"
        if method.to_s =~ /=$/
          method = method.to_s.match(/^(.*)=$/)[1].to_sym
          # deep assign
          d = ( @root[@name.shift] ||= {} )
          @name.each do |n|
            d = ( d[n] ||= {} )
          end
          d[method] = args.first
        else
          Undefined.new( @root, @name+[method])
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
