# -*- encoding : utf-8 -*-
require 'action_controller'

module Forma::Form

  class NumberField < SimpleField
    include Forma::Html
    include Forma::Init
    include ActionView::Helpers::NumberHelper

    attr_accessor :precision
    attr_accessor :delimiter
    attr_accessor :separator

    protected

    def view_element_content
      Element.new('code', text: formatted_value) unless self.value.blank?
    end

    private

    def formatted_value
      prec = self.precision || 2
      dlmt = self.delimiter || Forma.config.num.delimiter
      sprt = self.separator || Forma.config.num.separator
      number_with_precision(self.value, precision: prec, delimiter: dlmt, separator: sprt)
    end

  end

end
