# -*- encoding : utf-8 -*-
module Forma

  # General field interface.
  class Field
    include Forma::Html
    attr_reader :id, :label, :required, :autofocus
    attr_reader :width, :height

    def initialize(h = {})
      h = h.symbolize_keys
      @id = h[:id]
      @label = h[:label]
      @required = h[:required]
      @autofocus = h[:autofocus]
      @width = h[:width]
      @height = h[:height]
    end

    def to_html(model, edit)
      val = value_from_model(model)
      if edit
        edit_element(model, val)
      else
        if val.present?
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

    def value_from_model(model)
      if model.respond_to?(name)
        model.send(name)
      elsif model.respond_to?('[]')
        model[name] || model[name.to_sym]
      end
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
        name: name,
        type: (password ? 'password' : 'text'),
        value: val.to_s,
        autofocus: @autofocus,
        style: {
          width: ("#{width}px" if width)
        }
      })
    end
  end

end
