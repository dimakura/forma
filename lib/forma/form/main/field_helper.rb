# -*- encoding : utf-8 -*-
module Forma
  module Form
    module FieldHelper
      def text_field(name, opts={})
        opts[:name] = name
        self << Forma::Form::TextField.new(opts)
      end

      def number_field(name, opts={})
        opts[:name] = name
        self << Forma::Form::NumberField.new(opts)
      end

      def date_field(name, opts={})
        opts[:name] = name
        self << Forma::Form::DateField.new(opts)
      end

      def datetime_field(name, opts={})
        opts[:name] = name
        self << Forma::Form::DateTimeField.new(opts)
      end
    end
  end
end
