# frozen_string_literal: true
require_relative 'helper'
require_relative '../lib/net/ipaddress/ext/ipaddr'

Declare.describe do
  The Net::IPAddress('192.168.1.1') do
    is IPAddr.new('192.168.1.1').to_ipaddress
  end

  The IPAddr.new('192.168.1.0/24').to_ipaddress do |_ipaddr|
    is Net::IPAddress('192.168.1.0/24')
  end
end

