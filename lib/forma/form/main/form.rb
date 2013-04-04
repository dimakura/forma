# -*- encoding : utf-8 -*-
require 'forma/form/main/tab_helper'

module Forma::Form

  # Form.
  class Form
    include Forma::Html
    include Forma::Init
    include Forma::Form::TabHelper

    # Title for this form.
    attr_accessor :title
    attr_accessor :icon
    # Edit/view mode for this form.
    attr_accessor :edit
    attr_accessor :collapsible
    attr_accessor :collapsed
    # form options
    attr_accessor :method
    attr_accessor :url
    attr_accessor :submit

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
      form << form_body_element(h)
      form
    end

    private

    def update_fields
      self.fields.each do |f|
        f.model = self.model
        f.edit = self.edit
      end
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

    def form_body_element(h)
      body = generate_base_body
      generate_tabs(body)
      generate_bottom_actions(body)
      body
    end

    def generate_base_body
      tag = self.edit ? 'form' : 'div'
      body = Element.new(tag, attrs: { class: 'ff-form-body' })
      if self.edit
        body[:action] = self.url
        body[:method] = self.method || 'get'
      end
      body[:style][:display] = 'none' if self.collapsed
      body
    end

    def generate_tabs(body)
      tabs = Element.new('div', attrs: { class: 'ff-tabs' })
      self.tabs.each { |t|  tabs << t.to_e }
      if tabs.children.size > 1
        tabsHeader = Element.new('ul', attrs: { class: 'ff-tabs-header' })
        self.tabs.each do |t|
          index = tabsHeader.children.size
          tabid = tabs.children[index][:id]
          tab = Element.new('li', attrs: { 'data-tabid' => tabid })
          tab << Element.new('img', attrs: { src: t.icon }) if t.icon.present?
          tab << Element.new('span', text: t.title)
          tab.add_class('ff-selected') if index == 0
          tabs.children[index].add_class('ff-hidden') unless index == 0
          tabsHeader << tab
        end
        body << tabsHeader
      end
      body << tabs
    end

    def generate_bottom_actions(body)
      if self.edit
        actions = Element.new('div', attrs: { class: 'ff-form-actions' })
        actions << Element.new('button', attrs: { type: 'submit' }, text: (self.submit || 'Save'))
        body << actions
      end
    end

  end

end
