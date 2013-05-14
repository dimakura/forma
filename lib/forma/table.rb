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
      # values and fields
      @models = h[:models]
      @fields = h[:fields] || []
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
          body_element,
        ]
      )
    end

    def title_action(url, h={})
      h[:url] = url
      @title_actions << Action.new(h)
    end

    def add_field(f)
      @fields << f
    end

    private

    def body_element
      el(
        'div', attrs: {
          class: ['ff-table-body', 'ff-collapsible-body'],
          style: ( {display: 'none'} if @collapsible && @collapsed ),
        },
        children: [ table_element ]
      )
    end

    def table_element
      def table_header_element
        el('thead', children: [
          el('tr', children: @fields.map { |f|
            label_text = f.label_i18n(@models.first)
            label_hint = f.hint_i18n(@models.first)
            el('th', attrs: { class: 'ff-field' }, text: label_text, children: [
              (el('i', attrs: { class: 'ff-field-hint', 'data-toggle' => 'tooltip', title: label_hint }) if label_hint.present?)
            ])
          })
        ])
      end
      def table_body_element
        el('tbody', children: @models.map { |model|
          el('tr', children: @fields.map { |fld|
            el('td', children: [ fld.to_html(model, false) ])
          })
        })
      end
      if @models and @models.any?
        el('table', attrs: { class: 'ff-common-table' }, children: [ table_header_element, table_body_element ])
      else
        el('div', attrs: { class: ['ff-empty', 'ff-table-empty'] }, text: Forma.config.texts.table_empty)
      end
    end
  end
end
