# -*- encoding : utf-8 -*-
module Forma
  module Utils
    def singular_name(model)
      if model.respond_to?(:model_name); model.model_name.singular_route_key # Mongoid
      elsif model.class.respond_to?(:table_name); model.class.table_name.singularize # ActiveModel
      else; '' # Others
      end
    end

    def extract_value(val, name)
      def simple_value(model, name)
        if model.respond_to?(name); model.send(name)
        elsif model.respond_to?('[]'); model[name] || model[name.to_sym]
        end
      end
      name.to_s.split('.').each { |n| val = simple_value(val, n) if val }
      val
    end

    module_function :singular_name
    module_function :extract_value
  end
end
