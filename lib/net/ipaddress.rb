# Copyright (c) 2012 Kenichi Kamiya

# Net::IPAddress
#   Provide Utils for IPAddress impression
#   They help your manupilation with any IPAddrresies
# 
#   * Usuful methods
#   * Looks like the "Immutable"
# 

module Net

  module IPAddress

    include Comparable

    class InvalidAddress < StandardError; end

    MASK_SEPARATOR   = '/'.freeze

  end

end

require_relative 'ipaddress/singleton_class'
require_relative 'ipaddress/instance'
require_relative 'ipaddress/version4'
require_relative 'ipaddress/version6'
