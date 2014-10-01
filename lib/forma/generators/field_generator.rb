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
      tag = field.tag || 'span'
      el(tag, [ body_eval(field, opts) ], { class: class_name_eval(field, opts) })
    end

    def type_eval(field, opts); field.type || 'text' end
    def class_name_eval(field, opts); "forma-#{type_eval(field, opts)}-field" end

    def body_eval(field, opts)
      value = value_eval(field, opts)
      if field.url
        el('a', [ value ], { href: url_eval(field, opts) })
      else
        value
      end
    end

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

    def url_eval(field, opts)
      url = field.url
      if url.instance_of?(Proc)
        url.call(field.model || opts[:model])
      else
        url
      end
    end

    def label_eval(field, opts)
      field.label || field.name.split('_').map{|x| x.capitalize}.join(' ')
    end

    module_function :viewer
    module_function :body_eval
    module_function :value_eval
    module_function :type_eval
    module_function :class_name_eval
    module_function :url_eval
    module_function :label_eval
  end
end
