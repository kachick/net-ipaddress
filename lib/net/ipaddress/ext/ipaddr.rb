# coding: us-ascii

require 'ipaddr'

class IPAddr
  
  # @return [Net::IPAddress]
  def to_ipaddress
    ::Net::IPAddress.parse(
      "#{_to_string(@addr)}/#{_to_string(@mask_addr)}"
    )
  end

end