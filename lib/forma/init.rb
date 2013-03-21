# -*- encoding : utf-8 -*-
module Forma::Init
  def initialize(h = {})
    if h.is_a? Hash
      h.each { |k,v| instance_variable_set("@#{k}",v) }
    end
  end
end
