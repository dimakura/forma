# -*- encoding : utf-8 -*-
require 'forma/generators/html'
require 'forma/generators/action_generator'
require 'forma/generators/field_generator'

module Forma
  module ViewerGeneratorMethods
    def to_html(v, opts={}); viewer(v, opts) end

    def viewer(v, opts)
      actions_html = actions_eval(v, {})
      el('table', { class: 'table table-bordered table-striped forma-viewer' }, [
        (el('thead', [
          el('tr', { class: 'forma-actions' }, [
            el('td', { colspan: 2 }, [ actions_html ])
          ])
        ]) if actions_html.present?),
        Forma::FieldGenerator.fields_with_label(v, opts) do |fld, newopts|
          fld.viewer_html( newopts )
        end
      ])
    end

    def actions_eval(v, opts)
      (v.actions.map do |act|
        Forma::ActionGenerator.to_html(act, opts)
      end.join(' ')) if v.actions
    end
  end

  class ViewerGenerator
    extend Forma::HtmlMethods
    extend ViewerGeneratorMethods
  end
end
