# -*- encoding : utf-8 -*-
require 'forma/model'

module Forma
  module Helpers

    def table_for(models, opts = {})
      table = Forma::Table.new(opts.merge(models: models))
      yield table if block_given?
      table.viewer_html
    end

    module_function :table_for
  end
end
