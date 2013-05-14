# -*- encoding : utf-8 -*-
module Forma
  class Table
    include Forma::Html
    include Forma::FieldHelper
    include Forma::WithTitleElement
    attr_reader :collapsible, :collapsed, :icon, :title, :title_actions

    def initialize(h = {})
      h = h.symbolize_keys
      @id = h[:id]
      # title properties
      @title = h[:title]
      @icon = h[:icon]
      @collapsible = h[:collapsible]
      @collapsed = h[:collapsed]
      # values
      @models = h[:models]
      # actions
      @title_actions = h[:title_actions] || []
      @top_actions = h[:top_actions] || []
      @bottom_actions = h[:bottom_actions] || []
    end

    def to_html
      el(
        'div',
        attrs: { id: @id, class: ['ff-table'] },
        children: [
          title_element,
          # body_element,
        ]
      )
    end

    def title_action(url, h={})
      h[:url] = url
      @title_actions << Action.new(h)
    end
  end
end
