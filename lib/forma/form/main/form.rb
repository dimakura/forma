# -*- encoding : utf-8 -*-
module Forma::Form

  # Form.
  class Form
    include Forma::Html
    include Forma::Init
    attr_accessor :title
    attr_accessor :icon
    attr_accessor :collapsible
    attr_accessor :collapsed

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
      update_fields
      form = Element.new('div', attrs: { class: 'ff-form', ensure_id: true })
      form << title_element
      form << form_body_element
      form
    end

    private

    def update_fields
      self.fields.each {|f| f.model = self.model }
    end

    def title_element
      if self.title
        active = title = Element.new('div', attrs: { class: 'ff-title' })
        if self.collapsible
          active = Element.new('span', attrs: { class: 'ff-collapsible'} )
          collapse = Element.new('span', attrs: {class: 'ff-collapse'})
          collapse.add_class('ff-collapsed') if self.collapsed
          # active.add_class('ff-collapsed') if self.collapsed
          active << collapse
          title << active
        end
        active << Element.new('img', attrs: { class: 'ff-icon', src: self.icon } ) if self.icon
        active << Element.new('span', attrs: { class: 'ff-title-text' }, text: self.title)
        title
      end
    end

    def form_body_element
      body = Element.new('div', attrs: { class: 'ff-form-body' })
      body[:style][:display] = 'none' if self.collapsed
      tabs = Element.new('div', attrs: { class: 'ff-tabs' })
      self.tabs.each { |t|  tabs << t.to_e }
      if tabs.children.size > 1
        tabsHeader = Element.new('ul', attrs: { class: 'ff-tabs-header' })
        self.tabs.each do |t|
          index = tabsHeader.children.size
          tabid = tabs.children[index][:id]
          tab = Element.new('li', text: t.title, attrs: { 'data-tabid' => tabid })
          tab.add_class('ff-selected') if index == 0
          tabs.children[index].add_class('ff-hidden-tab') unless index == 0
          tabsHeader << tab
        end
        body << tabsHeader
      end
      body << tabs
      body
    end

  end

end
