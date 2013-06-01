
class Configurator

  attr_accessor :params
  # alias_method :to_hash, :params

  # Creates a Configurator object and set default parameters.
  #
  def initialize( opts = {} )
    raise ArgumentError.new("Invalid parameters passed to Configurator.new") unless opts.is_a? Hash
    @params = opts.dup
  end


  def method_missing(method, *args)
    # puts "Configurator.method_missing: #{method}"
    Parameter.new( @params ).send method, *args
  end

  # Loads contents of a configuration file into an existing Configurator object.
  #
  def load( filename )
    filename_contents = File.read filename
    cfg = DSL.new( filename_contents, @params )
    deep_merge( @params, cfg.params )
  end

  # Clears parameters
  #
  def clear!
    @params = {}
  end

  # Creates a Configurator object and loads parameters from given file.
  #
  # Returns a created object with parameters loaded into it.
  #
  def self.load( filename )
    config = self.new {}
    config.load filename
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
