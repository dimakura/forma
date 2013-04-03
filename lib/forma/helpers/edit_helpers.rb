# -*- encoding : utf-8 -*-
module Forma

  module EditHelpers

    def edit_for(model, opts = {}, &block)
      opts[:model] = model
      f = Forma::Form::Form.new(opts)
      yield f
      f.to_e(field: { edit: true }).html
    end

  end

end
