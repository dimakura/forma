# -*- encoding : utf-8 -*-
require 'forma/generators/html'
require 'forma/generators/field_generator'

module Forma
  module ViewerGenerator
    extend Forma::Html

    def to_html(v, opts={}); viewer(v, opts) end

    module_function :to_html

## Viewer generator functions

    def viewer(v, opts)
      label_width = opts[:label_width] || v.label_width || 200
      el('table', { class: 'table table-bordered table-striped forma-viewer' }, [
        el('tbody', v.fields.map do |fld|
          newopts = opts.merge(model: v.model)
          rowparams = {}
          rowparams[:class] = 'forma-required' if ( opts[:required] || fld.required )
          el('tr', rowparams, [
            el('th', [ Forma::FieldGenerator.label_eval(fld, newopts) ], { width: label_width }),
            el('td', [ Forma::FieldGenerator.viewer(fld, newopts) ])
          ])
        end)
      ])
    end

    module_function :viewer
  end
end
