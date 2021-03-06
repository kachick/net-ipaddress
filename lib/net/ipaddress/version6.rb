# coding: us-ascii
# frozen_string_literal: true

# Copyright (c) 2012 Kenichi Kamiya

module Net
  module IPAddress
    # @todo Implement :)
    class Version6
      include ::Net::IPAddress

      FULL_MASK = Array.new(16) { 255 }.freeze
      DELIMITER = ':'
      SQUEEZE = '::'

      class << self
        # @return [128]
        def bit_length
          128
        end

        def parse(str)
          case str
          when /[^0-9a-fA-F:.]/
            raise InvalidAddress
          when Version4::OCTETS_PATTERN
            parse_ipv4friend(str)
          when /\A(.+?)(?:#{MASK_SEPARATOR}(.+))?\z/o
            octets = octets_for_rfc4291(Regexp.last_match(1))
            mask = Regexp.last_match(2) ? octets_for_mask(Regexp.last_match(2)) : FULL_MASK
            new(octets, mask)
          else
            raise InvalidAddress
          end
        end

        def octets_for_rfc4291(str)
          case str
          when /\A(.*)::(.*)\z/
            parse_squeezed(Regexp.last_match(1), Regexp.last_match(2))
          when /\A([\da-f]{1,4}:){7}[\da-f]{1,4}\z/i
            octets_for_simple(str)
          else
            raise InvalidAddress
          end
        end

        # Always "mask == prefix" on IPv6 address, this is as not as IPv4's rule
        def octets_for_mask(str)
          case str
          when /\A(0|[1-9]\d*)\z/
            prflen = Regexp.last_match(1).to_i
            raise InvalidAddress unless (0..128).cover?(prflen)

            PRIFIXIES[prflen]
          when //
            # noop
          end
        end

        alias_method :octets_for_prefix, :octets_for_mask

        def octets_for_simple(str)
          sections = str.split(DELIMITER)
          raise InvalidAddress unless sections.length == 8

          octets = []
          sections.each do |section|
            if /\A([\da-fA-F]{0,2})([\da-fA-F]{1,2})\z/ =~ section
              # empty is 0
              octets << Regexp.last_match(1).to_i(16) << Regexp.last_match(2).to_i(16)
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
          if /\A(%\S+?)\z/.match?(str)
            # noop
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
          if /\A(?:::|(?:0:){5})f{4}#{Version4::OCTETS_PATTERN}\z/o.match?(str)
            # noop
          end
        end

        # @todo
        # RFC3513
        def parse_ipv4compatible(str)
          if /\A(?:::|(?:0:){6})#{Version4::OCTETS_PATTERN}\z/o.match?(str)
            # noop
          end
        end
      end

      def ipv4address?
        false
      end

      def ipv6address?
        true
      end

      def sections
        @octets.each_slice(2).map { |fst, snd| (fst * 255) + snd }
      end

      def to_s
        sections.map { |sect| sect.to_s(16) }.join(DELIMITER)
      end

      def inspect
      end

      def to_short_str
      end

      def to_s_rfc5952
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

    V6 = Version6
  end
end
