# -*- encoding : utf-8 -*-
require 'forma/model'
require 'forma/generators/editor_generator'

module Forma
  class Editor < Forma::WithFields
    include Forma::WithActions

    def to_html(opts={})
      Forma::EditorGenerator.to_html(self, opts)
    end

  end
end
