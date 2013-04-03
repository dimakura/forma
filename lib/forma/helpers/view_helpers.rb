# -*- encoding : utf-8 -*-
module Forma

  module ViewHelpers

    def view_for(model, opts = {}, &block)
      opts[:model] = model
      f = Forma::Form::Form.new(opts)
      yield f
      f.to_e.html
    end

  end

end
