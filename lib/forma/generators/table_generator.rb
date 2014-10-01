# -*- encoding : utf-8 -*-
require 'forma/generators/html'
require 'forma/generators/field_generator'

module Forma
  module TableGenerator
    extend Forma::Html

    def viewer_html(table, opts={}); viewer(table, opts) end

    # def editor_html(field)
    #   '<p>editor</p>'
    # end

    module_function :viewer_html
    # module_function :editor_html

## Viewer generator functions

    def viewer(table, opts)
      el('table', { class: class_name_eval(table, opts) }, [
        table_header_eval(table, opts),
        table_body_eval(table, opts)
      ])
    end

    def class_name_eval(table, opts); 'table' end

    def table_header_eval(table, opts)
      el('thead', [
        el('tr', table.fields.map do |field|
          el('th', [ Forma::FieldGenerator.label_eval(field, {}) ])
        end)
      ])
    end

    def table_body_eval(table, opts)
      models = opts[:models] || table.models
      el('tbody', models.map do |model|
        el('tr',  table.fields.map do |field|
          el('td', [ Forma::FieldGenerator.viewer(field, { model: model }) ])
        end)
      end)
    end

    module_function :viewer
    module_function :class_name_eval
    module_function :table_header_eval
    module_function :table_body_eval
  end
end
