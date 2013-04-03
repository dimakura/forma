# -*- encoding : utf-8 -*-
module Forma
  module Init
    def initialize(h = {})
      update_with(h)
    end

    def update_with(h)
      if h.is_a? Hash
        h.each { |k,v| instance_variable_set("@#{k}",v) }
      end
    end
  end
end
