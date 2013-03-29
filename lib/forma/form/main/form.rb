# -*- encoding : utf-8 -*-
module Forma::Form

  # Form.
  class Form
    include Forma::Html
    include Forma::Init
    attr_accessor :title
    attr_accessor :icon

    def initialize(h = {})
      h = h.symbolize_keys
      @tabs = [ FormTab.new ]
      @model = h.delete(:model)
      fields = h.delete(:fields)
      super(h)
      fields.each { |f| self << f } if fields
    end

    def model
      @model
    end

    def model=(m)
      @model = m
      self.fields.each {|f| f.model = m }
    end

    def tabs
      @tabs
    end

    def fields
      @tabs.inject([]) { |fields, tab| fields += tab.fields }
    end

    def << f
      tabs[0] << f
      f.model = @model
    end

    def to_e(h = {})
      form = Element.new('div', attrs: { class: 'ff-form' })
      form << title_element
      form << form_body_element
      form
    end

    private

    def title_element
      if self.title
        title = Element.new('div', attrs: { class: 'ff-title' })
        title << Element.new('img', attrs: { class: 'ff-icon', src: self.icon } ) if self.icon
        title << Element.new('span', attrs: { class: 'ff-title-text' }, text: self.title)
        title
      end
    end

    def form_body_element
      body = Element.new('div', attrs: { class: 'ff-form-body' })
      self.tabs.each { |t|  body << t.to_e }
      body
    end

  end

end
