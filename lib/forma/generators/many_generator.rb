require 'forma/generators/html'
require 'forma/generators/utils'
require 'forma/generators/icon_generator'
require 'forma/generators/field_generator'
require 'forma/generators/editor_generator'

module Forma
  module ManyGeneratorMethods
    def editor_for_many_eval(field, values, opts)

      field_name = Forma::FieldGenerator.editor_field_name_eval(field, opts)

      fields = field.fields
      fields << Forma::Field.new(name: 'id', type: 'hidden')
      editor = Forma::Editor.new(fields: fields)
      
      editors_html = values.map do |value|
        newopts = opts.merge({ model: value, name_prefix: field_name })
        fields_html = Forma::EditorGenerator.editor_fields_eval(editor, newopts)
        editor_html = el('table', { class: 'table table-condensed' }, [ fields_html ])
        el('div', { class: 'forma-many-field' }, [ editor_html ])
      end.join

      el('div', { class: 'forma-many-fields' }, [ editors_html ])
    end
  end

  module ManyGenerator
    extend Forma::HtmlMethods
    extend Forma::UtilsMethods
    extend ManyGeneratorMethods
  end
end
