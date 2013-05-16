# -*- encoding : utf-8 -*-
module Forma
  # Form.
  class Form
    include Forma::Html
    include Forma::FieldHelper
    include Forma::WithTitleElement
    include Forma::Utils
    attr_reader :collapsible, :collapsed, :icon, :title, :title_actions

    def initialize(h = {})
      h = h.symbolize_keys
      # general
      @id = h[:id]
      # @theme = h[:theme] || 'blue'
      # title properties
      @title = h[:title]
      @icon = h[:icon]
      @collapsible = h[:collapsible]
      @collapsed = h[:collapsed]
      # submit options
      @url = h[:url]
      @submit = h[:submit] || 'Save'
      @wait_on_submit = h[:wait_on_submit].blank? ? true : (not not h[:wait_on_submit])
      @method = h[:method]
      @auth_token = h[:auth_token]
      # tabs
      @tabs = h[:tabs] || []
      @selected_tab = h[:selected_tab] || 0
      # model, errors and editing options
      @model = h[:model]
      @errors = h[:errors]
      @edit = h[:edit]
      # actions
      @title_actions = h[:title_actions] || []
      @bottom_actions = h[:bottom_actions] || []
      @multipart = (not not h[:multipart])
    end

    def to_html
      el(
        'div',
        attrs: { id: @id, class: [ 'ff-form' ] },
        children: [
          title_element,
          body_element,
        ]
      )
    end

    def submit(txt = nil)
      @submit = txt if txt.present?
      @submit
    end

    def title_action(url, h={})
      h[:url] = url
      @title_actions << Action.new(h)
    end

    def bottom_action(url, h={})
      h[:url] = url
      h[:as] = 'button' unless h[:as].present?
      @bottom_actions << Action.new(h)
    end

    # Adds a new tab and ibject body content.
    def tab(opts={})
      tab = Tab.new(opts)
      @tabs << tab
      yield tab if block_given?
      tab
    end

    # Adding a new field to this form.
    def add_field(f)
      @tabs = [ Tab.new ] if @tabs.empty?
      @tabs[0].col1.add_field(f)
    end

    private

    def body_element
      el(
        @edit ? 'form' : 'div',
        attrs: {
          enctype: ('multipart/form-data' if @multipart),
          class: (@wait_on_submit ? ['ff-form-body', 'ff-wait-on-submit', 'ff-collapsible-body'] : ['ff-form-body', 'ff-collapsible-body']),
          action: (@url if @edit), method: (@method if @edit),
          style: ({display: 'none'} if @collapsible && @collapsed)
        },
        children: [
          (errors_element if @errors.present?),
          (auth_token_element if @edit == true),
          tabs_element,
          bottom_actions,
        ]
      )
    end

    def errors_element
      many = @errors.is_a?(Array)
      children = (many ? @errors.map { |e| el('li', text: e.to_s) } : [ el('span', text: @errors.to_s) ])
      el((many ? 'ul' : 'div'), attrs: { class: 'ff-form-errors' }, children: children)
    end

    def auth_token_element
      if @auth_token.present?
        el('div', attrs: { style: {padding: 0, margin: 0, height: 0, width: 0, display: 'inline'} }, children: [
          el('input', attrs: { type: 'hidden', name: 'authenticity_token', value: @auth_token })
        ])
      end
    end

    def field_element(fld)
      def field_error_element(errors)
        many = errors.length > 1
        children = (many ? errors.map { |e| el('li', text: e.to_s)  } : [el('div', text: errors[0].to_s)])
        el('div', attrs: { class: 'ff-field-errors' }, children: children)
      end
      fld.model = @model
      has_errors = (@edit and @model.present? and fld.respond_to?(:has_errors?) and fld.has_errors?)
      if fld.label != false
        label_text = fld.localized_label
        label_hint = fld.localized_hint
        label_element = el('div', attrs: { class: (fld.required ? ['ff-label', 'ff-required'] : ['ff-label'])},
          text: label_text,
          children: [
            (el('i', attrs: { class: 'ff-field-hint', 'data-toggle' => 'tooltip', title: label_hint }) if label_hint.present?)
          ]
        )
      end
      value_element = el('div', attrs: { class: (fld.required ? ['ff-value', 'ff-required'] : ['ff-value']) }, children: [
        fld.to_html(@edit), (field_error_element(fld.errors) if has_errors),
      ])
      el(
        'div', attrs: {
          id: ("fld_#{fld.id}" if fld.id), class: (has_errors ? ['ff-field', 'ff-error'] : ['ff-field']) },
          children: [ label_element, value_element ]
      )
    end

    def tabs_element
      def column_element(col, hasSecondCol)
        if col
          el('div', attrs: { class: ['ff-col', (hasSecondCol ? 'ff-col-50' : 'ff-col-100')]}, children: [
            el('div', attrs: { class: 'ff-col-inner' }, children: col.fields.map { |fld| field_element(fld) })
          ])
        end
      end
      def tab_actions(tab)
        if tab.actions.any?
          el('div', attrs: { class: 'ff-tab-actions' }, children: tab.actions.map { |a| a.to_html(@model) })
        end
      end
      def tab_element(tab)
        hasSecondCol = (not tab.col2.fields.empty?)
        col1 = column_element(tab.col1, hasSecondCol)
        col2 = column_element(tab.col2, hasSecondCol)
        el('div', attrs: { class: 'ff-tab-content',style: ({ display: 'none' } if @tabs.index(tab) != @selected_tab) },
          children: [
            tab_actions(tab),
            el('div', attrs: { class: 'ff-cols'}, children: [col1, col2])
          ]
        )
      end
      def tabs_header
        if @tabs.length > 1
          el('ul', attrs: { class: 'ff-tabs-header' }, children: @tabs.map { |tab|
            el('li', attrs: { class: ('ff-selected' if @tabs.index(tab) == @selected_tab) }, children: [
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

    def bottom_actions
      if @edit || @bottom_actions.any?
        children = @bottom_actions.map { |a| a.to_html(@model) }
        save_action = el('button', attrs: { type: 'submit', class: 'btn btn-primary' }, text: @submit) if @edit
        el('div', attrs: { class: 'ff-bottom-actions' }, children: [save_action] + children )
      end
    end
  end

  # This is a tab.
  class Tab
    include Forma::FieldHelper
    attr_reader :title, :icon, :actions

    def initialize(h = {})
      h = h.symbolize_keys
      @title = h[:title]
      @icon = h[:icon]
      @col1 = h[:col1]
      @col2 = h[:col2]
      @actions = h[:actions] || []
    end

    # Adding field to this tab.
    def add_field(f)
      col1.add_field(f)
    end

    # Returns the first column of this tab.
    def col1
      @col1 = Col.new if @col1.blank?
      yield @col1 if block_given?
      @col1
    end

    # Returns the second column of this tab.
    def col2
      @col2 = Col.new if @col2.blank?
      yield @col2 if block_given?
      @col2
    end

    def action(url, h={})
      h[:url] = url
      @actions << Action.new(h)
    end
  end

  # Form may have up to two columns.
  class Col
    include Forma::FieldHelper
    attr_reader :fields

    def initialize(fields = [])
      @fields = fields
    end

    def add_field(f)
      @fields << f
    end
  end
end
