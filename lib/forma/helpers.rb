# -*- encoding : utf-8 -*-
module Forma

  module Helpers
    def forma_for(model, opts = {}, &block)
      opts[:model] = model
      opts[:edit] = true
      f = Forma::Form::Form.new(opts)
      yield f
      f.to_html.to_s
    end

    module_function :forma_for
  end

end
