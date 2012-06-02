# Copyright (c) 2012 Kenichi Kamiya

module Net::IPAddress

  # Called "octets" is expected a FixedArray the 4 length,
  # that's members 0~255 Fixnum.
  # And the "mask_octets" is same format with the octets.
  # @example
  #   octets: [192, 168, 1, 1]
  #   mask_octets  : [255, 255, 255, 0]
  def initialize(octets, mask_octets=FULL_MASK)
    raise InvalidAddress unless valid_octets? octets
    raise TypeError unless valid_octets? mask_octets

    @octets, @mask_octets = octets.dup.freeze, mask_octets.dup.freeze
  end

  # [192, 168, 1 ,1]
  def octets
    @octets.dup
  end

  alias_method :bytes, :octets

  # [255, 255, 255, 0]
  def mask_octets
    @mask_octets.dup
  end

  alias_method :netmask, :mask_octets

  # @return [Version4] new object
  def masked(other_mask_or_prefix)
    mask = (
      if other_mask_or_prefix.integer?
        if ret = self.class::PREFIXIES[other_mask_or_prefix]
          ret
        else
          raise InvalidAddress
        end
      else
        if valid_octets? other_mask_or_prefix
          other_mask_or_prefix
        else
          raise InvalidAddress
        end
      end
    )
    
    self.class.new @octets, mask
  end
  
  def bits
    _bits.dup
  end

  alias_method :netmask, :mask_octets

  def ipaddress?
    true
  end

  def ipaddress
    self
  end

  def <=>(other)
    family?(other) ? (@octets <=> other.octets) : nil
  end

  def eql?(other)
    family?(other) && (values == other.values)
  end

  alias_method :==, :eql?

  def hash
    values.hash
  end

  def freeze
    memorize
    super
  end
  
  def ===(other)
    cover? other
  end

  def big_endian
  end

  alias_method :byte_order, :big_endian

  def to_range
    network..last
  end
  
  # tmp code
  def host_counts
    hosts.to_a.length
  end
  
  # tmp code
  def length
    to_range.to_a.length
  end
  
  alias_method :size, :length
  
  def each_host(contain_network=false, &block)
    return to_enum(__callee__) unless block_given?

    range = (contain_network ? network : network.next)...last
    range.__send__ :each, &block
  end

  alias_method :hosts, :each_host

  def each_address(&block)
    return to_enum(__callee__) unless block_given?

    to_range.__send__ :each, &block
  end

  alias_method :addressies, :each_address
  
  protected
  
  def _bits
    @bits ||= @octets.map{|oct|
      oct.to_s(2).rjust(8, '0').split('').map(&:to_i)
    }.flatten.freeze
  end
  
  private
  
  def valid_octets?(octets)
    (octets.length == self.class::FULL_MASK.length) && 
      octets.all?{|oct|(0..255).cover?(oct) && oct.integer?}
  rescue NoMethodError
    false
  end
  
  # @abstruct
  def memorize
    values
    bits
    to_i
    nil
  end

end
