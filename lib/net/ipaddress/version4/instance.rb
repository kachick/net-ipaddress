# coding: us-ascii
# frozen_string_literal: true

module Net
  module IPAddress
    class Version4
      # @return [String]
      def to_s
        string_for_octets(@octets)
      end

      # @return [String]
      # @example
      #   IPAddress.parse('192.168.1.1/255.255.255.247').inspect
      #     #=> "#<IPv4: 192.168.1.1/255.255.255.247(!)>"
      #   IPAddress.parse('192.168.1.1/255.255.255.0').inspect
      #     #=> "#<IPv4: 192.168.1.1/255.255.255.0(24)>"
      def inspect
        "#<IPv4: #{to_s}/#{string_for_octets(@mask_octets)}(#{cidr? ? prefix_length : '!'})>"
      end

      def host?
        @mask_octets == FULL_MASK
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

      # @return [Version4]
      def network
        self.class.new(network_octets, @mask_octets)
      end

      # @return [Version4]
      def directed_broadcast
        self.class.new(directed_broadcast_octets, @mask_octets)
      end

      alias_method :broadcast, :directed_broadcast
      alias_method :last, :directed_broadcast

      def unicast?
        host? || !(broadcast? || multicast?)
      end

      def multicast?
        _bits.take(4) == [1, 1, 1, 0]
      end

      # true if mask is /0 ~ /32
      def cidr?
        PREFIXES.include?(@mask_octets)
      end

      # It is able to deal with "classfull"
      def classible?
        %w[a b c d e].any? { |s| __send__(:"class_#{s}?") }
      end

      # RFC791
      def class_a?
        (_bits.take(1) == [0]) && (prefix_length == 8)
      end

      # RFC791
      def class_b?
        (_bits.take(2) == [1, 0]) && (prefix_length == 16)
      end

      # RFC791
      def class_c?
        (_bits.take(3) == [1, 1, 0]) && (prefix_length == 24)
      end

      # RFC3171
      def class_d?
        new([224, 0, 0, 0], PREFIXES[4]).cover?(self)
      end

      # RFC1112
      def class_e?
        new([240, 0, 0, 0], PREFIXES[4]).cover?(self)
      end

      def cover?(other)
        family?(other) &&
          (network_octets..directed_broadcast_octets).cover?(other.octets)
      end

      alias_method :include?, :cover?
      alias_method :===, :cover?

      def family?(other)
        other.kind_of?(::Net::IPAddress) && other.ipv4address?
      end

      def ipv4address?
        true
      end

      def ipv6address?
        false
      end

      def segment?(other)
        family?(other) &&
          (@mask_octets == other.mask_octets) &&
          (network_octets == other.network_octets)
      end

      # @return [Version4] next ordered object
      def succ(step=1)
        self.class.new(
          self.class.octets_for_integer(to_i + step.to_int),
          @mask_octets
        )
      end

      alias_method :next, :succ

      # @return [Fixnum]
      def prefix_length
        if index = PREFIXES.index(@mask_octets)
          index
        else
          raise TypeError, 'this address is not under any prefix masks'
        end
      end

      def private?
        self.class::PRIVATES.any? { |addr| addr.cover?(self) }
      end

      def global?
        !private?
      end

      def linklocal?
        self.class::LINKLOCAL.cover?(self)
      end

      alias_method :apipa?, :linklocal?

      def localhost?
        self.class::LOCALHOST.cover?(self)
      end

      alias_method :loopback?, :localhost?

      # RFC5737
      def test?
        self.class::TESTS.any? { |addr| addr.cover?(self) }
      end

      alias_method :example?, :test?

      # RFC6598
      def isp?
        self.class::ISP.cover?(self)
      end

      def special?
        !(linklocal? || localhost? || isp? || test? || ietf?)
      end

      # RFC5736
      def ietf?
        self.class::IETF.cover?(self)
      end

      # @return [self]
      def to_ipv4address
        self
      end

      # @todo
      # @return [Version6]
      def to_ipv6address; end

      # @return [Integer]
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

      def _bits
        @bits ||=
          byte_order.unpack1('B32').chars.map(&:to_i).freeze
      end

      private

      def _to_i
        _bits.join.to_i(2)
      end

      def memorize
        super
        network_octets
        directed_broadcast_octets

        nil
      end

      def _network_octets
        mask_bit = @mask_octets.to_enum
        @octets.map { |bit| bit & mask_bit.next }
      end

      def _directed_broadcast_octets
        octet = @octets.to_enum
        @mask_octets.map { |mo| octet.next | (mo ^ 255) }
      end

      def string_for_octets(octets)
        octets.join(DELIMITER)
      end
    end
  end
end
