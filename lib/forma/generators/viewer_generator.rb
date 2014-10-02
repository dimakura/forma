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
      el('div', { class: 'forma-viewer' }, [ columns_eval(v, opts) ])
    end

    def columns_eval(v, opts)
      column_eval(v, v.col1, opts)
      # TODO: second column
    end

    def column_eval(v, col, opts)
      label_width = opts[:label_width] || v.label_width || 200
      el('table', { class: 'table table-bordered table-striped forma-viewer-column' }, [
        el('tbody', col.fields.map do |fld|
          newopts = opts.merge(model: v.model)
          el('tr', [
            el('th', [ Forma::FieldGenerator.label_eval(fld, newopts) ], { width: label_width }),
            el('td', [ Forma::FieldGenerator.viewer(fld, newopts) ])
          ])
        end)
      ])
    end

    module_function :viewer
    module_function :columns_eval
    module_function :column_eval
  end
end
