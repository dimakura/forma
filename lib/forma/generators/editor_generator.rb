# -*- encoding : utf-8 -*-
require 'forma/generators/html'
require 'forma/generators/action_generator'
require 'forma/generators/field_generator'

module Forma
  module EditorGenerator
    extend Forma::HtmlMethods

    def to_html(e, opts={}); editor(e, opts) end

    module_function :to_html

## Viewer generator functions

    def editor(e, opts)
      action = opts[:url] || e.url
      method = opts[:http_method] || e.http_method || 'post'
      el('form', { class: 'forma-editor', action: action, method: method }, [
        authtoken_eval(e, opts),
        el('table', { class: 'table table-bordered table-striped' }, [
          editor_fields_eval(e, opts),
          editor_bottom_eval(e, opts),
        ])
      ])
    end

    def authtoken_eval(e, opts)
      auth_token = opts[:auth_token] || e.auth_token
      if auth_token.present?
        el({ style: 'padding:0;margin:0;height:0;width:0;display:"inline"' }, [
          el('input', { type: 'hidden', name: 'authenticity_token', value: auth_token })
        ])
      end
    end

    def editor_fields_eval(e, opts)
      Forma::FieldGenerator.fields_with_label(e, opts) do |fld, newopts|
        fld.editor_html( newopts )
      end
    end

    def editor_bottom_eval(e, opts)
      actions_html = actions_eval(e, {})
      el('tfoot', [
        el('tr', [
          el('td', { colspan: 2 }, [
            el('button', { type: 'submit', class: 'btn btn-primary' }, [ opts[:submit] || e.submit || 'Save' ]),
            " #{actions_html}"
          ])
        ])
      ])
    end

    def actions_eval(e, opts)
      (e.actions.map do |act|
        Forma::ActionGenerator.to_html(act, opts)
      end.join(' ')) if e.actions
    end

    module_function :editor
    module_function :editor_fields_eval
    module_function :editor_bottom_eval
    module_function :authtoken_eval
    module_function :actions_eval
  end
end
