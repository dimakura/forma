# -*- encoding : utf-8 -*-

# This is an "abstract" class which doesn't display any data at all.
# Subclasses of this class should implement `view_element` and `edit_element`
# methods to display some real data. If you don't define these methods or using
# `Forma::Form::Field` directly, then nothing will be rendered.
#
module Forma::Form

  class Field
    include Forma::Html
    include Forma::Init

    attr_accessor :model
    attr_accessor :caption
    attr_accessor :before
    attr_accessor :after
    attr_accessor :required
    attr_accessor :readonly
    attr_accessor :tooltip
    attr_accessor :options

    def initialize(h = {})
      h = h.symbolize_keys
      h[:required] = h[:required] == true
      h[:readonly] = h[:readonly] == true
      self.options = FieldOptions.new(h.delete(:options))
      super(h)
    end

    # Convert given field to `Forma::Html::Element`.
    #
    # You should pass `type` parameter to define what kind of element is intended for use.
    # Valid options for `type` parameter are `cell`, `caption` and `field` (default).
    # `nil` is returned for illegal option.
    def to_e(type = 'field', h = {})
      self.send("#{type}_element", h) if ['cell', 'caption', 'field'].include?(type.to_s)
    end

    def cell_element(h = {})
      h = h.symbolize_keys
      cell = Element.new('div', attrs: { class: 'ff-cell' })
      cont = content_element(h[:edit] == true)
      if cont
        cell << before_element
        cont.add_class('ff-content')
        cont[:title] = self.tooltip if self.tooltip.present?
        cell << cont
        cell << after_element
      else
        cell << empty_element
      end
      cell
    end

    def caption_element(h = {})
      h = h.symbolize_keys
      label = Element.new('div', attrs: { class: 'ff-caption' }, text: self.caption)
      label.add_class('ff-required') if self.required
      label
    end

    def field_element(h = {})
      field = Element.new('div', attrs: { class: 'ff-field' })
      field << caption_element(h)
      field << cell_element(h)
      field
    end

    protected

    def empty_element
      span_element([ 'ff-empty', 'ff-content' ], Forma.config.texts.empty)
    end

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

  class FieldOptions
    include Forma::Init
    attr_accessor :width
    attr_accessor :height
  end

end
