# -*- encoding : utf-8 -*-
module Forma
  # General field interface.
  class Field
    include Forma::Utils
    include Forma::Html

    attr_reader :label, :hint, :i18n, :name, :tag
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
      @required = h[:required]; @autofocus = h[:autofocus]; @readonly = (not not h[:readonly])
      @width = h[:width]; @height = h[:height]
      @before = h[:before]; @after = h[:after]
      @name = h[:name]; @value = h[:value]
      @url = h[:url]; @icon = h[:icon]
      @model = h[:model]; @parent = h[:parent]
      @model_name = h[:model_name]; @child_model_name = h[:child_model_name]
      @actions = h[:actions] || []
      @tag = h[:tag]
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
    end

    def id
      if @id then @id
      else name_as_chain.flatten.join('_') end
    end

    def parameter_name
      chain = name_as_chain; length = chain.length
      p_name = ''
      chain.reverse.each_with_index do |n, i|
        if i == 0 then p_name = n
        elsif i == length - 1 then p_name = "#{n}[#{p_name}]"
        else p_name = "#{n}_attributes[#{p_name}]" end
      end
      p_name
    end

    # Convert this element into HTML.
    def to_html(edit)
      val = self.value
      if edit and not readonly
        edit = edit_element(val)
        el('div', children: [ before_element, icon_element, edit, after_element, actions_element ])
      else
        if val.present? or val == false
          view = view_element(val)
          view = el('a', attrs: { href: eval_url }, children: [ view ]) if @url
          el('div', children: [ before_element, icon_element, view, after_element, actions_element ])
        else
          empty = empty_element
          el('div', children: [ empty, actions_element ])
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
      self.label.present? ? self.label : I18n.t(localization_key, default: self.name)
    end

    def localized_hint
      self.hint.present? ? self.hint : I18n.t("#{localization_key}_hint", default: '')
    end

    protected

    def icon_element
      el('img', attrs: { src: eval_icon, style: { 'margin-right' => '4px' } }) if @icon.present?
    end

    def before_element
      el('span', text: before, attrs: { class: 'ff-field-before' }) if before.present?
    end

    def after_element
      el('span', text: after, attrs: { class: 'ff-field-after' }) if after.present?
    end

    def empty_element
      el('span', attrs: { class: 'ff-empty' }, text: Forma.config.texts.empty)
    end

    def actions_element
      if @actions.any?
        el('div', attrs: { class: 'ff-field-actions' }, children: @actions.map { |action| action.to_html(@model) })
      end
    end

    def eval_url
      @url.is_a?(Proc) ? @url.call(self.model) : @url.to_s
    end

    def eval_icon
      @icon.is_a?(Proc) ? @icon.call(self.model) : @icon.to_s
    end
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
      val = super
      if val then val
      else
        @fields.each { |f| f.model = self.model }
        @fields.map { |f| f.value }
      end
    end

    def edit_element(val)
      el(
        'div',
        attrs: { class: 'ff-complex-field' },
        children: @fields.zip(val).map { |fv|
          el(
            'div',
            attrs: { class: 'ff-field' },
            children: [ fv[0].edit_element(fv[1]) ]
          )
        }
      )
    end

    def view_element(val)
      el(
        'div',
        attrs: { class: 'ff-complex-field' },
        children: @fields.zip(val).map { |fv|
          el(
            'div',
            attrs: { class: 'ff-complex-part' },
            children: [ fv[0].view_element(fv[1]) ]
          )
        }
      )
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
      super(h)
    end

    def view_element(val)
      el('span', text: val.localtime.strftime(formatter || Forma.config.date.formatter))
    end

    def edit_element(val)
      el('input', attrs: {
        name: parameter_name,
        type: 'text',
        value: val.to_s,
        autofocus: @autofocus,
        style: { width: ("#{width}px" if width.present?) }
      })
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
    def view_element(val)
      el('img', attrs: { src: val.url } )
    end

    def edit_element(val)
      el('input', attrs: {
        name: parameter_name,
        type: 'file',
      })
    end
  end

  # Number field.
  class NumberField < TextField
    def view_element(val)
      el('code', text: "#{val}")
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
      el('span', text: val.to_s)
    end

    def edit_element(val)
      def normalize_data(collection, empty)
        if collection.is_a?(Hash) then data = collection.to_a
        else data = collection.map { |x| [x.to_s, x.id] } end
        if empty != false then data.insert[empty.to_s, nil] end
        Hash[data]
      end
      data = normalize_data(@collection, @empty)
      selection = val.present? ? val : @default
      el('select', attrs: { name: parameter_name }, children: data.map { |text, value|
        if value.nil? then el('option', attrs: { selected: selection.blank? }, text: text)
        else el('option', attrs: { selected: (true if selection == value) }, text: text)
        end
      })
    end
  end
end
