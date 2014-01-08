# coding: us-ascii
# Copyright (c) 2012 Kenichi Kamiya

module Net; module IPAddress

  # Called "octets" is expected a FixedArray the 4 length,
  # that's members 0~255 Fixnum.
  # And the "mask_octets" is same format with the octets.
  # @see #octets, #mask_octets
  def initialize(octets, mask_octets=self.class::FULL_MASK)
    raise InvalidAddress unless valid_octets? octets
    raise TypeError unless valid_octets? mask_octets

    @octets, @mask_octets = octets.dup.freeze, mask_octets.dup.freeze
  end

  # @return [Array<Fixnum>]
  # @example 
  #   IPAddress('192.168.1.1/24').octets #=> [192, 168, 1 ,1]
  def octets
    @octets.dup
  end

  alias_method :bytes, :octets

  # @return [Array<Fixnum>]
  # @example 
  #   IPAddress('192.168.1.1/24').mask_octets #=> [255, 255, 255, 0]
  def mask_octets
    @mask_octets.dup
  end

  alias_method :netmask, :mask_octets
  
  # @return [Array<Fixnum>]
  # @example 
  #   IPAddress('192.168.1.1/24').bits
  #    #=> [1, 1, 0, 0, 0, 0, 0, 0,
  #         1, 0, 1, 0, 1, 0, 0, 0,
  #         0, 0, 0, 0, 0, 0, 0, 1,
  #         0, 0, 0, 0, 0, 0, 0, 1]
  def bits
    _bits.dup
  end

  alias_method :netmask, :mask_octets

  def ipaddress?
    true
  end

  # @return [self]
  def to_ipaddress
    self
  end

  # @return [0, 1, nil]
  def <=>(other)
    family?(other) ? (@octets <=> other.octets) : nil
  end

  def eql?(other)
    family?(other) && (values == other.values)
  end

  alias_method :==, :eql?

  # @return [Number]
  def hash
    values.hash
  end

  # @return [self]
  def freeze
    memorize
    super
  end
  
  # @return [Boolean]
  def ===(other)
    cover? other
  end

  # @return [String]
  # @example
  #   IPAddress('192.168.1.1').big_endian #=> "\xC0\xA8\x01\x01"
  def big_endian
    @octets.pack 'C4'
  end

  alias_method :byte_order, :big_endian

  # @return [Range]
  def to_range
    network..last
  end

  # @todo
  # @return [Integer]
  def space
    hosts(true).to_a.size
  end

  # @todo
  # @return [Integer]
  def host_counts
    hosts.to_a.size
  end
  
  # @param contain_network [Boolean]
  # @return [self]
  def each_host(contain_network=false, &block)
    return to_enum(__callee__, contain_network) unless block_given?

    range = (contain_network ? network : network.next)...last
    range.__send__ :each, &block
  end

  alias_method :hosts, :each_host

  # @return [self]
  def each_address(&block)
    return to_enum(__callee__) unless block_given?

    to_range.__send__ :each, &block
  end

  alias_method :addressies, :each_address
  
  private
  
  def valid_octets?(octets)
    (octets.length == self.class::FULL_MASK.length) && 
      octets.all?{|oct|(0..255).cover?(oct) && oct.integer?}
  rescue NoMethodError
    false
  end
  
  def memorize
    values
    _bits
    to_i
    nil
  end

end; end
