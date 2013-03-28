# -*- encoding : utf-8 -*-
module Forma::Form

  # Form.
  class Form
    include Forma::Html

    attr_accessor :fields

    def Form(h = {})
      fields = FormFields.new
    end

  end

  # Form's tab.
  class FormTab
    # TODO:
  end

  # Form's column.
  class FormColumn

    def initialize
      @fields = []
    end

    def fields
      @fields
    end

    def empty?
      self.fields.empty?
    end

    def size
      self.fields.size
    end

    def << f
      @fields << f
    end

    def to_e
      # TODO:
    end

  end

end
