# -*- encoding : utf-8 -*-
require 'forma/generators/html'
require 'forma/generators/utils'

module Forma
  module FieldGenerator
    extend Forma::Html
    extend Forma::Utils

    def viewer_html(field, opts); viewer(field, opts) end
    def editor_html(field, opts); '<p>editor</p>' end

    module_function :viewer_html
    module_function :editor_html

## Viewer creation functions

    def viewer(field, opts)
      tag = field.tag || 'span'
      value = value_eval(field, opts)
      unless value.nil? or value == ''
        el(tag, [ viewer_body_eval(field, opts) ], { class: viewer_class_name_eval(field, opts) })
      else
        el('span', [ '(empty)' ], { class: 'text-muted forma-empty-field' })
      end
    end

    def type_eval(field, opts); field.type || 'text' end
    def model_eval(field, opts); opts[:model] || field.model end

    def viewer_class_name_eval(field, opts)
      clazz = opts[:class_name] || field.class_name
      clazz = clazz.join(' ') if clazz.instance_of?(Array)
      "forma-#{type_eval(field, opts)}-field #{clazz}".strip
    end

    def value_eval(field, opts)
      if field.value
        field.value
      elsif field.name
        model_value( model_eval(field, opts), field.name )
        # if evalModel.instance_of?(Hash)
        #   evalModel[ field.name.to_sym ]
        # else
        #   evalModel.send( field.name.to_sym )
        # end
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

    def viewer_body_eval(field, opts)
      type = type_eval(field, opts)
      url = url_eval(field, opts)
      value = value_eval(field, opts)
      
      inner_html = case type
        when 'boolean' then viewer_for_boolean_eval(field, value, opts)
        when 'date' then viewer_for_date_eval(field, value, opts)
        when 'complex' then viewer_for_complex_eval(field, value, opts)
        else value
      end

      if url then el('a', [ inner_html ], { href: url })
      else inner_html
      end
    end

    def viewer_for_boolean_eval(field, value, opts)
      model_name = model_name_eval(field, opts)

      false_text = true_text = nil

      if opts[:false_text] == false
        false_text = nil
      elsif opts[:false_text].present?
        false_text = opts[:false_text]
      elsif field.false_text == false
        false_text = nil
      elsif field.false_text.present?
        false_text = field.false_text
      elsif model_name.present?
        false_text = I18n.t("models.#{model_name}.#{ field.i18n || field.name }_false", default: '')
      end

      if opts[:true_text] == false
        true_text = nil
      elsif opts[:true_text].present?
        true_text = opts[:true_text]
      elsif field.true_text == false
        true_text = nil
      elsif field.true_text.present?
        true_text = field.true_text
      elsif model_name.present?
        true_text = I18n.t("models.#{model_name}.#{ field.i18n || field.name }_true", default: '')
      end      

      if value
        el('span', { class: 'text-success' }, [
          el('i', { class: 'fa fa-check' }),
          ' ' + true_text
        ])
      else
        el('span', { class: 'text-danger' }, [
          el('i', { class: 'fa fa-remove' }),
          ' ' + false_text
        ])
      end
    end

    DATE_FORMATS = {
      short:  '%d-%b-%Y',
      medium: '%d-%b-%Y %H:%M',
      long:   '%d-%b-%Y %H:%M:%S',
      extra:  '%d-%b-%Y %H:%M:%S %z'
    }

    def viewer_for_date_eval(field, value, opts)
      formatter = (
        if opts[:format] then DATE_FORMATS[opts[:format].to_sym]
        elsif opts[:formatter] then opts[:formatter].to_s
        elsif field.format then DATE_FORMATS[field.format.to_sym]
        elsif field.formatter then field.formatter.to_s
        else DATE_FORMATS[:medium]
        end).to_s
      value.localtime.strftime(formatter)
    end

    def viewer_for_complex_eval(field, value, opts)
      field.fields.map do |fld|
        viewer(fld, { model: value })
      end.join(' ')
    end

    module_function :viewer
    module_function :viewer_body_eval
    module_function :value_eval
    module_function :type_eval
    module_function :viewer_class_name_eval
    module_function :url_eval
    module_function :label_eval
    module_function :model_eval
    module_function :model_name_eval
    module_function :viewer_for_boolean_eval
    module_function :viewer_for_date_eval
    module_function :viewer_for_complex_eval
  end
end
