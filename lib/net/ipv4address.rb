# Copyright (c) 2012 Kenichi Kamiya

module Net

  class IPv4Address
    
    include IPAddress
    
    OCTETS_DELIMITER = '.'.freeze
    ROLE_DELIMITER   = '/'.freeze
    octet_rxp_str = '(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)'
    OCTETS_PATTERN = 
      /\b
       (?:#{octet_rxp_str}#{Regexp.escape OCTETS_DELIMITER}){3} # 0~255.0~255.0~255.
       #{octet_rxp_str}                                  # 0~255
       \b/x

    MASK_PATTERN = 
      /\b(?:(?<prefix_length>\d|[1-2]\d|3[0-2])|
       (?<mask>#{OCTETS_PATTERN}))
       \b/x

    PATTERN = 
      /\b
       (?<octets>#{OCTETS_PATTERN})
       (?:#{Regexp.escape ROLE_DELIMITER}#{MASK_PATTERN})?
       \b/x
    
    # Regural masks for "prefix", and they are frozen.
    # @example
    #   [[0, 0, 0, 0],          # 0(first)
    #   [128, 0, 0, 0],         # 1
    #   ....,                   # 2 ~ 23
    #   [255, 255, 255, 0],     # 24
    #   ....,                   # 24 ~ 31
    #   [255, 255, 255, 255]]   # 32(last)
    PREFIXIES = [[0, 0, 0, 0].freeze].tap {|ret|
      valid_octets = [128, 192, 224, 240, 248, 252, 254, 255].freeze
      base_octets = ret.first.dup

      base_octets.length.times do |n|
        valid_octets.each do |oct|
          mask = base_octets.dup
          mask[n] = oct
          ret << mask.freeze
        end

        base_octets[n] = valid_octets.last
      end

      raise 'must not happen' unless ret.length == 33
    }.freeze

    FULL_MASK = PREFIXIES.last
    
    class << self

      def parse(str)
        case str
        when /\A#{PATTERN}\z/o
          mask = case
                 when $~[:mask]
                   octets_for $~[:mask]
                 when $~[:prefix_length]
                   PREFIXIES[$~[:prefix_length].to_i]
                 else
                   FULL_MASK
                 end

          new octets_for($~[:octets]), mask
        else
          raise InvalidAddress, str
        end
      end

      def valid?(str)
        parse str
      rescue InvalidAddress
        false
      else
        true
      end

      private

      def octets_for(str)
        str.split(OCTETS_DELIMITER).map(&:to_i)
      end

    end
    
    # Called "octets" is expected a FixedArray the 4 length,
    # that's members 0~255 Fixnum.
    # And the "mask_octets" is same format with the octets.
    # @example
    #   octets: [192, 168, 1, 1]
    #   mask_octets  : [255, 255, 255, 0]
    def initialize(octets, mask=FULL_MASK)
      raise InvalidAddress unless valid_octets? octets
      raise TypeError unless valid_octets? mask

      @octets, @mask_octets = octets.dup.freeze, mask.dup.freeze
    end

    def to_s
      string_for @octets
    end

    # "192.168.1.1/255.255.255.247(!)"
    # "192.168.1.1/255.255.255.0(24)"
    def inspect
      "#<IPv4: #{to_s}/#{string_for @mask_octets}(#{cidr? ? prefix_length: '!'})>"
    end
    
    def network?
      @octets == network_octets
    end

    def limited_broadcast?
      @octets == FULL_MASK
    end
    
    def directed_broadcast?
      @octets == directed_broadcast_octets
    end

    def broadcast?
      limited_broadcast? || directed_broadcast?
    end

    def network
      self.class.new network_octets, @mask_octets
    end

    def directed_broadcast
      self.class.new directed_broadcast_octets, @mask_octets
    end

    alias_method :broadcast, :directed_broadcast
    
    def unicast?
      ! (broadcast? || multicast?)
    end
    
    def multicast?
      _bits.take(4) == [1, 1, 1, 0]
    end

    # true if mask is /1 ~ /32
    def cidr?
      PREFIXIES.include? @mask_octets
    end
    
    def classible?
      %w[a b c d e].any?{|s|__send__ "class_#{s}?"}
    end

    # RFC791
    def class_a?
      (_bits.take(1) == [0]) && (prefix_lengh == 8)
    end
    
    # RFC791
    def class_b?
      (_bits.take(2) == [1, 0]) && (prefix_lengh == 16)
    end
    
    # RFC791
    def class_c?
      (_bits.take(3) == [1, 1, 0]) && (prefix_lengh == 24)
    end
    
    # RFC3171
    def class_d?
      new([224, 0, 0, 0], PREFIXIES[4]).cover? self
    end
    
    # RFC1112
    def class_e?
      new([240, 0, 0, 0], PREFIXIES[4]).cover? self
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
      family?(other) && 
        (@mask_octets == other.mask_octets)&&
        (network_octets == other.network_octets)
    end
    
    def succ(step=1)
      self.class.new octets_for(to_i + step.to_int), @mask_octets
    end
    
    alias_method :next, :succ
    
    def prefix_length
      if index = PREFIXIES.index(@mask_octets)
        index
      else
        raise TypeError, 'this address is not under any prefix masks'
      end
    end

    def private?
      self.class::PRIVATES.any?{|addr|addr.cover? self}
    end
    
    def global?
      ! private?
    end

    def linklocal?
      self.class::LINKLOCAL.cover? self
    end
      
    alias_method :apipa?, :linklocal?

    def localhost?
      self.class::LOCALHOST.cover? self
    end
    
    alias_method :loopback?, :localhost?
   
    # RFC5737
    def test?
      self.class::TESTS.any?{|addr|addr.cover? self}
    end
    
    # RFC6598
    def isp?
      self.class::ISP.cover? self
    end
    
    def special?
      ! (linklocal? || localhost? || isp? || test? || ietf?)
    end
    
    # RFC5736
    def ietf?
      self.class::IETF.cover? self
    end

    def to_ipv4
      self
    end
    
    def to_ipv6
    end

    def to_i
      @to_i ||= _to_i
    end

    protected

    def values
      @values ||= [@octets, @mask_octets]
    end

    def network_octets
      @network_octets ||= _network_octets
    end

    def directed_broadcast_octets
      @directed_broadcast_octets ||= _directed_broadcast_octets
    end

    private

    def _to_i
      _bits.join.to_i 2
    end
    
    def memorize
      super
      network_octets
      directed_broadcast_octets
      
      nil
    end

    def valid_octets?(octets)
      (octets.length == 4) && 
        octets.all?{|oct|(0..255).cover?(oct) && oct.integer?}
    rescue NoMethodError
      false
    end

    def _network_octets
      mask_bit = @mask_octets.to_enum
      @octets.map{|bit|bit & mask_bit.next}
    end

    def _directed_broadcast_octets
      octet = @octets.to_enum
      @mask_octets.map{|mo|octet.next | (mo ^ 255)}
    end
    
    def string_for(octets)
      octets.join OCTETS_DELIMITER
    end
    
    def octets_for(int)
      int.to_s(2).ljust(32, '0').scan(/[01]{8}/).map{|s|s.to_i 2}
    end

  end
  
end

require_relative 'ipv4address/specials'
