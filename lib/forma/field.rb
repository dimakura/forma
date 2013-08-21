# -*- encoding : utf-8 -*-
module Forma
  # General field interface.
  class Field
    include Forma::Utils
    include Forma::Html

    attr_reader :label, :hint, :i18n, :name, :tag, :inline_hint
    attr_reader :required, :autofocus, :readonly
    attr_reader :width, :height
    attr_reader :before, :after
    attr_reader :url, :icon
    attr_accessor :model, :value, :parent, :child_model_name
    attr_writer :model_name
    attr_reader :actions

    def initialize(h = {})
      h = h.symbolize_keys
      @id = h[:id]; @label = h[:label]; @hint = h[:hint]; @i18n = h[:i18n]
      @inline_hint = h[:inline_hint]
      @required = h[:required]; @autofocus = h[:autofocus]; @readonly = (not not h[:readonly])
      @width = h[:width]; @height = h[:height]
      @before = h[:before]; @after = h[:after]
      @name = h[:name]; @value = h[:value]
      @url = h[:url]; @icon = h[:icon]
      @model = h[:model]; @parent = h[:parent]
      @model_name = h[:model_name]; @child_model_name = h[:child_model_name]
      @actions = h[:actions] || []
      @tag = h[:tag]
      @empty = h[:empty]
      @force_nonempty = h[:force_nonempty]
      @class = h[:class]
    end

    def action(url, h={})
      h[:url] = url
      @actions << Action.new(h)
    end

    def name_as_chain
      if self.parent and self.parent.respond_to?(:name_as_chain)
        chain = self.parent.name_as_chain
        chain << self.name
      else
        chain = [ self.model_name, self.name ]
      end
      chain.map { |x| x.to_s.gsub '.', '_' }
    end

    def id
      if @id then @id
      else name_as_chain.select{ |x| x.present? }.join('_') end
    end

    def parameter_name
      parameter_name_from_chain(name_as_chain)
    end

    # Convert this element into HTML.
    def to_html(edit)
      val = self.value
      if edit and not readonly
        edit = edit_element(val)
        el('div', children: [ before_element, icon_element, edit, after_element, actions_element, inline_hint_element ])
      else
        if val.present? or val == false or @force_nonempty
          view = view_element(val)
          view = el('a', attrs: { href: eval_url }, children: [ view ]) if @url
          el('div', attrs: { class: (@class ? eval_with_model(@class) : nil) },
            children: [ before_element, icon_element, view, after_element, actions_element, inline_hint_element ])
        else
          el('div', children: [ empty_element, actions_element ])
        end
      end
    end

    # Returns model name.
    # Model name can be defined by user or determined automatically, based on model class.
    def model_name
      if @model_name then @model_name
      elsif @parent then @parent.child_model_name
      else singular_name(self.model)
      end
    end

    def localization_key
      if @i18n.present?
        ["models", self.model_name, @i18n].compact.join('.')
      elsif self.respond_to?(:name)
        ["models", self.model_name, self.name].compact.join('.')
      end
    end

    def localized_label
      unless self.label == false
        self.label.present? ? self.label : I18n.t(localization_key, default: self.name)
      end
    end

    def localized_hint
      self.hint.present? ? self.hint : I18n.t("#{localization_key}_hint", default: '')
    end

    protected

    def parameter_name_from_chain(chain)
      length = chain.length
      p_name = ''
      chain.select{ |x| x.present? }.reverse.each_with_index do |n, i|
        if i == 0 then p_name = n
        elsif i == length - 1 then p_name = "#{n}[#{p_name}]"
        else p_name = "#{n}_attributes[#{p_name}]" end
      end
      p_name
    end

    def icon_element; el('img', attrs: { src: eval_icon, style: { 'margin-right' => '4px' } }) if @icon.present? end
    def before_element; el('span', text: eval_with_model(before), attrs: { class: 'ff-field-before' }) if before.present? end
    def after_element; el('span', text: eval_with_model(after), attrs: { class: 'ff-field-after' }) if after.present? end
    def empty_element; el('span', attrs: { class: 'ff-empty' }, text: Forma.config.texts.empty) unless @empty == false end
    def actions_element; el('div', attrs: { class: 'ff-field-actions' }, children: @actions.map { |action| action.to_html(@model) }) if @actions.any? end
    def inline_hint_element; el('div', attrs: { class: 'ff-inline-hint' }, text: @inline_hint) if @inline_hint.present? end
    def eval_url; eval_with_model(@url) end
    def eval_icon; eval_with_model(@icon) end

    private
    def eval_with_model(val, h={}); val.is_a?(Proc) ? val.call(h[:model] || self.model) : val.to_s end
  end

  # Complex field.
  class ComplexField < Field
    include Forma::FieldHelper
    attr_reader :fields

    def initialize(h = {})
      h = h.symbolize_keys
      @fields = h[:fields] || []
      super(h)
    end

    def add_field(f)
      @fields << f
    end

    def value
      @model
    end

    def edit_element(val)
      el(
        'div',
        attrs: { class: 'ff-complex-field' },
         children: @fields.map { |f|
          f.model = self.model
          el('div', attrs: { class: 'ff-complex-part' }, children: [ f.to_html(true) ])
        }
      )
    end

    def view_element(val)
      el(
        'div',
        attrs: { class: 'ff-complex-field' },
         children: @fields.map { |f|
          f.model = self.model
          el('div', attrs: { class: 'ff-complex-part' }, children: [ f.to_html(false) ])
        }
      )
    end

    def errors
      @fields.map { |f| f.model = @model; f.errors }.flatten
    end

    def has_errors?
      errors.any?
    end
  end

  # Map field.
  class MapField < Field
    def value
      val = super
      if val then val
      else
        lat  = extract_value(self.model, "#{self.name}_latitude")  || Forma.config.map.default_latitude
        long = extract_value(self.model, "#{self.name}_longitude") || Forma.config.map.default_longitude
        [ lat, long ]
      end
    end

    def width; @width || 500 end
    def height; @height || 500 end

    def view_element(val)
      el('div', attrs: { style: { width: "#{self.width}px", height: "#{self.height}px", position: 'relative' } }, children: [
        el('div', attrs: { id: self.id, class: 'ff-map' }),
        # google_import,
        map_display(val, false)
      ])
    end

    def edit_element(val)
      el('div', attrs: { style: { width: "#{self.width}px", height: "#{self.height}px", position: 'relative' } }, children: [
        el('div', attrs: { id: self.id, class: 'ff-map' }),
        # google_import,
        map_display(val, true),
        el('input', attrs: { name: latitude_name, id: "#{self.id}_latitude", value: val[0], type: 'hidden' }),
        el('input', attrs: { name: longitude_name, id: "#{self.id}_longitude", value: val[1], type: 'hidden' }),
      ])
    end

    private

    def map_display(val, edit)
      longLat = "{ latitude: #{val[0]}, longitude: #{val[1]} }"
      zoom_level = Forma.config.map.zoom_level
      el(
        'script',
        attrs: { type: 'text/javascript' },
        html: %Q{ forma.registerGoogleMap('#{self.id}', #{zoom_level}, #{longLat}, [ #{longLat} ], #{edit}); }
      )
    end

    def latitude_name
      "#{name_as_chain[0]}[#{name_as_chain[1]}_latitude]"
    end

    def longitude_name
      "#{name_as_chain[0]}[#{name_as_chain[1]}_longitude]"
    end
  end

  # SimpleField gets it's value from it's name.
  class SimpleField < Field
    def initialize(h = {})
      h = h.symbolize_keys
      super(h)
    end

    def value
      val = super
      if val then val
      else extract_value(self.model, self.name)
      end
    end

    def errors
      if self.model.respond_to?(:errors); self.model.errors.messages[name.to_sym] end || []
    end

    def has_errors?
      errors.any?
    end
  end

  # Subform!
  class SubformField < SimpleField
    include Forma::FieldHelper
    attr_reader :form

    def initialize(h = {})
      h[:label] = false
      @form = Form.new(collapsible: true)
      super(h)
    end

    def edit_element(val)
      init_forma_before_field_display(true)
      @form.to_html
    end

    def view_element(val)
      init_forma_before_field_display(false)
      @form.to_html
    end

    private

    def init_forma_before_field_display(edit)
      @form.model = val
      @form.parent_field = self
      @form.edit = edit
      @form.icon = eval_icon if @icon
      @form.title = localized_label
    end
  end

  # Text field.
  class TextField < SimpleField
    attr_reader :password

    def initialize(h = {})
      h = h.symbolize_keys
      @password = h[:password]
      super(h)
    end

    def view_element(val)
      el((@tag || 'span'), text: (password ? '******' : val.to_s), attrs: { id: self.id })
    end

    def edit_element(val)
      el('input', attrs: {
        id: self.id,
        name: parameter_name,
        type: (password ? 'password' : 'text'),
        value: val.to_s,
        autofocus: @autofocus,
        style: { width: ("#{width}px" if width.present?) }
      })
    end
  end

  # Email field.
  class EmailField < TextField
    def view_element(val)
      el('a', attrs: { href: "mailto:#{val}" }, text: val)
    end
  end

  # Date feild.
  class DateField < SimpleField
    attr_reader :formatter

    def initialize(h = {})
      h = h.symbolize_keys
      @formatter = h[:formatter]
      @@date_counter ||= 0
      @@date_counter += 1
      super(h)
    end

    def view_element(val)
			val = val.respond_to?(:localtime) ? val.localtime : val
      el('span', text: val.strftime(formatter || Forma.config.date.formatter))
    end

    def edit_element(val)
      input_id = "ff-date-#{@@date_counter}"
      el('div', children: [
        el('input', attrs: {
          id: input_id,
          value: val.to_s,
          type: 'hidden'
        }),
        el('input', attrs: {
          class: 'ff-date',
          name: parameter_name,
          type: 'text',
          value: (val.strftime('%d-%b-%Y') if val),
          autofocus: @autofocus,
          style: { width: ("#{width}px" if width.present?) },
          'data-altfield' => input_id,
        })
      ])
    end
  end

  # Boolean field.
  class BooleanField < SimpleField
    def view_element(val)
      el('input', attrs: { type: 'checkbox', disabled: true, checked: ('checked' if val) })
    end

    def edit_element(val)
      e1 = el('input', attrs: { type: 'hidden',  name: parameter_name, value: "0"})
      e2 = el('input', attrs: { type: 'checkbox', name: parameter_name, checked: ('checked' if val), value: "1"})
      el('span', children: [ e1, e2 ])
    end
  end

  # Image upload field.
  class ImageField < SimpleField
    def initialize(h = {})
      h = h.symbolize_keys
      @popover = h[:popover]
      @height = h[:height] || 200
      @width = h[:width] || 200
      super(h)
    end

    def view_element(val)
      popover_data = {}
      image_url = val.respond_to?(:url) ? val.url : val.to_s
      if @popover
        popover_data['data-original-title'] = eval_with_model(@popover[:title])
        url = eval_with_model(@popover[:url])
        popover_data['data-content'] = %Q{<div style="height: #{@height}px; width: #{@width}px;"><img src="#{url}"></img></div>}
        popover_data['data-html'] = 'true'
        popover_data['data-placement'] = @popover[:placement]
        el('img', attrs: { src: image_url, class: 'ff-popover' }.merge(popover_data))
      else
        el('img', attrs: { src: image_url })
      end
    end

    def edit_element(val)
      el('input', attrs: { name: parameter_name, type: 'file' })
    end
  end

  # Image upload field.
  class FileField < SimpleField
    def view_element(val)
      el('div', text: 'NO IMPLEMENTATION')
    end

    def edit_element(val)
      el('input', attrs: { name: parameter_name, type: 'file' })
    end
  end

  # Number field.
  class NumberField < TextField
    include Forma::Utils
    def initialize(h = {})
      h = h.symbolize_keys
      @min_digits = h[:min_digits] || Forma.config.num.min_digits
      @max_digits = h[:max_digits] || Forma.config.num.max_digits
      @separator = h[:separator] || Forma.config.num.separator
      @delimiter = h[:delimiter] || Forma.config.num.delimiter
      super(h)
    end

    def view_element(val)
      el('code', text: "#{number_format(val.to_f, max_digits: @max_digits, min_digits: @min_digits)}")
    end
  end

  # Combo field.
  class ComboField < SimpleField
    def initialize(h={})
      h = h.symbolize_keys
      @empty = h[:empty]
      @default = h[:default]
      @collection = (h[:collection] || [])
      super(h)
    end

    def view_element(val)
      data = normalize_data(@collection, false)
      text = data.find{|text, value| val == value }[0].to_s rescue nil
      el('span', text: text)
    end

    def edit_element(val)
      data = normalize_data(@collection, @empty)
      selection = val.present? ? val : @default
      el('select', attrs: { name: parameter_name }, children: data.map { |text, value|
        if value.nil? then el('option', attrs: { selected: selection.blank? , value: ""}, text: text)
        else el('option', attrs: { selected: (true if selection.to_s == value.to_s), value: value }, text: text)
        end
      })
    end

    private

    def normalize_data(collection, empty)
      if collection.is_a?(Hash) then data = collection.to_a
      else data = collection.map { |x| [x.to_s, x.id] } end
      if empty != false then data = ([[empty.to_s, nil]] + data) end
      Hash[data]
    end
  end

  # Array field.
  class ArrayField < SimpleField
    def initialize(h={})
      h = h.symbolize_keys
      @item_actions = h[:item_actions] || []
      @item_url = h[:item_url]
      super(h)
    end

    def view_element(val)
      el('div', attrs: { class: ['ff-array-field'] }, children: val.map { |x| 
        el('div', attrs: { class: 'ff-array-part' }, children: [
          if @item_url then el('a', attrs: { href: eval_with_model(@item_url, model: x) }, text: x.to_s) else el('span', text: x.to_s) end,
          (el('span', attrs: { class: 'ff-actions' }, children: @item_actions.map { |a| a.to_html(x) } ) if @item_actions.any?)
        ])
      })
    end

    def edit_element(val)
      el('div', text: 'NO IMPLEMENTATION')
    end

    def item_action(url, h={})
      h[:url] = url
      @item_actions << Action.new(h)
    end
  end

  # Table field.
  class TableField < SimpleField
    def initialize(h={})
      h = h.symbolize_keys
      h[:label] = false
      h[:force_nonempty] = true
      @table = Forma::Table.new(h[:table] || {})
      super(h)
    end

    def view_element(val)
      @table.models = val
      @table.to_html
    end

    def edit_element(val)
      el('div', text: 'NO IMPLEMENTATION')
    end

    def table
      yield @table if block_given?
      @table
    end
  end

  # Selection field.
  class SelectField < SimpleField
    def initialize(h={})
      h = h.symbolize_keys
      @search_url = h[:search_url]
      @search_width = h[:search_width] || 500
      @search_height = h[:search_height] || 600
      @polymorphic = h[:polymorphic]
      super(h)
    end

    def id_field_name
      chain = name_as_chain
      chain[chain.length - 1] = "#{chain.last}_id"
      parameter_name_from_chain(chain)
    end

    def type_field_name
      chain = name_as_chain
      chain[chain.length - 1] = "#{chain.last}_type"
      parameter_name_from_chain(chain)
    end

    def view_element(val); el(@tag || 'span', text: val.to_s) end

    def edit_element(val)
      inputs = [ el('input', attrs: { id: "#{self.id}_id_value", type: 'hidden', value: "#{val and val.id}", name: id_field_name }) ]
      if @polymorphic
        inputs <<  el('input',
          attrs: { id: "#{self.id}_type_value", type: 'hidden', value: "#{val and val.class.to_s}", name: type_field_name }
        )
      end
      text_element = el(
        'span',
        attrs: { id: "#{self.id}_text", class: ['ff-select-label', ('ff-empty' if val.blank?)] },
        text: (val.present? ? val.to_s : Forma.config.texts.empty)
      )
      buttons = el('div', attrs: { class: 'btn-group' }, children: [
        el('a', attrs: { class: 'ff-select-link btn btn-mini', 'data-id' => self.id, 'data-url' => @search_url, 'data-width' => @search_width, 'data-height' => @search_height }, children: [
          el('i', attrs: { class: 'icon icon-search' })
        ]),
        el('a', attrs: { class: 'ff-clear-selection-action btn btn-mini', 'data-id' => self.id }, children: [
          el('i', attrs: { class: 'icon icon-trash' })
        ])
      ])
      children = inputs + [ text_element, buttons ]
      el('div', attrs: { id: self.id, class: 'ff-select-field' }, children: children)
    end
  end
end
