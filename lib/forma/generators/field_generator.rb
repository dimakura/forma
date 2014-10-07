# -*- encoding : utf-8 -*-
require 'forma/generators/html'
require 'forma/generators/utils'
require 'forma/generators/icon_generator'
require 'forma/generators/many_generator'

module Forma
  module FieldGeneratorMethods_viewers
    def viewer(field, opts)
      tag = tag_eval(field, opts)
      value = value_eval(field, opts)
      unless value.nil? or value == ''
        [ before_eval(field, opts),
          el(tag, [ viewer_body_eval(field, opts) ], { class: viewer_class_name_eval(field, opts) }),
          after_eval(field, opts)
        ].select{|x| x.present? }.join(' ')
      else
        el('span', [ '(empty)' ], { class: 'text-muted forma-empty-field' })
      end
    end

    def tag_eval(field, opts)
      tag = field.tag || 'span'
      if tag.instance_of?(Proc)
        model = model_eval(field, opts)
        tag.call(model)
      else
        tag.to_s
      end
    end

    def before_eval(field, opts)
      if opts[:before] or field.before
        el('span', { class: 'forma-field-before' }, [ " #{opts[:before] || field.before}" ])
      end
    end

    def after_eval(field, opts)
      if opts[:after] or field.after
        el('span', { class: 'forma-field-after' }, [ " #{opts[:after] || field.after}" ])
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
      if field.value then field.value
      elsif field.name then model_value( model_eval(field, opts), field.name )
      # elsif field.type == 'complex' then opts[:model] || field.model
      else opts[:model] || field.model
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

    def icon_eval(field, opts)
      icon = opts[:icon] || field.icon
      model = model_eval(field, opts)
      Forma::IconGenerator.to_html(icon, opts.merge(model: model)) if icon
    end

    def viewer_body_eval(field, opts)
      type = type_eval(field, opts)
      url = url_eval(field, opts)
      value = value_eval(field, opts)
      icon = icon_eval(field, opts)

      inner_html = case type
        when 'boolean' then viewer_for_boolean_eval(field, value, opts)
        when 'date'    then viewer_for_date_eval(field, value, opts)
        when 'complex' then viewer_for_complex_eval(field, value, opts)
        when 'array'   then viewer_for_array_eval(field, value, opts)
        when 'email'   then viewer_for_email_eval(field, value, opts)
        else value
      end

      inner_html = (if url then el('a', [ inner_html ], { href: url })
                    else inner_html end)

      inner_html = "#{icon} #{inner_html}" if icon

      inner_html
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

    def viewer_for_array_eval(field, values, opts)
      values.map do |value|
        el('div', { class: 'forma-array-field-child' }, field.fields.map do |fld|
          viewer(fld, { model: value })
        end)
      end.join(' ')
    end

    def viewer_for_email_eval(field, value, opts)
      el('a', { href: "mailto:#{value}" }, [ value ])
    end
  end

  module FieldGeneratorMethods_editors
    def editor(field, opts)
      if opts[:readonly] or field.readonly
        viewer(field, opts)
      else
        type = type_eval(field, opts)
        value = value_eval(field, opts)
        inner_html = case type
          # when 'boolean' then editor_for_boolean_eval(field, value, opts)
          # when 'date'    then editor_for_date_eval(field, value, opts)
          # when 'complex' then editor_for_complex_eval(field, value, opts)
          # when 'array'   then editor_for_array_eval(field, value, opts)
          when 'hidden' then editor_for_hidden_eval(field, value, opts)
          when 'text' then editor_for_text_eval(field, value, opts)
          when 'password' then editor_for_password_eval(field, value, opts)
          when 'combo' then editor_for_combo_eval(field, value, opts)
          when 'froala' then editor_for_froala_eval(field, value, opts)
          when 'many' then Forma::ManyGenerator.editor_for_many_eval(field, value, opts)
        end
      end
    end

    def editor_class_name_eval(field, opts)
      viewer_class = viewer_class_name_eval(field, opts)
      "#{viewer_class} form-control"
    end

    def editor_field_name_eval(field, opts)
      if opts[:name_prefix]
        "#{opts[:name_prefix]}[#{field.name}]"
      else
        "#{model_name_eval(field, opts)}[#{field.name}]"
      end
    end

    def editor_for_hidden_eval(field, value, opts)
      el('input', {
        name: editor_field_name_eval(field, opts),
        value: value.to_s,
        type: 'hidden',
        class: editor_class_name_eval(field, opts)
      })
    end

    def editor_for_text_eval(field, value, opts)
      params = {
        name: editor_field_name_eval(field, opts),
        value: value.to_s,
        autofocus: (not not field.autofocus),
        type: 'text',
        class: editor_class_name_eval(field, opts)
      }
      placeholder = opts[:placeholder] || field.placeholder
      params[:placeholder] = placeholder if placeholder.present?
      el('input', params)
    end

    def editor_for_password_eval(field, value, opts)
      params = {
        name: editor_field_name_eval(field, opts),
        value: value.to_s,
        autofocus: (not not field.autofocus),
        type: 'password',
        class: editor_class_name_eval(field, opts),
      }
      placeholder = opts[:placeholder] || field.placeholder
      params[:placeholder] = placeholder if placeholder.present?
      el('input', params)
    end

    def editor_for_combo_eval(field, value, opts)
      collection = field.collection
      children = []

      if collection.instance_of?(Hash)
        children = collection.map do |key, val|
          el('option', {
            selected: ( value.present? and key == value ),
            value: key
          }, [ val ])
        end
      elsif collection.respond_to?(:map) # array like
        children = collection.map do |obj|
          key = obj.id ; val = obj.to_s
          el('option', {
            selected: ( value.present? and key == value ),
            value: key.to_s
          }, [ val ])
        end
      end

      params = {}
      if field.placeholder.present?
        children.insert(0, el('option'))
        params['data-placeholder'] = field.placeholder
      end
      params[:class] = (field.select2 != false) ? 'forma-combo2-field' : 'forma-combo-field'
      params[:name] = editor_field_name_eval(field, opts)

      el('select', params, children)
    end

    def editor_for_froala_eval(field, value, opts)
      params = {
        class: 'forma-floara-field',
        name: editor_field_name_eval(field, opts),
      }
      placeholder = opts[:placeholder] || field.placeholder
      params[:placeholder] = placeholder if placeholder.present?
      el('textarea', params, [ value.to_s ])
    end

    def fields_with_label(object, opts)
      fields = object.fields ; model = opts[:model] || object.model
      newopts = opts.merge(model: model)
      label_width = opts[:label_width] || object.label_width || 200
      el('tbody', fields.map do |fld|
        if fld.hidden?
          fieldHtml = yield fld, newopts.merge(type: 'text')
          el('div', { style: 'display:none;' }, [ fieldHtml ])
        else
          hide_label = opts[:label] == false || ( opts[:label].nil? && fld.label == false )
          rowparams = {} ; cellparams = {}
          rowparams[:class] = 'forma-required' if ( fld.required )
          cellparams[:colspan] = 2 if hide_label
          fieldHtml = yield fld, newopts
          el('tr', rowparams, [
            ( el('th', [ label_eval(fld, newopts) ], { width: label_width }) unless hide_label ),
            el('td', cellparams, [ fieldHtml ])
          ])
        end
      end)
    end
  end

  class FieldGenerator
    extend Forma::HtmlMethods
    extend Forma::UtilsMethods
    extend FieldGeneratorMethods_viewers
    extend FieldGeneratorMethods_editors
  end
end
