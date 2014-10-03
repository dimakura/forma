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
      label_width = opts[:label_width] || e.label_width || 200
      el('table', { class: 'table table-bordered table-striped forma-editor' }, [
        el('tbody', e.fields.map do |fld|
          newopts = opts.merge(model: e.model)
          rowparams = {}
          rowparams[:class] = 'forma-required' if ( fld.required )
          el('tr', rowparams, [
            el('th', [ Forma::FieldGenerator.label_eval(fld, newopts) ], { width: label_width }),
            el('td', [ fld.editor_html( newopts ) ])
          ])
        end),
        el('tfoot', [ el('tr', [
            el('td', { colspan: 2 }, [
              el('button', { type: 'submit', class: 'btn btn-primary' }, [ opts[:submit] || e.submit || 'Save' ])
            ])
          ])
        ]) #if e.submit != false
      ])
    end

    module_function :editor
  end
end
