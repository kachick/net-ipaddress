$VERBOSE = true

require_relative '../lib/net/ipaddress'
require_relative '../lib/net/ipaddress/ext/ipaddr'
require 'declare'

include Net

Declare do

  The IPAddress('192.168.1.1') do
    is IPAddr.new('192.168.1.1').to_ipaddress
  end
  
  The IPAddr.new('192.168.1.0/24').to_ipaddress do |ipaddr|
    is IPAddress('192.168.1.0/24')
  end

end
