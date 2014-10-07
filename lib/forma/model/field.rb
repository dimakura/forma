# -*- encoding : utf-8 -*-
require 'forma/auto_initialize'
require 'forma/generators/field_generator'

module Forma
  class Field < Forma::WithFields
    def viewer_html(opts={}); Forma::FieldGenerator.viewer(self, opts) end
    def editor_html(opts={}); Forma::FieldGenerator.editor(self, opts) end

    def hidden?; self.type == 'hidden' end
  end
end
