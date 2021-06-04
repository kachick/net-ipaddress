# coding: us-ascii
# frozen_string_literal: true

require 'warning'

require 'declare/autorun'

require 'irb'
require 'power_assert/colorize'
require 'irb/power_assert'

if Warning.respond_to?(:[]=) # @TODO Removable this guard after dropped ruby 2.6
  Warning[:deprecated] = true
  Warning[:experimental] = true
end

Warning.process do |_warning|
  :raise
end

require_relative '../lib/net/ipaddress'
