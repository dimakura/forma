# -*- encoding : utf-8 -*-
module Forma::Html

  class Element

    # Text for this element.
    attr_accessor :text

    # Safe text for this element.
    attr_accessor :safe

    def initialize(tag, h = {})
      self.tag = tag
      h = h.symbolize_keys
      self.text = h[:text]
      self.safe = h[:safe]
      @attributes = Attributes.new(h[:attrs] || h[:attributes])
      h[:children].each { |c| self << c } if h[:children]
    end

    def tag
      @tag
    end

    def tag=(t)
      raise "element's tag should be defined" if t.blank?
      @tag = t.to_s.downcase
    end

    def attributes
      @attributes
    end

    alias_method :attrs, :attributes

    def children
      @children ||= []
    end

    def << (child)
      self.children << child
    end

    def [](k)
      self.attributes[k]
    end

    def []=(k,v)
      self.attributes[k] = v
    end

    def add_class(k)
      self.attributes.add_class(k)
    end

    def add_style(k,v)
      self.attributes.add_style(k,v)
    end

    def html
      generate_html
    end

    private

    def has_inner_content?
      self.text.present? or self.safe.present? or self.children.present?
    end

    def generate_html
      h = ''
      if has_inner_content?
        h << '<' << generate_tag_and_attributes << '>'
        h << generate_inner_html
        h << '</' << self.tag << '>'
      else
        h << '<' << generate_tag_and_attributes << '/>'
      end
      h
    end

    def generate_tag_and_attributes
      h = ''
      attrs = @attributes.html
      h << self.tag
      h << ' ' << attrs unless attrs.blank?
      h
    end

    def generate_inner_html
      h = ''
      h << ERB::Util.html_escape(self.text) unless self.text.blank?
      h << self.safe unless self.safe.blank?
      h << generate_children unless self.children.blank?
      h
    end

    def generate_children
      h = ''
      self.children.each { |c| h << c.html }
      h
    end

  end

end
