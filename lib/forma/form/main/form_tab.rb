# -*- encoding : utf-8 -*-
module Forma::Form

  # Form's tab.
  class FormTab
    include Forma::Html
    include Forma::Init

    attr_accessor :title
    attr_accessor :icon

    def initialize(h = {})
      @columns = [ FormColumn.new, FormColumn.new ]
      super(h)
    end

    def empty?
      self.col1.empty? and self.col2.empty?
    end

    def col1
      @columns[0]
    end

    def col2
      @columns[1]
    end

    def << f
      self.col1 << f
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
