# Copyright (C) 2012 Kenichi Kamiya


module Declare

  @unexpected_failures = {}
  @categories = {}
  @failures = {}
  @scope_summaries = []
  @pass_counter, @declare_counter = 0, 0
      
  class << self
    
    ScopeSummary = Struct.new :target, :description, :caller_entry, :nesting_level
    
    def unexpected_failure_in_the(scoped, exception, _caller)
      @unexpected_failures[scoped] = [exception, _caller]
    end
    
    def new_category(title)
      title = title.to_s
      raise DupulicatedCategoryError if @categories.has_key? title

      @categories[title] = DSL::Basic.new
    end
    
    def declared!
      @declare_counter += 1
    end

    def scope!(target, caller_entry, description=nil)
      @scope_summaries << ScopeSummary.new(target, description, caller_entry, caller_entry.block_level)
    end

    def pass!
      @pass_counter += 1
    end
    
    def failure!(report)
      @failures[@scope_summaries.last] ||= []
      @failures[@scope_summaries.last] << report
    end

    def report
      unless @failures.empty?
        header = 'Below definitions are not satisfied some conditions.'
        puts header
        puts '=' * header.length

        @failures.each_pair do |scope, lines|
          puts "##{'#' * scope.nesting_level} #{scope.target.inspect} ##{'#' * scope.nesting_level} [#{scope.caller_entry.file_name}:#{scope.caller_entry.line_number}]"

          lines.each do |line|
            puts "  * #{line}"
          end
          puts
        end
        
        puts '-' * 76
      end

      puts "#{@categories.length} categorizies, #{@scope_summaries.length} scopes, #{@declare_counter} behaviors"
      puts " Unexpected Failers: #{@unexpected_failures.inspect}" unless @unexpected_failures.empty?
      puts "    pass: #{@pass_counter}"
      puts "    fail: #{@failures.values.flatten.length}"
    end
    
  end

end