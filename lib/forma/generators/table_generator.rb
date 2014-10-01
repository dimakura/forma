# -*- encoding : utf-8 -*-
require 'forma/generators/html'

module Forma
  module TableGenerator
    class ViewerGenerator
      include Forma::Html

      def initialize(table)
        @table = table
      end

      def to_html(opts)
        el('table')
      end

      private

      
    end

    def viewer_html(field, opts={})
      ViewerGenerator.new(field).to_html(opts)
    end

    # def editor_html(field)
    #   '<p>editor</p>'
    # end

    module_function :viewer_html
    # module_function :editor_html
  end
end
