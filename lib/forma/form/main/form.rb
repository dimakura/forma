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
      # TODO
    end

    private

    def update_fields
      self.fields
    end

  end

end
