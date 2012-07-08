# net-ipaddress
# Copyright (c) 2012 Kenichi Kamiya
#
#   Provide Utils for IPAddress impression
#   They help your manupilation with any IPAddrresies
# 
#   * has usuful methods
#   * immutable


module Net

  module IPAddress

    VERSION = '0.0.1'

    include Comparable

    class InvalidAddress < StandardError; end

    MASK_SEPARATOR   = '/'.freeze

  end
  
  module_function

  # @return [IPAddress]
  def IPAddress(source)
    case source
    when IPAddress
      source
    when ->src{src.respond_to? :to_str}
      IPAddress.parse source.to_str
    when ->src{src.respond_to? :integer?}
      IPAddress.for_integer source.to_int
    else
      raise TypeError
    end
  end

end

require_relative 'ipaddress/singletonclass'
require_relative 'ipaddress/instance'
require_relative 'ipaddress/version4'
require_relative 'ipaddress/version6'
