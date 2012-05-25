# Copyright (c) 2012 Kenichi Kamiya

# Net::IPAddress, Net::IPv4Address, Net::IPv6Address
# Provide Utils for IPAddress impression
# They help your manupilation with any IPAddrresies
# 
# * Usuful methods
# * Looks like the "Immutable"
# 

autoload :IPAddr, 'ipaddr'

module Net

  module IPAddress

    include Comparable

    class InvalidAddress < StandardError; end

    def self.parse(str)
    end

    def self.valid?(str)
    end

    # [192, 168, 1 ,1]
    def octets
      @octets.dup
    end

    alias_method :bytes, :octets

    # [255, 255, 255, 0]
    def mask
      @mask.dup
    end

    alias_method :netmask, :mask

    def ipaddress?
      true
    end

    def ipaddress
      self
    end

    def to_ipaddr
      IPAddr.new "#{to_s}/#{string_for mask}"
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

    # Through for cash calculations
    def freeze
      self
    end

  end
  
end

require_relative 'ipv4address'
require_relative 'ipv6address'
