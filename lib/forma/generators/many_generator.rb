require 'forma/generators/html'
require 'forma/generators/utils'
require 'forma/generators/icon_generator'
require 'forma/generators/field_generator'
require 'forma/generators/editor_generator'

module Forma
  module ManyGeneratorMethods
    def editor_for_many_eval(field, values, opts)
      editors_html = editors_eval(field, values, opts)
      actions_html = actions_eval(field, values, opts)
      el('div', { class: 'forma-many-fields' }, [
        el('div', { class: 'forma-many-editors' }, [ editors_html ]),
        el('div', { class: 'forma-many-actions' }, [ actions_html ])
      ])
    end

    def editors_eval(field, values, opts)
      values.each_with_index.map do |value, index|
        single_editor_eval(field, value, index, opts)
      end.join
    end

    def single_editor_eval(field, value, index, opts)
      field_name = Forma::FieldGenerator.editor_field_name_eval(field, opts.merge(attributes: true))
      field_name = "#{field_name}[#{index}]"
      editor = Forma::Editor.new(field.options)
      newopts = opts.merge({ model: value, name_prefix: field_name })
      fields_html = Forma::EditorGenerator.editor_fields_eval(editor, newopts)
      editor_html = el('table', { class: 'table table-condensed' }, [ fields_html ])

      id_field = Forma::Field.new(name: 'id', type: 'hidden', class_name: 'forma-id').editor_html(newopts)
      destroy_field = Forma::Field.new(name: '_destroy', type: 'hidden', class_name: 'forma-destroy').editor_html(newopts)

      actions_html = el('div', { class: 'forma-many-field-actions' }, [
        el('a', { href: '#', class: 'forma-many-field-remove' }, [
          [ Forma::IconGenerator.to_html('trash-o'),
           (opts[:remove_text] || field.remove_text) ].join(' ').strip
        ])
      ])

      el('div', { class: 'forma-many-field' }, [ editor_html, id_field, destroy_field, actions_html ])
    end

    def actions_eval(field, values, opts)
      add_text = opts[:add_text] || field.add_text || 'add'
      el('a', { class: 'forma-many-action', href: '#' }, [
        Forma::IconGenerator.to_html('plus'), ' ', add_text,
        action_script_eval(field, values, opts)
      ])
    end

    def action_script_eval(field, values, opts)
      el('script', { type: 'forma-script' }, [
        single_editor_eval(field, {}, 0, opts)
      ])
    end
  end

  module ManyGenerator
    extend Forma::HtmlMethods
    extend Forma::UtilsMethods
    extend ManyGeneratorMethods
  end
end
