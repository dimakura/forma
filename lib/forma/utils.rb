# -*- encoding : utf-8 -*-
require 'action_controller'

module Forma
  module Utils
    include ActionView::Helpers::NumberHelper

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

    def number_format(num, h = {})
      max_digits = h[:max_digits] || 2
      max_digits = 0 if max_digits < 0
      min_digits = h[:min_digits] || 0
      min_digits = max_digits if min_digits > max_digits
      separator = h[:separator] || '.'
      delimiter = h[:delimiter] || ','
      formatted = number_with_precision(num, precision: max_digits, separator: separator, delimiter: delimiter, strip_insignificant_zeros: true)
      nums = formatted.split(separator)
      length_after_separator = (nums[1] || '').length
      if length_after_separator >= min_digits
        formatted
      else
        "#{nums[0]}#{separator}#{(nums[1] || '').ljust(min_digits, '0')}"
      end
    end

    module_function :singular_name
    module_function :extract_value
    module_function :number_format
  end
end
