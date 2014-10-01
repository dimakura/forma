# -*- encoding : utf-8 -*-
require 'forma/generators/html'

module Forma
  module FieldGenerator
    class ViewerGenerator
      include Forma::Html

      def initialize(field)
        @field = field
        @type = @field.type || 'text'
      end

      def to_html
        el('span', [ value_eval ], { class: class_name_eval })
      end

      private

      def value_eval
        if @field.value
          @field.value
        elsif @field.model and @field.name
          if @field.model.instance_of?(Hash)
            @field.model[ @field.name.to_sym ]
          else
            @field.model.send( @field.name.to_sym )
          end
        end
      end

      def class_name_eval
        "forma-#{@type}-field"
      end
    end

    def viewer_html(field)
      ViewerGenerator.new(field).to_html
    end

    def editor_html(field)
      '<p>editor</p>'
    end

    module_function :viewer_html
    module_function :editor_html
  end
end
