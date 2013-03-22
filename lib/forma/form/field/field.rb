# -*- encoding : utf-8 -*-

# This is an "abstract" class which doesn't display any data at all.
# Subclasses of this class should implement `view_element` and `edit_element`
# methods to display some real data. If you don't define these methods or using
# `Forma::Form::Field` directly, then nothing will be rendered.
#
module Forma::Form
  include Forma::Html

  class Field
    include Forma::Init
    attr_accessor :model
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

    def cell_element(h = {})
      h = h.symbolize_keys
      cell = Element.new('div', attrs: { class: 'ff-cell' })
      cell << before_element
      cell << content_element(h[:edit] == true)
      cell << after_element
      cell
    end

    protected

    def span_element(klass, content)
      span = Element.new('span', attrs: { class: klass })
      content = content.call(self.model) if content.is_a?(Proc) and self.model
      span.text = content.to_s
      span
    end

    def before_element
      span_element('ff-before', self.before) if self.before
    end

    def after_element
      span_element('ff-after', self.after) if self.after
    end

    def content_element(edit)
      edit = false if self.readonly
      if edit
        self.edit_element if respond_to?(:edit_element)
      else
        self.view_element if respond_to?(:view_element)
      end
    end

  end

end
