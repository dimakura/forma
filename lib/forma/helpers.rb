# -*- encoding : utf-8 -*-
require 'forma/model'

module Forma
  module Helpers

    def table_for(models, opts = {})
      table = Forma::Table.new(opts.merge(models: models))
      yield table if block_given?
      table.viewer_html
    end

    def viewer_for(model, opts = {})
      viewer = Forma::Viewer.new(opts.merge(model: model))
      yield viewer if block_given?
      viewer.to_html
    end

    module_function :table_for
  end
end
