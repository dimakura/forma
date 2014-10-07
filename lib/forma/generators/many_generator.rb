require 'forma/generators/html'
require 'forma/generators/utils'
require 'forma/generators/icon_generator'
require 'forma/generators/field_generator'

module Forma
  module ManyGenerator
    extend Forma::HtmlMethods
    extend Forma::Utils

    def editor_for_many_eval(field, values, opts)
      name = Forma::FieldGenerator.model_name_eval(field, opts)
      newopts = opts.merge(name_prefix: name)

      el('div', { class: 'forma-many-fields' }, [
        ##
      ])
    end

    module_function :editor_for_many_eval
  end
end
