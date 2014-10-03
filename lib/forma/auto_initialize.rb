# -*- encoding : utf-8 -*-
module Forma
  class AutoInitialize

    def initialize(opts = {})
      @opts = opts
    end

    def options; @opts end

    def method_missing(method_name, *args, &block)
      if method_name.to_s[-1] == '='
        @opts[ method_name.to_s.chop.to_sym ] = args[0]
      elsif args.length == 1
        @opts[ method_name ] = args[0]
      else
        @opts[ method_name ]
      end
    end

  end
end
