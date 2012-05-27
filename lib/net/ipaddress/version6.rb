# Copyright (c) 2012 Kenichi Kamiya

module Net::IPAddress

  class Version6

    include Net::IPAddress
    
    FULL_MASK = 16.times.map{255}.freeze
    DELIMITER = ':'.freeze
    SQUEEZ    = '::'.freeze
    
    class << self

      def parse(str)
        case str
        when /[^0-9a-fA-F:\.]/
          raise InvalidAddress
        when /\./
          parse_ipv4friend str
        when /\A(.+?)(?:#{MASK_SEPARATOR}(.+))?\z/o
          octets = octets_for_rfc4291 $1
          mask = $2 ? octets_for_mask($2) : FULL_MASK
          new octets, mask
        else
          raise InvalidAddress
        end
      end

      def octets_for_rfc4291(str)
        case str
        when /\A(.*)::(.*)\z/
          parse_squeezed($1, $2)
        when /\A([\da-f]{1,4}:){7}[\da-f]{1,4}\z/i
          octets_for_simple str
        else
          raise InvalidAddress
        end
      end
      
      # Always "mask == prefix" on IPv6 address, this is as not as IPv4's rule
      def octets_for_mask(str)
        case str
        when /\A(0|[1-9]\d*)\z/
          prflen = $1.to_i
          raise InvalidAddress unless (0..128).cover? prflen
          
          PRIFIXIES[prflen]
        when //
          
        else
        end
      end
      
      alias_method :octets_for_prefix, :octets_for_mask
      
      def octets_for_simple(str)
        sections = str.split DELIMITER
        raise InvalidAddress unless sections.length == 8
        
        octets = []
        sections.each do |section|
          if /\A([\da-fA-F]{0,2})([\da-fA-F]{1,2})\z/ =~ section
            # empty is 0
            octets << $1.to_i(16) << $2.to_i(16)
          else
            raise InvalidAddress
          end
        end
        
        octets
      end
      
      def octets_for_squeezed(left_sections, right_sections)
        llen, rlen = left_sections.length, right_sections.length
        unless (1..7).cover?(llen + rlen)
          raise InvalidAddress
        end
      end
      
      # @todo
      def parse_rfc5952(str)
      end
      
      def valid_rfc4291?(str)
      end
      
      alias_method :valid?, :valid_rfc4291?
      
      # @todo
      def valid_rfc5952?(str)
      end
      
      alias_method :strict?, :valid_rfc5952?
      
      def parse_linklocal(str)
        if /\A(%\S+?)\z/ =~ str
        end
      end
      
      # the word "friend" was defined by me :), for daily use cases
      def parse_ipv4friend(str)
        parse_ipv4compatible(str)
      rescue InvalidAddress
        parse_ipv4mapped(str)
      end
      
      # @todo
      def parse_ipv4mapped(str)
        if /\A(?:::|(?:0:){5})f{4}#{IPv4Address::OCTETS_PATTERN}\z/o =~ str
        end
      end
      
      # @todo
      # RFC3513
      def parse_ipv4compatible(str)
        if /\A(?:::|(?:0:){6})#{IPv4Address::OCTETS_PATTERN}\z/o =~ str
        end
      end
      
    end
    
    def sections
      @octets.each_slice(2).map{|fst, snd|(fst * 255) + snd}
    end
    
    def to_s
      sections.map{|sect|sect.to_s 16}.join(DELIMITER)
    end
    
    def inspect
    end
    
    def to_short_str
    end

    def unicast?
    end

    def multicast?
      @octets.first == 255
    end

    def allnode_multicast?
    end

    def anycast?
    end

    def linklocal?
    end

    def global?
    end
    
    def local?
    end
    
    def uniquelocal?
    end
    
    def ipv4mapped?
    end

    def loopback?
    end

    def unspecified?
    end
    
    def teredo?
    end
    
    def bmwg?
    end
    
    def orchid?
    end
    
    def defaultroute?
    end
    
    def interfacelocal?
    end
    
    def adminlocal?
    end
    
    def sitelocal?
    end
    
    def organizationlocal?
    end
    
    def test?
    end
    
    alias_method :example?, :test?
    

  end

  
end
