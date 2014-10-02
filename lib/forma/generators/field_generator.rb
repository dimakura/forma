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
      value = value_eval(field, opts)
      if value.present?
        el(tag, [ body_eval(field, opts) ], { class: class_name_eval(field, opts) })
      else
        el('span', [ '(empty)' ], { class: 'text-muted forma-empty-field' })
      end
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
      elsif field.name
        evalModel = model_eval(field, opts)
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
        url.call(opts[:model] || field.model)
      else
        url
      end
    end

    def model_eval(field, opts)
      opts[:model] || field.model
    end

    def model_name_eval(field, opts)
      model_name = opts[:model_name] || field.model_name
      unless model_name
        model = model_eval(field, opts)
        model_name = model.class.name unless model.blank?
      end
      model_name.split('::').join('_').downcase unless model_name.blank?
    end

    def label_eval(field, opts)
      label = nil
      model_name = model_name_eval(field, opts)
      label = I18n.t("models.#{model_name}.#{ field.i18n || field.name }", default: '') if model_name
      if label.nil? or label == ''
        field.label || field.name.to_s.split('_').map{|x| x.capitalize}.join(' ')
      else
        label
      end
    end

    module_function :viewer
    module_function :body_eval
    module_function :value_eval
    module_function :type_eval
    module_function :class_name_eval
    module_function :url_eval
    module_function :label_eval
    module_function :model_eval
    module_function :model_name_eval
  end
end
