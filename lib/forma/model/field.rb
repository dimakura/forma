# -*- encoding : utf-8 -*-
require 'forma/auto_initialize'
require 'forma/generators/field_generator'

module Forma

  class Field
    include Forma::AutoInitialize

    def viewer_html; Forma::FieldGenerator.viewer_html(self) end
    def editor_html; Forma::FieldGenerator.editor_html(self) end
  end

end
