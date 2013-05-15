# -*- encoding : utf-8 -*-
module Forma

  # General field interface.
  class Field
    include Forma::Utils
    include Forma::Html
    attr_reader :id, :label, :required, :autofocus, :readonly
    attr_reader :width, :height
    attr_reader :hint
    attr_reader :before, :after
    attr_reader :url, :icon

    def initialize(h = {})
      h = h.symbolize_keys
      @id = h[:id]
      @label = h[:label]
      @required = h[:required]
      @autofocus = h[:autofocus]
      @width = h[:width]
      @height = h[:height]
      @readonly = (not not h[:readonly])
      @hint = h[:hint]
      @before = h[:before]
      @after = h[:after]
      @url = h[:url]
      @icon = h[:icon]
    end

    def to_html(model, edit)
      val = value_from_model(model)
      if edit and not readonly
        edit_element(model, val)
      else
        if val.present? or val == false
          view = view_element(model, val)
          view = el('a', attrs: { href: eval_url(model) }, children: [ view ]) if @url
          el('div', children: [ before_element, icon_element(model), view, after_element ])
        else
          empty_element
        end
      end
    end

    def label_i18n(model)
      if self.label.blank? and self.respond_to?(:field_name)
        I18n.t(["models", singular_name(model), self.field_name].join('.'), default: self.name)
      else
        self.label
      end
    end

    def hint_i18n(model)
      if self.hint.blank? and self.respond_to?(:field_name)
        I18n.t(["models", singular_name(model), "#{self.field_name}_hint"].join('.'), default: '')
      else
        self.hint
      end
    end

    protected

    def icon_element(model)
      if @icon
        iconpath = @icon.is_a?(Proc) ? @icon.call(model) : @icon.to_s
        el('img', attrs: { src: iconpath, style: { 'margin-right' => '4px' } })
      end
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

    def eval_url(model)
      @url.is_a?(Proc) ? @url.call(model) : @url.to_s
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

    def value_from_model(model)
      @fields.map { |f| f.value_from_model(model) }
    end

    def edit_element(model, val)
      el(
        'div',
        attrs: { class: 'ff-complex-field' },
        children: @fields.zip(val).map { |fv|
          el(
            'div',
            attrs: { class: 'ff-field' },
            children: [ fv[0].edit_element(model, fv[1]) ]
          )
        }
      )
    end

    def view_element(model, val)
      el(
        'div',
        attrs: { class: 'ff-complex-field' },
        children: @fields.zip(val).map { |fv|
          el(
            'div',
            attrs: { class: 'ff-complex-part' },
            children: [ fv[0].view_element(model, fv[1]) ]
          )
        }
      )
    end
  end

  # SimpleField gets it's value from it's name.
  class SimpleField < Field
    attr_reader :name

    def initialize(h = {})
      h = h.symbolize_keys
      @name = h[:name]
      @i18n_name = h[:i18n]
      super(h)
    end

    def id
      @id || @name
    end

    # field name for i18n
    def field_name
      (@i18n_name || self.name).to_s.gsub('.', '_')
    end

    # generate field's name by Rails convention.
    def field_rails_name(model)
      model_name = singular_name(model)
      fld_name = self.name.to_s.gsub('.', '_')
      if model_name.present?; "#{model_name}[#{fld_name}]"
      else; fld_name
      end
    end

    def value_from_model(model)
      def simple_value(model, name)
        if model.respond_to?(name)
          model.send(name)
        elsif model.respond_to?('[]')
          model[name] || model[name.to_sym]
        end
      end
      val = model
      name.to_s.split('.').each do |n|
        val = simple_value(val, n) if val
      end
      val
    end

    def errors(model)
      if model.respond_to?(:errors)
        model.errors.messages[name.to_sym]
      end || []
    end

    def has_errors?(model)
      errors(model).any?
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

    def view_element(model, val)
      el('span', text: (password ? '******' : val.to_s))
    end

    def edit_element(model, val)
      el('input', attrs: {
        id: self.id,
        name: field_rails_name(model),
        type: (password ? 'password' : 'text'),
        value: val.to_s,
        autofocus: @autofocus,
        style: {
          width: ("#{width}px" if width)
        }
      })
    end
  end

  # Email field.
  class EmailField < TextField
    def view_element(model, val)
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

    def view_element(model, val)
      el('span', text: val.localtime.strftime(formatter || Forma.config.date.formatter))
    end

    def edit_element(model, val)
      el('input', attrs: {
        name: field_rails_name(model),
        type: 'text',
        value: val.to_s,
        autofocus: @autofocus,
        style: { width: ("#{width}px" if width) }
      })
    end
  end

  # Boolean field.
  class BooleanField < SimpleField
    def view_element(model, val)
      el('input', attrs: { type: 'checkbox', disabled: true, checked: ('checked' if val) })
    end

    def edit_element(model, val)
      e1 = el('input', attrs: { type: 'hidden', name: field_rails_name(model), value: "0"})
      e2 = el('input', attrs: { type: 'checkbox', name: field_rails_name(model), checked: ('checked' if val), value: "1"})
      el('span', children: [ e1, e2 ])
    end
  end

  # Image upload field.
  class ImageField < SimpleField
    def view_element(model, val)
      el('img', attrs: { src: val.url } )
    end

    def edit_element(model, val)
      el('input', attrs: {
        name: field_rails_name(model),
        type: 'file',
      })
    end
  end

  # Number field.
  class NumberField < TextField
    def view_element(model, val)
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

    def view_element(model, val)
      el('span', text: val.to_s)
    end

    def edit_element(model, val)
      data = @empty != false ? [ nil ] + @collection : @collection
      selection = val.present? ? val : @default
      el('select', attrs: { name: field_rails_name(model) }, children: data.map { |x|
        if x.nil?
          el('option', attrs: { selected: selection.blank? }, text: @empty.to_s)
        else
          el('option', attrs: { value: x.id, selected: (true if selection == x.id) }, text: x.to_s)
        end
      })
    end
  end
end
