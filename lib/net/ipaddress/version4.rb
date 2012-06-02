# Copyright (c) 2012 Kenichi Kamiya

module Net::IPAddress

  class Version4
    
    include Net::IPAddress

  end
  
  V4 = Version4
  
end

require_relative 'version4/constants'
require_relative 'version4/singleton_class'
require_relative 'version4/instance'
require_relative 'version4/special_addressies'
