# -*- encoding : utf-8 -*-
require 'forma/model'
require 'forma/generators/editor_generator'

module Forma
  class Editor < Forma::WithFields
    
    def to_html(opts={})
      Forma::EditorGenerator.to_html(self, opts)
    end

  end
end
