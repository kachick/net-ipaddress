# Copyright (c) 2012 Kenichi Kamiya

module Net::IPAddress

  class Version4

    PRIVATES = 
      [
       new([10, 0, 0, 0], PREFIXIES[8]),
       new([172, 16, 0, 0], PREFIXIES[12]),
       new([192, 168, 0, 0], PREFIXIES[16])
      ].freeze

    LINKLOCAL = new [169, 254, 0, 0], PREFIXIES[16]

    LOCALHOST = new [127, 0, 0, 0], PREFIXIES[8]
    
    TESTS = 
      [
       new([192, 0, 2, 0], PREFIXIES[24]),
       new([198, 51, 100, 0], PREFIXIES[24]),
       new([203, 0, 113, 0], PREFIXIES[24])
      ].freeze
    
    ISP = new([100, 64, 0, 0], PREFIXIES[10])

    IETF = new([192, 0, 0, 0], PREFIXIES[24])  

  end
  
end
