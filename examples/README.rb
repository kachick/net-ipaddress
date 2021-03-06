# coding: us-ascii
# frozen_string_literal: true

require_relative '../lib/net/ipaddress'

ip1 = Net::IPAddress('192.168.1.1/24')
ip2 = Net::IPAddress('192.168.1.10/24')
ip3 = Net::IPAddress('192.168.0.0/16')
p ip1.segment?(ip2) #=> true
p ip2.segment?(ip1) #=> true
p ip1.segment?(ip3) #=> false
p ip1.cover?(ip3)   #=> false
p ip3.cover?(ip1)   #=> true

require_relative '../lib/net/ipaddress/ext/ipaddr'

p IPAddr.new('192.168.1.1/24').to_ipaddress == Net::IPAddress('192.168.1.1/24').network
