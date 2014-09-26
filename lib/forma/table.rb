# -*- encoding : utf-8 -*-
module Forma
  class Table
    include Forma::Html
    include Forma::FieldHelper
    include Forma::WithTitleElement
    attr_reader :collapsible, :collapsed, :icon, :title
    attr_reader :title_actions, :row_class, :checkboxes
    attr_accessor :models

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
      # row class
      @row_class = h[:row_class]
      @checkboxes = h[:checkboxes]
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

    def row_class(clazz); @row_class = clazz end
    def checkboxes(val=true); @checkboxes = val end

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
        children = []
        if @checkboxes
          children << el('th', attrs: { style: {width: '10px'} }, children: [
            el('input', attrs: { id: "all-models", type: 'checkbox' })
          ])
        end
        children += @fields.map { |f|
          f.model = @models.first
          label_text = f.localized_label
          label_hint = f.localized_hint
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
        children = []
        if @checkboxes
          children << el('td', children: [
            el('input', attrs: { id: "model-#{model.id}", type: 'checkbox' })
          ])
        end
        children += @fields.map { |fld|
          fld.model = model
          el('td', children: [ fld.to_html(false) ])
        }
        if @item_actions.any?
          children << el('td', children: @item_actions.map { |act| act.to_html(model) })
        end
        ############################################################################################
        options = { children: children }
        options[:attrs] = { class: eval_with_model(@row_class, model: model) } if @row_class
        ############################################################################################
        html = el('tr', options)
      end

      def table_body_element
        children = el('tbody', children: @models.map { |model| table_row(model) })
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
        paginate = el('div', html: s.to_s)
        el('div', attrs: { class: 'ff-paginate' }, children: [
          paginate,
          (el('div', attrs: { class: 'ff-totals' }, children: [
            el('code', text: "#{@models.total_entries}"),
            el('span', text: @paginate_options[:records] || 'records')
          ]) if @models.total_entries > 0)
        ])
      end
    end

    private
    def eval_with_model(val, h={}); val.is_a?(Proc) ? val.call(h[:model] || self.model) : val.to_s end
  end
end
