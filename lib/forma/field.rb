# -*- encoding : utf-8 -*-
module Forma

  # General field interface.
  class Field
    include Forma::Html
    attr_reader :id, :label, :required, :autofocus, :readonly
    attr_reader :width, :height

    def initialize(h = {})
      h = h.symbolize_keys
      @id = h[:id]
      @label = h[:label]
      @required = h[:required]
      @autofocus = h[:autofocus]
      @width = h[:width]
      @height = h[:height]
      @readonly = (not not h[:readonly])
    end

    def to_html(model, edit)
      val = value_from_model(model)
      if edit and not readonly
        edit_element(model, val)
      else
        if val.present? or val == false
          view_element(model, val)
        else
          empty_element
        end
      end
    end

    protected

    def empty_element
      el('span', attrs: { class: 'ff-empty' }, text: Forma.config.texts.empty)
    end
  end

  # SimpleField gets it's value from it's name.
  class SimpleField < Field
    attr_reader :name

    def initialize(h = {})
      h = h.symbolize_keys
      @name = h[:name]
      super(h)
    end

    # generate field's name by Rails convention.
    def field_name(model)
      if model.blank? or model.is_a?(Hash)
        name
      else
        clazz = model.class.name.gsub('::', '_').downcase
        "#{clazz}[#{name}]"
      end
    end

    def value_from_model(model)
      if model.respond_to?(name)
        model.send(name)
      elsif model.respond_to?('[]')
        model[name] || model[name.to_sym]
      end
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
      el('span', text: val.to_s)
    end

    def edit_element(model, val)
      el('input', attrs: {
        name: field_name(model),
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
        name: field_name(model),
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
      my_element(model, val, false)
    end

    def edit_element(model, val)
      my_element(model, val, true)
    end

    private

    def my_element(model, val, edit)
      edit = false if readonly
      el('input', attrs: {
        type: 'checkbox',
        name: (field_name(model) if edit),
        disabled: ('disabled' unless edit),
        checked: ('checked' if val),
      })
    end
  end

end
