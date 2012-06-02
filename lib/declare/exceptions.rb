# Copyright (C) 2012 Kenichi Kamiya


module Declare

  class UnhandledError < Exception; end
  class FrameworkError < StandardError; end
  class DupulicatedCategoryError < FrameworkError; end

end