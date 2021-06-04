# coding: us-ascii
# frozen_string_literal: true

# Copyright (c) 2012 Kenichi Kamiya
#
# net-ipaddress
#   Relieve you of annoying task with IP Addreses

require_relative 'ipaddress/version'

module Net
  module IPAddress
    include Comparable

    class InvalidAddress < StandardError; end

    MASK_SEPARATOR = '/'.freeze
  end

  module_function

  # @return [IPAddress]
  def IPAddress(source)
    case source
    when IPAddress
      source
    when ->src { src.respond_to?(:to_str) }
      IPAddress.parse(source.to_str)
    when ->src { src.respond_to?(:integer?) }
      IPAddress.for_integer(source.to_int)
    else
      raise TypeError
    end
  end
end

require_relative 'ipaddress/singleton_class'
require_relative 'ipaddress/instance'
require_relative 'ipaddress/version4'
require_relative 'ipaddress/version6'
