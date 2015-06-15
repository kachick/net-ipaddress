require_relative 'declare_helper'

The Net::IPAddress::Version4 do |v4class|
  respond :parse

  CATCH Net::IPAddress::InvalidAddress do
    v4class.parse '192.168.1.01'
  end

  CATCH Net::IPAddress::InvalidAddress do
    v4class.parse "192.168.1.1\n"
  end
  
  CATCH Net::IPAddress::InvalidAddress do
    v4class.parse '192.168.1.1/33'
  end
  
  CATCH Net::IPAddress::InvalidAddress do
    v4class.parse '192.168.1.1!32'
  end

  The Net::IPAddress('255.255.255.255') do |full|
    The full.to_i do
      is 4_294_967_295
      is Net::IPAddress(4_294_967_295).to_i
    end
  end

  The Net::IPAddress(12) do |low|
    is Net::IPAddress('0.0.0.12')
    
    The low.to_i do
      is 12
    end
  end

  The v4class.parse('192.168.1.1') do |addr|
    is Net::IPAddress('192.168.1.1')
    a v4class
    kind Net::IPAddress
    is v4class.parse('192.168.1.1')
    is v4class.parse('192.168.1.1/255.255.255.255')
    eql v4class.parse('192.168.1.1/255.255.255.255')

    The addr.inspect  do
      is '#<IPv4: 192.168.1.1/255.255.255.255(32)>'
    end
    
    truthy addr.to_s == '192.168.1.1'
    truthy addr.prefix_length == 32
  end
  
  The v4class.parse('192.168.1.1/255.131.255.255') do |addr|
    The addr.inspect  do
      is '#<IPv4: 192.168.1.1/255.131.255.255(!)>'
    end
  end

  The v4class.parse('192.168.1.1/28') do |addr|
    The addr.inspect  do
      is '#<IPv4: 192.168.1.1/255.255.255.240(28)>'
    end
    
    The addr.succ.next(20).inspect do
      is '#<IPv4: 192.168.1.22/255.255.255.240(28)>'
    end
    
    The addr.addressies do |enum|
      a Enumerator

      The enum.to_a do |list|
        truthy list.first.inspect == '#<IPv4: 192.168.1.0/255.255.255.240(28)>'
        truthy list[4].inspect == '#<IPv4: 192.168.1.4/255.255.255.240(28)>'
        truthy list.last.inspect == '#<IPv4: 192.168.1.15/255.255.255.240(28)>'
        truthy list.first == list.sample.network
        truthy list.last == list.sample.broadcast
      end
      
      The addr.each_address {} do
        equal addr
      end
      
      The addr.subnet_counts do
        is 16
      end
    end

    The addr.hosts do |enum|
      a Enumerator
      
      The enum.to_a do |list|
        truthy list.first.inspect == '#<IPv4: 192.168.1.1/255.255.255.240(28)>'
        truthy list[4].inspect == '#<IPv4: 192.168.1.5/255.255.255.240(28)>'
        truthy list.last.inspect == '#<IPv4: 192.168.1.14/255.255.255.240(28)>'
      end
      
      The addr.each_host {} do
        equal addr
      end
      
      The addr.host_counts do
        is 14
      end
    end
    
    truthy addr.cover?(v4class.parse('192.168.1.2/28'))
    truthy addr.cover?(v4class.parse('192.168.1.2/24'))
    falthy addr.cover?(v4class.parse('192.168.1.30/28'))
    truthy addr.segment?(v4class.parse('192.168.1.2/28'))
    falthy addr.segment?(v4class.parse('192.168.1.2/24'))
    falthy addr.segment?(v4class.parse('192.168.1.30/28'))
    
    The addr.network do
      is v4class.parse('192.168.1.0/28')
    end
    
    The addr.broadcast do
      is v4class.parse('192.168.1.15/28')
    end
    
    truthy addr.private?
    falthy addr.global?
    truthy addr.unicast?
    falthy addr.broadcast?
    falthy addr.next.broadcast?
  end
  
  The v4class.parse('221.186.184.68') do |addr|
    truthy addr.unicast?
    truthy addr.global?
    falthy addr.private?
    falthy addr.multicast?
    truthy addr.network?
    truthy addr.broadcast?
    
    The Net::IPAddress::Version4.new(addr.octets, [255, 255, 255, 0]) do |new_addr|
      truthy new_addr.unicast?
      falthy new_addr.network?
      falthy new_addr.broadcast?
      falthy addr.multicast?
      
      The new_addr.inspect do
        is '#<IPv4: 221.186.184.68/255.255.255.0(24)>'
      end
    end
  end
  
end

Declare.report
