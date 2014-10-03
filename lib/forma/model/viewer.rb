# -*- encoding : utf-8 -*-
require 'forma/model'
require 'forma/generators/viewer_generator'

module Forma
  class Viewer < Forma::WithFields
    
    def to_html(opts={})
      Forma::ViewerGenerator.to_html(self, opts)
    end

  end
end
