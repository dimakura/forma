# -*- encoding : utf-8 -*-
require 'forma/form/main/field_helper'

module Forma::Form

  # Form's tab.
  class FormTab
    include Forma::Html
    include Forma::Init
    include Forma::Form::FieldHelper

    attr_accessor :title
    attr_accessor :icon

    def initialize(h = {})
      @columns = [ FormColumn.new, FormColumn.new ]
      super(h)
    end

    # Are there any fields in any of the columns?
    def empty?
      self.col1.empty? and self.col2.empty?
    end

    # Returns the first column of this tab.
    def col1
      @columns[0]
    end

    # Returns the second column of this tab.
    def col2
      @columns[1]
    end

    # Adds field to the first column of this tab.
    def << f
      self.col1 << f
    end

    # Returns all fields in this tab.
    def fields
      col1.fields + col2.fields
    end

    def to_e
      unless self.empty?
        cols = Element.new('div', attrs: { class: 'ff-form-cols' })
        c1 = self.col1.to_e
        c2 = self.col2.to_e
        if c1 and c2
          c1.add_class('ff-col50')
          c2.add_class('ff-col50')
          cols << c1 << c2
        else
          c1.add_class('ff-col100')
          cols << c1
        end
        Element.new('div', attrs: { ensure_id: true, class: 'ff-form-tab-content' }, children: [ cols ])
      end
    end

  end

end
