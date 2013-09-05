
class Configurator

  attr_accessor :params
  # alias_method :to_hash, :params

  # Creates a Configurator object and loads parameters from optionally provided +source+.
  # +source+ is either a String which is treated as a name of config file
  # or a Hash
  #
  def initialize( source = nil )
    @params = {}
    load source unless source.nil?
  end


  def method_missing(method, *args, &block)
    # puts "Configurator.method_missing: #{method}"
    Parameter.new( @params ).send method, *args, &block
  end

  def respond_to?(method, include_private = false)
    super || Parameter.new( @params ).respond_to?(method, include_private)
  end

  # Loads parameters from +source+.
  # +source+ is either a String which is treated as a name of config file
  # or a Hash
  #
  def load( source )
    if source.is_a? String
      filename_contents = File.read source
      DSL.new( filename_contents, @params )
    elsif source.is_a? Hash
      deep_merge( @params, source)
    else
      raise ArgumentError.new("Invalid source passed to #load method")
    end
    true
  end

  # Clears parameters
  #
  def clear!
    @params = {}
  end

  # Creates a Configurator object and loads parameters from given file or a Hash.
  #
  # Returns a created object with parameters loaded into it.
  #
  def self.load( source )
    config = self.new source
    return config
  end

private

  # Deep merge parameters hash with +other+ hash.
  #
  def deep_merge( left, right )
    right.each do |key, value|
      if value.is_a? Hash
        left[key] ||= {}
        deep_merge( left[key], right[key] )
      else
        left[key] = right[key]
      end
    end
  end

end # class Configurator
