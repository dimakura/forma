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
      el('span', [ value_eval(field, opts) ], { class: class_name_eval(field, opts) })
    end

    def type_eval(field, opts); field.type || 'text' end
    def class_name_eval(field, opts); "forma-#{type_eval(field, opts)}-field" end

    def value_eval(field, opts)
      if field.value
        field.value
      elsif (opts[:model] || field.model) and field.name
        evalModel = opts[:model] || field.model
        if evalModel.instance_of?(Hash)
          evalModel[ field.name.to_sym ]
        else
          evalModel.send( field.name.to_sym )
        end
      end
    end

    def label_eval(field, opts)
      field.label || field.name.split('_').map{|x| x.capitalize}.join(' ')
    end

    module_function :viewer
    module_function :value_eval
    module_function :type_eval
    module_function :class_name_eval
    module_function :label_eval
  end
end
