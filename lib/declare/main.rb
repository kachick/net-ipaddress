# Copyright (C) 2012 Kenichi Kamiya


class << self
  
  # @param [String] title
  # @return [void]
  def Declare(title=nil, &block)
    title = title.nil? ? caller.first : title

    ::Declare.new_category(title).instance_exec(&block)
  rescue Exception
    raise ::Declare::UnhandledError, $!.inspect, $!.backtrace
  else
    ::Declare.report
  end

end
