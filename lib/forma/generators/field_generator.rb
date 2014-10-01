# -*- encoding : utf-8 -*-
require 'forma/generators/html'

module Forma
  module FieldGenerator
    extend Forma::Html

    def viewer_html(field, opts); viewer(field, opts) end
    def editor_html(field, opts); '<p>editor</p>' end

    module_function :viewer_html
    module_function :editor_html

## Viewer creation functions

    def viewer(field, opts)
      model = opts[:model]
      el('span', [ value_eval(field, model) ], { class: class_name_eval(field, model) })
    end

    def type_eval(field, model); field.type || 'text' end
    def class_name_eval(field, model); "forma-#{type_eval(field, model)}-field" end

    def value_eval(field, model)
      if field.value
        field.value
      elsif (model || field.model) and field.name
        evalModel = model || field.model
        if evalModel.instance_of?(Hash)
          evalModel[ field.name.to_sym ]
        else
          evalModel.send( field.name.to_sym )
        end
      end
    end

    module_function :viewer
    module_function :value_eval
    module_function :type_eval
    module_function :class_name_eval
  end
end
