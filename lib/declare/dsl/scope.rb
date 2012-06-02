# Copyright (C) 2012 Kenichi Kamiya

require_relative 'basic'
require_relative 'assertions'

module Declare::DSL

  class Scope < Basic
    
    include Assertions
    
    attr_reader :target
    
    def initialize(object)
      @target = object
    end
    
    alias_method :it, :target

  end
  
end