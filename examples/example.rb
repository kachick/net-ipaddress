$VERBOSE = true

require_relative '../lib/net/ipaddress'

p  Net.IPAddress '192.168.1.1'
#~ p  Net.IPAddress '192.168.1.1/33'
p  Net.IPAddress '192.168.1.1/255.255.255.255'
p  Net.IPAddress '192.168.1.1/255.131.255.255'

ip1 = Net.IPAddress '192.168.1.1/28'
ip2 = Net.IPAddress '192.168.1.2/28'
ip3 = Net.IPAddress '192.168.1.3/24'
ip4 = Net.IPAddress '192.168.1.30/28'

p ip1
p ip2
p ip1.next.next(20)

ip1.each_address do |addr|
  p addr
end

p ip1.cover? ip2
p ip1.cover? ip3
p ip1.segment? ip2
p ip1.segment? ip3
p ip1.cover? ip4
p ip1.segment? ip4
p ip1.network
p ip3.network
p ip1.broadcast
p ip4.network

ip5 = Net.IPAddress '192.168.1.30/17'

p ip5
p ip5.private?
p ip5.unicast?

#~ p Net.IPAddress::Version6.parse '9787'