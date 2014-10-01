# -*- encoding : utf-8 -*-
require 'forma/auto_initialize'
require 'forma/generators/table_generator'

module Forma

  class Table
    include Forma::AutoInitialize

    def viewer_html(opts={}); Forma::TableGenerator.viewer_html(self, opts) end
    # def editor_html(opts={}); Forma::TableGenerator.editor_html(self, opts) end
  end

end
