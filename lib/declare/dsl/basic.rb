# Copyright (C) 2012 Kenichi Kamiya

module Declare

  module DSL
  
    CallerEntry = Struct.new :file_name, :line_number, :method_name, :block_level do
      
      class << self
        
        # reference: http://doc.ruby-lang.org/ja/1.9.3/class/Kernel.html
        def parse(caller_entry)
          if /\A(.+?):(\d+)(?::in `(.*)')?/ =~ caller_entry
            file_name, line_number, method_name = $1, $2.to_i, $3
            block_level = /block \((\d+) levels\)/ =~ method_name ? $1.to_i : 1
            
            new file_name, line_number, method_name, block_level
          else
            raise TypeError, caller_entry
          end
        end
        
      end
      
      def to_s
        "#{file_name}:#{line_number}"
      end
      
    end

    # @note
    #   Can't inherit from BasicObject, for namespace of toplevel constants
    class Basic
      
      kernel_methods = (
        Kernel.instance_methods(false)         | 
        Kernel.private_instance_methods(false)
      )

      requires = [:raise, :caller, :object_id, :p, :puts, :print]
      
      # @note
      #   like a BasicObject
      (kernel_methods - requires).each do |method_name|
        undef_method method_name
      end
      
      alias_method :_caller, :caller
      
      def called_from(level=0)
        CallerEntry.parse caller[1 + level]
      end

      def Focus(target, &block)
        Declare.scope! target, called_from
        Declare::DSL::Scope.new(target).instance_exec(target, &block)
      rescue Exception
        #~ ::Declare.unexpected_failure_in_the target, $!, ::Kernel.caller
        raise UnhandledError, "#{$!.inspect}/#{$!.backtrace}"
      end

      alias_method :The, :Focus
      alias_method :on, :Focus

    end

  end

end