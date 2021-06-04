# coding: us-ascii
# frozen_string_literal: true

module Net
  module IPAddress
    class Version4
      PRIVATES =
        [
          new([10, 0, 0, 0], PREFIXES[8]),
          new([172, 16, 0, 0], PREFIXES[12]),
          new([192, 168, 0, 0], PREFIXES[16])
        ].freeze

      LINKLOCAL = new([169, 254, 0, 0], PREFIXES[16])

      LOCALHOST = new([127, 0, 0, 0], PREFIXES[8])

      TESTS =
        [
          new([192, 0, 2, 0], PREFIXES[24]),
          new([198, 51, 100, 0], PREFIXES[24]),
          new([203, 0, 113, 0], PREFIXES[24])
        ].freeze

      ISP = new([100, 64, 0, 0], PREFIXES[10])

      IETF = new([192, 0, 0, 0], PREFIXES[24])
    end
  end
end
