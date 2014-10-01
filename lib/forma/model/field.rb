# -*- encoding : utf-8 -*-
require 'forma/auto_initialize'

module Forma

  class Field
    include Forma::AutoInitialize

    def to_html
      '<p>hello, forma</p>'.html_safe
    end
  end

end
