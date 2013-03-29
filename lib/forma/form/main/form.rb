# -*- encoding : utf-8 -*-
module Forma::Form

  # Form.
  class Form
    include Forma::Html
    include Forma::Init
    attr_accessor :title
    attr_accessor :icon

    def initialize(h = {})
      super(h)
      @tabs = [ FormTab.new ]
    end

    def tabs
      @tabs
    end

    def fields
      @tabs.inject([]) { |fields, tab| fields += tab.fields }
    end

    def << f
      tabs[0] << f
    end

    def to_e(h = {})
      # TODO
    end

    private

    def generate_title
      if self.title
        
      end
    end

  end

end
