module Forma
  module Utils
    def singular_name(model)
      if model.respond_to?(:model_name); model.model_name.singular_route_key # Mongoid
      elsif model.class.respond_to?(:table_name); model.class.table_name.singularize # ActiveModel
      else; '' # Others
      end
    end

    module_function :singular_name
  end
end
