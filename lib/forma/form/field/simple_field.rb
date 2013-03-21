# -*- encoding : utf-8 -*-
module Forma::Form
  include Forma::Html

  class SimpleField < Field
    attr_accessor :name
  end

end
