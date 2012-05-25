# Copyright (c) 2012 Kenichi Kamiya

module Net

  class IPv4Address
    
    include IPAddress
    
    DELIMITER = '.'.freeze
    FULL_MASK = [255, 255, 255, 255].freeze
    
    # Called "octets" is expected a FixedArray the 4 length,
    # that's members 0~255 Fixnum.
    # And the "mask" is same format with the octets.
    # @example
    #   octets: [192, 168, 1, 1]
    #   mask  : [255, 255, 255, 0]
    def initialize(octets, mask=FULL_MASK)
      raise InvalidAddress unless valid_octets? octets
      raise TypeError unless valid_octets? mask

      @octets, @mask = octets.dup.freeze, mask.dup.freeze
    end

    def to_s
      string_for @octets
    end

    # "192.168.1.1/255.255.255.247(!)"
    # "192.168.1.1/255.255.255.0(24)"
    def inspect
      "#<IPv4 #{to_s}/#{string_for @mask}"
    end
    
    def network?
      @octets == network_octets
    end

    def limited_bloadcast?
      @octets == FULL_MASK
    end

    alias_method :limited_bloadcast?
    
    def directed_bloadcast?
      @octets == directed_broadcast_octets
    end

    def bloadcast?
      limited_bloadcast? || directed_bloadcast?
    end

    def network
      self.class.new network_octets, @mask
    end

    def directed_broadcast
      self.class.new directed_broadcast_octets, @mask
    end

    alias_method :broadcast, :directed_broadcast
    
    def unicast?
    end
    
    def multicast?
    end
    
    def subneted?
    end

    # true if mask is /1 ~ /32
    def cidr?
    end
    
    def classible?
      %w[a b c d e].any?{|s|__send__ "class_#{s}?"}
    end

    def class_a?
      
    end
    
    def class_b?
    end
    
    def class_c?
    end
      
    def class_d?
    end
    
    def class_e?
    end
    
    def cover?(other)
      family?(other) && 
        (network_octets..directed_broadcast_octets).cover?(other.octets)
    end

    alias_method :include?, :cover?

    def family?(other)
      other.respond_to?(:ipv4address?) && other.ipv4address?
    end

    def ipv4address?
      true
    end

    def ipv6address?
      false
    end

    def segment?(other)
      network_octets == other.network_octets
    end
    
    def succ
    end
    
    def prefix
    end

    # true if formatble for the CIDR format
    def fcidr?
    end
    
    def prefix_length
      raise TypeError unless fcidr?

      
    end
    
    def host
    end
    
    alias_method :suffix, :host
    
    def private?
    end
    
    def global?
    end
    
    def linklocal?
    end
      
    alias_method :apipa?, :linklocal?
    
    def localhost?
    end
    
    alias_method :loopback?, :localhost?
    
    def test?
    end
      
    def isp?
    end
    
    def assigned?
    end
    
    def ietf?
    end

    def to_ipv4
      self
    end
    
    def to_ipv6
    end


    protected

    def values
      @values ||= [@octets, @mask]
    end

    def network_octets
      @network_octets ||= _network_octets
    end

    def directed_broadcast_octets
      @directed_broadcast_octets ||= _directed_broadcast_octets
    end

    private

    def valid_octets?(octets)
      (octets.length == 4) && 
        octets.all?{|oct|(0..255).cover?(oct) && oct.integer?}
    rescue NoMethodError
      false
    end

    def _network_octets
      mask_bit = @mask.to_enum
      @octets.map{|bit|bit & mask_bit.next}
    end

    def _directed_broadcast_octets
      octet = @octets.to_enum
      network_octets.map{|nwo|octet.next | (nwo ^ 255)}
    end
    
    def string_for(octets)
      octets.join DELIMITER
    end
      
  end
  
end
