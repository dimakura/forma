# -*- encoding : utf-8 -*-
module Forma
  class Table
    include Forma::Html
    include Forma::FieldHelper
    include Forma::WithTitleElement
    attr_reader :collapsible, :collapsed, :icon, :title
    attr_reader :title_actions

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
      @paginate = h[:paginate]
      # actions
      @title_actions = h[:title_actions] || []
      @item_actions = h[:item_actions] || []
      # context
      @context = h[:context]
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

    def item_action(url, h={})
      h[:url] = url
      @item_actions << Action.new(h)
    end

    def add_field(f)
      @fields << f
    end

    def paginate(h={})
      @paginate = true
      @paginate_options = h
    end

    private

    def body_element
      el(
        'div', attrs: {
          class: ['ff-table-body', 'ff-collapsible-body'],
          style: ( {display: 'none'} if @collapsible && @collapsed ),
        },
        children: [ table_element, pagination_element ]
      )
    end

    def table_element
      def table_header_element
        children = @fields.map { |f|
          label_text = f.label_i18n(@models.first)
          label_hint = f.hint_i18n(@models.first)
          el('th', attrs: { class: 'ff-field' }, text: label_text, children: [
            (el('i', attrs: { class: 'ff-field-hint', 'data-toggle' => 'tooltip', title: label_hint }) if label_hint.present?)
          ])
        }
        children << el('th', attrs: { style: {width: '100px'} }) if @item_actions.any?
        el('thead', children: [
          el('tr', children: children)
        ])
      end
      def table_row(model)
        children = @fields.map { |fld|
          el('td', children: [ fld.to_html(model, false) ])
        }
        if @item_actions.any?
          children << el('td', children: @item_actions.map { |act| act.to_html(model) })
        end
        el('tr', children: children)
      end
      def table_body_element
        children = 
        el('tbody', children: @models.map { |model| table_row(model) })
      end
      if @models and @models.any?
        el('table', attrs: { class: 'ff-common-table' }, children: [ table_header_element, table_body_element ])
      else
        el('div', attrs: { class: ['ff-empty', 'ff-table-empty'] }, text: Forma.config.texts.table_empty)
      end
    end

    def pagination_element
      if @paginate and @context
        self_from_block = eval("self", @context.binding)
        s = self_from_block.send(:will_paginate, @models, @paginate_options)
        el('div', html: s.to_s)
      end
    end
  end
end
