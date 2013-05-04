# -*- encoding : utf-8 -*-
module Forma
  include Forma::Html

  # Form.
  class Form
    def initialize(h = {})
      h = h.symbolize_keys
      # general
      @id = h[:id]
      @theme = h[:theme] || 'blue'
      # title properties
      @title = h[:title]
      @icon = h[:icon]
      @collapsible = h[:collapsible]
      @collapsed = h[:collapsed]
      # submit options
      @url = h[:url]
      @submit = h[:submit] || 'Save'
      @method = h[:method] || 'get'
      # tabs and model
      @tabs = h[:tabs] || []
      @model = h[:model]
      # other methods
      @edit = h[:edit]
    end

    def to_html
      el(
        'div',
        attrs: { id: @id, class: ['ff-form', 'ff-theme-' + @theme] },
        children: [
          title_element,
          body_element,
        ]
      )
    end

    private

    def title_element
      def active_title
        el(
          'span',
          attrs: { class: (@collapsible ? ['ff-active-title', 'ff-collapsible'] : ['ff-active-title']) },
          children: [
            (el('i', attrs: { class: (@collapsed ? ['ff-collapse', 'ff-collapsed'] : ['ff-collapse']) }) if @collapsible),
            (el('img', attrs: { src: @icon }) if @icon),
            (el('span', text: @title)),
          ].reject { |x| x.blank? }
        )
      end
      if @title.present?
        el(
          'div',
          attrs: { class: 'ff-title' },
          children: [
            active_title,
            # TODO: place title actions here
          ]
        )
      end
    end

    def body_element
      el(
        @edit ? 'form' : 'div',
        attrs: {
          class: 'ff-form-body',
          action: (@url if @edit), method: (@method if @edit),
          style: ({display: 'none'} if @collapsible && @collapsed)
        },
        children: [
          tabs_element,
          # TODO: place botom actions
        ]
      )
    end

    def field_element(fld)
      label_element =  el('div', attrs: { class: (fld.required ? ['ff-label', 'ff-required'] : ['ff-label']) }, text: fld.label)
      el('div', attrs: { id: fld.id, class: 'ff-field' }, children: [
        label_element,
      ])
    end

    def tabs_element
      def column_element(col, hasSecondCol)
        if col
          el('div', attrs: { class: ['ff-col', (hasSecondCol ? 'ff-col-50' : 'ff-col-100')]}, children: [
            el('div', attrs: { class: 'ff-col-inner' }, children: col.fields.map { |fld| field_element(fld) })
          ])
        end
      end
      def tab_element(tab)
        hasSecondCol = tab.col2.present?
        col1 = column_element(tab.col1, hasSecondCol)
        col2 = column_element(tab.col2, hasSecondCol)
        el('div', attrs: { class: 'ff-tab-content' }, children: [
          el('div', attrs: { class: 'ff-cols'}, children: [col1, col2])
        ])
      end
      def tabs_header
        if @tabs.length > 1
          el('ul', attrs: { class: 'ff-tabs-header' }, children: @tabs.map { |tab|
            el('li', children: [
              (el('img', attrs: { src: tab.icon }) if tab.icon),
              (el('span', text: tab.title || 'No Title'))
            ])
          })
        end
      end
      el(
        'div',
        attrs: { class: 'ff-tabs' },
        children: [
          tabs_header,
          el('div', attrs: { class: 'ff-tabs-body'}, children: @tabs.map { |tab| tab_element(tab) })
        ]
      )
    end

    def generate_bottom_actions(body)
      if self.edit
        actions = Element.new('div', attrs: { class: 'ff-form-actions' })
        actions << Element.new('button', attrs: { type: 'submit' }, text: (self.submit || 'Save'))
        body << actions
      end
    end

  end

  # This is a tab.
  class Tab
    attr_reader :title, :icon
    def initialize(h = {})
      h = h.symbolize_keys
      @title = h[:title]
      @icon = h[:icon]
      @col1 = h[:col1]
      @col2 = h[:col2]
    end

    # Returns the first column of this tab.
    def col1
      col = @col1
      yield col if block_given?
      col
    end

    # Returns the second column of this tab.
    def col2
      col = @col2
      yield col if block_given?
      col
    end
  end

  # Form may have up to two columns.
  class Col
    attr_reader :fields

    def initialize(fields = [])
      @fields = fields
    end
  end

# TODO: general 

  # Text field.
  class TextField
    attr_reader :id, :label, :required

    def initialize(h = {})
      h = h.symbolize_keys
      @id = h[:id]
      @label = h[:label]
      @name = h[:name]
      @required = h[:required]
    end

    def to_html
      el('span')
    end
  end

end