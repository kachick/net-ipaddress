# coding: us-ascii
# frozen_string_literal: true

module Net
  module IPAddress
    class Version4
      class << self
        # @return [32]
        def bit_length
          32
        end

        # @return [Version4]
        def parse(str)
          case str
          when /\A#{PATTERN}\z/o
            mask = case
                   when $~[:mask]
                     octets_for_string($~[:mask])
                   when $~[:prefix_length]
                     PREFIXES[$~[:prefix_length].to_i]
                   else
                     FULL_MASK
                   end

            new(octets_for_string($~[:octets]), mask)
          else
            raise InvalidAddress, str
          end
        end

        # @param [String] str
        # @return [IPAddress]
        def parse_big_endian(str, mask_str=nil)
          new(str.unpack('C4'), mask_str ? mask_str.unpack('C4') : FULL_MASK)
        end

        def valid_string?(str)
          parse(str)
        rescue InvalidAddress
          false
        else
          true
        end

        # @param [Integer] int
        # @return [IPAddress]
        def for_integer(int, mask_int=nil)
          new(octets_for_integer(int), mask_int ? octets_for_integer(mask_int) : FULL_MASK)
        end

        alias_method :for_i, :for_integer

        def octets_for_string(str)
          str.split(DELIMITER).map(&:to_i)
        end

        # @param [Integer] int
        # @return [Array<Fixnum>]
        def octets_for_integer(int)
          int = int.to_int
          raise RangeError unless (0..4_294_967_295).cover?(int)

          int.to_s(2).rjust(bit_length, '0')
             .scan(/[01]{8}/).map { |s| s.to_i(2) }
        end
      end
    end
  end
end
