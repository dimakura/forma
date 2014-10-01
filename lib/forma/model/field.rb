# -*- encoding : utf-8 -*-
require 'forma/auto_initialize'
require 'forma/generators/field_generator'

module Forma

  class Field
    include Forma::AutoInitialize

    def viewer_html(opts={}); Forma::FieldGenerator.viewer_html(self, opts) end
    def editor_html(opts={}); Forma::FieldGenerator.editor_html(self, opts) end
  end

end
