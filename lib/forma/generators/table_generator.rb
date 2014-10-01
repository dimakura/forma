# -*- encoding : utf-8 -*-
require 'forma/generators/html'
require 'forma/generators/field_generator'

module Forma
  module TableGenerator
    extend Forma::Html

    def viewer_html(table, opts={}); viewer(table, opts) end

    module_function :viewer_html

## Viewer generator functions

    def viewer(table, opts)
      models = models_eval(table, opts)
      if models and models.any?
        table_eval(table, opts)
      else
        empty_table_eval(table, opts)
      end
    end

    def empty_table_eval(table, opts)
      el({ class: 'forma-no-data' }, [ 'no-data' ])
    end

    def table_eval(table, opts)
      el('table', { class: class_name_eval(table, opts) }, [
        table_header_eval(table, opts),
        table_body_eval(table, opts)
      ])
    end

    def class_name_eval(table, opts); 'table table-bordered table-striped' end
    def models_eval(table, opts); opts[:models] || table.models end

    def table_header_eval(table, opts)
      models = models_eval(table, opts)
      firstModel = models ? models.first : nil
      el('thead', [
        el('tr', table.fields.map do |field|
          el('th', [ Forma::FieldGenerator.label_eval(field, { model: firstModel }) ])
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
    module_function :models_eval
    module_function :table_eval
    module_function :class_name_eval
    module_function :table_header_eval
    module_function :table_body_eval
    module_function :empty_table_eval
  end
end
