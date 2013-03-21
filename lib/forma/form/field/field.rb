# -*- encoding : utf-8 -*-
module Forma::Form
  include Forma::Html

  class Field
    include Forma::Init
    attr_accessor :caption
    attr_accessor :before
    attr_accessor :after
    attr_accessor :required
    attr_accessor :readonly
    attr_accessor :tooltip

    def initialize(h = {})
      h = h.symbolize_keys
      h[:required] = h[:required] == true
      h[:readonly] = h[:readonly] == true
      super(h)
    end

    def cell_node(h = {})
      h = h.symbolize_keys
      cell_node = Element.new('div', attrs: { class: 'ff-cell' })
      cell_node << content_node(h[:edit] == true) rescue
      cell_node
    end

    protected

    def content_node(edit)
      edit = false if self.readonly
      edit ? self.edit_node : self.view_node
    end

  end

end
