# -*- encoding : utf-8 -*-
require 'forma/generators/html'
require 'forma/generators/action_generator'
require 'forma/generators/field_generator'

module Forma
  module TableGenerator
    extend Forma::Html

    def viewer_html(table, opts={}); viewer(table, opts) end

    module_function :viewer_html

## Viewer generator functions

    def viewer(table, opts)
      children = nil
      models = models_eval(table, opts)
      if models and models.any?
        children = table_eval(table, opts)
      else
        children = empty_table_eval(table, opts)
      end
      el('table', { class: class_name_eval(table, opts) }, children)
    end

    def empty_table_eval(table, opts)
      [
        table_header_eval(table, opts),
        el('tbody', [
          el('tr', [
            el('td', {
              colspan: table.fields.size,
              class: 'forma-no-data'
            }, [ (opts[:empty_text] || table.empty_text || 'no-data') ])
          ])
        ])
      ]
    end

    def table_eval(table, opts)
      children = nil
      [
        table_header_eval(table, opts),
        table_body_eval(table, opts)
      ]
    end

    def class_name_eval(table, opts); 'forma-table table table-bordered table-striped table-hover' end
    def models_eval(table, opts); opts[:models] || table.models end
    def column_count_eval(table, opts); table.fields.size end

    def hide_header_eval(table, opts)
      hide_header = false
      hide_header = true if (not opts[:hide_header].nil? and opts[:hide_header])
      hide_header = true if (not table.hide_header.nil? and table.hide_header)
      hide_header
    end

    def table_header_eval(table, opts)
      hide_header = hide_header_eval(table, opts)
      models = models_eval(table, opts)
      first_model = (models and models.any?) ? models.first : nil
      model_name = opts[:model_name] || table.model_name
      col_count = column_count_eval(table, opts)

      header_html = ''
      unless hide_header
        header_html = el('tr', table.fields.map do |field|
          width = opts[:width] || field.width
          th_opts = { width: width } if width
          el('th', th_opts, [ Forma::FieldGenerator.label_eval(field, { model: first_model, model_name: model_name }) ])
        end)
      end

      actions_html = ''
      if table.actions and table.actions.any?
        actions_html = actions_eval(table, {})
        actions_html = el('tr', { class: 'forma-actions' }, [ el('td', { colspan: col_count }, [ actions_html ]) ])
      end

      if header_html.present? or actions_html.present?
        el('thead', [
          ( actions_html if actions_html.present? ),
          ( header_html if header_html.present? ),
        ])
      end
    end

    def table_body_eval(table, opts)
      models = opts[:models] || table.models
      el('tbody', models.map do |model|
        el('tr',  table.fields.map do |field|
          el('td', [ Forma::FieldGenerator.viewer(field, { model: model }) ])
        end)
      end)
    end

    def actions_eval(table, opts)
      (table.actions.map do |act|
        Forma::ActionGenerator.to_html(act, opts)
      end.join(' ')) if table.actions
    end

    module_function :viewer
    module_function :models_eval
    module_function :table_eval
    module_function :class_name_eval
    module_function :table_header_eval
    module_function :table_body_eval
    module_function :empty_table_eval
    module_function :column_count_eval
    module_function :hide_header_eval
    module_function :actions_eval
  end
end
