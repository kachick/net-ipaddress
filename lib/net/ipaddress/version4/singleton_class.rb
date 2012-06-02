# Copyright (c) 2012 Kenichi Kamiya

module Net::IPAddress; class Version4; class << self

  def parse(str)
    case str
    when /\A#{PATTERN}\z/o
      mask = case
             when $~[:mask]
               octets_for $~[:mask]
             when $~[:prefix_length]
               PREFIXIES[$~[:prefix_length].to_i]
             else
               FULL_MASK
             end

      new octets_for($~[:octets]), mask
    else
      raise InvalidAddress, str
    end
  end

  def valid?(str)
    parse str
  rescue InvalidAddress
    false
  else
    true
  end

  private

  def octets_for(str)
    str.split(DELIMITER).map(&:to_i)
  end

end; end; end
