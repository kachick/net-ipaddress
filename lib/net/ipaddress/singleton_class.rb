# Copyright (c) 2012 Kenichi Kamiya

module Net; module IPAddress; class << self

  # @return [Version4, Version6]
  def parse(str)
    construct __callee__, str
  end

  # @return [Version4, Version6]
  def parse_big_endian(str)
    construct __callee__, str
  end

  alias_method :parse_byte_order, :parse_big_endian

  # @abstract
  def valid?(str)
    concrete_classies.any?{|klass|klass.valid? str}
  end

  private
  
  def concrete_classies
    [Version4, Version6]
  end

  def construct(constructor, source)
    concrete_classies.each do |klass|
      begin
        instance = klass.__send__ constructor, source
      rescue InvalidAddress
        next
      else
        return instance
      end
    end
  
    raise InvalidAddress
  end

end; end; end
