# -*- encoding : utf-8 -*-
module Forma
  module AutoInitialize
    def initialize(opts = {})
      @opts = opts
    end

    def method_missing(method_name, *args, &block)
      @opts[ method_name.to_sym ]
    end
  end
end
