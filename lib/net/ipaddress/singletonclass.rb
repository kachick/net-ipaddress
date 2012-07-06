# Copyright (c) 2012 Kenichi Kamiya

module Net; module IPAddress; class << self

  # @param [String] str
  # @return [IPAddress]
  def parse(str)
    construct __callee__, str.to_str
  end
  
  # @param [String] str
  # @return [IPAddress]
  def parse_big_endian(str)
    construct __callee__, str.to_str
  end

  alias_method :parse_byte_order, :parse_big_endian
  
  # @param [Integer] int
  # @return [IPAddress]
  def for_integer(int, mask_int=nil)
    construct __callee__, int, mask_int
  end
  
  alias_method :for_i, :for_integer
  
  # @abstract
  def valid?(obj)
    case obj
    when String
      valid_string? obj
    when Integer
      valid_integer? obj
    else
      false
    end
  end

  # @abstract
  def valid_string?(str)
    concrete_classies.any?{|klass|klass.__send__ __callee__, str}
  end
  
  # @abstract
  def valid_integer?(int)
    concrete_classies.any?{|klass|klass.__send__ __callee__, int}
  end

  private
  
  def concrete_classies
    [Version4, Version6]
  end

  def construct(constructor, *sources)
    concrete_classies.each do |klass|
      begin
        instance = klass.__send__ constructor, *sources
      rescue InvalidAddress
        next
      else
        return instance
      end
    end
  
    raise InvalidAddress
  end

end; end; end
