# coding: us-ascii

module Net; module IPAddress; class Version4

  DELIMITER = '.'.freeze
  
  # It's clearly to build below octets pattern with Tanaka Akira Specal.
  # e.g. /(?:(?<octet>25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)\.){3}\g<octet>/
  # But this way occur a error, for after building other patterns with this Regexp object :<
  octet_rxp_str = '(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)'
  OCTETS_PATTERN = 
    /\b
     (?:#{octet_rxp_str}#{Regexp.escape DELIMITER}){3} # 0~255.0~255.0~255.
     #{octet_rxp_str}                                  # 0~255
     \b/x

  MASK_PATTERN = 
    /\b(?:(?<prefix_length>\d|[1-2]\d|3[0-2])|
     (?<mask>#{OCTETS_PATTERN}))
     \b/x

  PATTERN = 
    /\b
     (?<octets>#{OCTETS_PATTERN})
     (?:#{Regexp.escape MASK_SEPARATOR}#{MASK_PATTERN})?
     \b/x
  
  # Regular masks for "prefix", and they are frozen.
  # @example
  #   [[0, 0, 0, 0],          # 0(first)
  #   [128, 0, 0, 0],         # 1
  #   ....,                   # 2 ~ 23
  #   [255, 255, 255, 0],     # 24
  #   ....,                   # 24 ~ 31
  #   [255, 255, 255, 255]]   # 32(last)
  PREFIXIES = [[0, 0, 0, 0].freeze].tap {|ret|
    valid_octets = [128, 192, 224, 240, 248, 252, 254, 255].freeze
    base_octets = ret.first.dup

    base_octets.length.times do |n|
      valid_octets.each do |oct|
        mask = base_octets.dup
        mask[n] = oct
        ret << mask.freeze
      end

      base_octets[n] = valid_octets.last
    end

    raise 'must not happen' unless ret.length == 33
  }.freeze

  FULL_MASK = PREFIXIES.last
  
end; end; end