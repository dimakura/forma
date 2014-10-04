# -*- encoding : utf-8 -*-
require 'forma/generators/html'
require 'forma/generators/action_generator'
require 'forma/generators/field_generator'

module Forma
  module ViewerGenerator
    extend Forma::Html

    def to_html(v, opts={}); viewer(v, opts) end

    module_function :to_html

## Viewer generator functions

    def viewer(v, opts)
      label_width = opts[:label_width] || v.label_width || 200
      actions_html = actions_eval(v, {})
      el('table', { class: 'table table-bordered table-striped forma-viewer' }, [
        (el('thead', [ el('tr', { class: 'forma-actions' }, [ el('td', { colspan: 2 }, [ actions_html ]) ]) ]) if actions_html.present?),
        el('tbody', v.fields.map do |fld|
          newopts = opts.merge(model: v.model)
          rowparams = {}
          rowparams[:class] = 'forma-required' if ( fld.required )
          el('tr', rowparams, [
            el('th', [ Forma::FieldGenerator.label_eval(fld, newopts) ], { width: label_width }),
            el('td', [ fld.viewer_html( newopts ) ])
          ])
        end)
      ])
    end

    def actions_eval(v, opts)
      (v.actions.map do |act|
        Forma::ActionGenerator.to_html(act, opts)
      end.join(' ')) if v.actions
    end

    module_function :viewer
    module_function :actions_eval
  end
end
