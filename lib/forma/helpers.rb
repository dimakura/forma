# -*- encoding : utf-8 -*-
module Forma

  module Helpers
    def forma_for(model, opts = {}, &block)
      opts[:model] = model
      opts[:edit] = true
      opts[:auth_token] = form_authenticity_token if defined?(Rails)
      opts[:method] = 'post' if opts[:method].blank?
      f = Forma::Form.new(opts)
      yield f
      f.to_html.to_s
    end

    def view_for(model, opts = {}, &block)
      opts[:model] = model
      opts[:edit] = false
      f = Forma::Form.new(opts)
      yield f
      f.to_html.to_s
    end

    module_function :forma_for
    module_function :view_for
  end

end
