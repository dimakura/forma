# -*- encoding : utf-8 -*-
module Forma

  module EditHelpers

    def edit_for(model, opts = {}, &block)
      opts[:model] = model
      f = Forma::Form::Form.new(opts)
      f.edit = true
      yield f
      f.to_e.html
    end

  end

end
