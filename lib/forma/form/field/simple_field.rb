# -*- encoding : utf-8 -*-
module Forma::Form
  include Forma::Html

  class SimpleField < Field
    attr_accessor :name

    def caption_text
      self.caption || self.name.to_s.humanize
    end

    def value
      raise 'name not defined' if self.name.blank?
      val = self.model
      self.name.to_s.split('.').each { |k| val = val.send k } if val
      val
    end

    def view_element
      content = view_element_content
      if content
        view = Element.new('span')
        if content.is_a?(Element)
          view << content
        else
          view.text = content.to_s
        end
        view
      else
        nil
      end
    end

    def edit_element
      style = { width: "#{self.options.width}px" } if self.options.width
      Element.new('input', attrs: { type: 'text', value: self.value.to_s, style: style })
    end

    protected

    def view_element_content
      self.value
    end

  end

end
