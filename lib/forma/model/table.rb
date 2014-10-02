# -*- encoding : utf-8 -*-
require 'forma/model'
require 'forma/generators/table_generator'

module Forma
  class Table < Forma::WithFields

    def viewer_html(opts={})
      raise 'no fields defined' unless self.fields
      Forma::TableGenerator.viewer_html(self, opts)
    end

  end
end
