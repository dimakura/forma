# -*- encoding : utf-8 -*-
module Forma::Form

  # Form's column.
  class FormColumn
    include Forma::Html

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

    def to_e(h = {})
      unless self.empty?
        h = h.symbolize_keys
        fld_opts = h.delete(:field) || {}
        fields = self.fields.map{ |f| f.to_e(:field, fld_opts) }
        columnInner = Element.new('div', attrs: { class: 'ff-form-col-inner' }, children: fields)
        Element.new('div', attrs: { class: 'ff-form-col' }, children: [ columnInner ])
      end
    end

  end

end
