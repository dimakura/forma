# -*- encoding : utf-8 -*-
module Forma

  # General field interface.
  class Field
    include Forma::Html
    attr_reader :id, :label, :required, :autofocus, :readonly
    attr_reader :width, :height
    attr_reader :hint
    attr_reader :before, :after

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
    end

    def to_html(model, edit)
      val = value_from_model(model)
      if edit and not readonly
        edit_element(model, val)
      else
        if val.present? or val == false
          el('div', children: [
            before_element,
            view_element(model, val),
            after_element
          ])
        else
          empty_element
        end
      end
    end

    protected

    def before_element
      el('span', text: before, attrs: { class: 'ff-field-before' }) if before.present?
    end

    def after_element
      el('span', text: after, attrs: { class: 'ff-field-after' }) if after.present?
    end

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

    def id
      @id || @name
    end

    def singular_name
      self.name.to_s.gsub('.', '_')
    end

    # generate field's name by Rails convention.
    def field_name(model)
      if model.respond_to?(:model_name)
        "#{model.model_name.singular_route_key}[#{singular_name}]"
      else
        singular_name
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
      el('input', attrs: { type: 'checkbox', disabled: true, checked: ('checked' if val) })
    end

    def edit_element(model, val)
      e1 = el('input', attrs: { type: 'hidden', name: field_name(model), value: "0"})
      e2 = el('input', attrs: { type: 'checkbox', name: field_name(model), checked: ('checked' if val), value: "1"})
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
        name: field_name(model),
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

end
