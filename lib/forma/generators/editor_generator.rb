# -*- encoding : utf-8 -*-
require 'forma/generators/html'
require 'forma/generators/field_generator'

module Forma
  module EditorGenerator
    extend Forma::Html

    def to_html(e, opts={}); editor(e, opts) end

    module_function :to_html

## Viewer generator functions

    def editor(e, opts)
      action = opts[:url] || e.url
      method = opts[:http_method] || e.http_method || 'post'
      el('form', { class: 'forma-editor', action: action, method: method }, [
        el('table', { class: 'table table-bordered table-striped' }, [
          editor_fields_eval(e, opts),
          editor_bottom_eval(e, opts),
        ])
      ])
    end

    def editor_fields_eval(e, opts)
      label_width = opts[:label_width] || e.label_width || 200
      el('tbody', e.fields.map do |fld|
        newopts = opts.merge(model: e.model)
        rowparams = {}
        rowparams[:class] = 'forma-required' if ( fld.required )
        el('tr', rowparams, [
          el('th', [ Forma::FieldGenerator.label_eval(fld, newopts) ], { width: label_width }),
          el('td', [ fld.editor_html( newopts ) ])
        ])
      end)
    end

    def editor_bottom_eval(e, opts)
      el('tfoot', [
        el('tr', [
          el('td', { colspan: 2 }, [
            el('button', { type: 'submit', class: 'btn btn-primary' }, [ opts[:submit] || e.submit || 'Save' ])
          ])
        ])
      ])
      # TODO: add bottom action!
    end

    module_function :editor
    module_function :editor_fields_eval
    module_function :editor_bottom_eval
  end
end
