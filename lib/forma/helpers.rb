# -*- encoding : utf-8 -*-
module Forma
  module Helpers
    def forma_for(model, opts = {})
      opts[:model] = model
      opts[:edit] = true
      opts[:auth_token] = form_authenticity_token if defined?(Rails)
      opts[:method] = 'post' if opts[:method].blank?
      f = Forma::Form.new(opts)
      yield f if block_given?
      f.to_html.to_s
    end

    def view_for(model, opts = {})
      opts[:model] = model
      opts[:edit] = false
      f = Forma::Form.new(opts)
      yield f if block_given?
      f.to_html.to_s
    end

    def table_for(models, opts = {}, &block)
      opts[:models] = models
      opts[:context] = block
      t = Forma::Table.new(opts)
      yield t if block_given?
      t.to_html.to_s
    end

    module_function :forma_for
    module_function :view_for
  end

  module FieldHelper
    def complex_field(opts = {})
      field = Forma::ComplexField.new(opts)
      yield field if block_given?
      add_field(field)
    end

    def subform(name, opts = {})
      opts[:name] = name
      field = Forma::SubformField.new(opts)
      yield field.form if block_given?
      add_field(field)
    end

    def text_field(name, opts={})
      opts[:name] = name
      add_field(Forma::TextField.new(opts))
    end

    def password_field(name, opts={})
      opts[:password] = true
      text_field(name, opts)
    end

    def email_field(name, opts={})
      opts[:name] = name
      add_field(Forma::EmailField.new(opts))
    end

    def date_field(name, opts={})
      opts[:name] = name
      add_field(Forma::DateField.new(opts))
    end

    def boolean_field(name, opts={})
      opts[:name] = name
      add_field(Forma::BooleanField.new(opts))
    end

    def image_field(name, opts={})
      opts[:name] = name
      add_field(Forma::ImageField.new(opts))
    end

    def number_field(name, opts = {})
      opts[:name] = name
      add_field(Forma::NumberField.new(opts))
    end

    def combo_field(name, opts = {})
      opts[:name] = name
      add_field(Forma::ComboField.new(opts))
    end
  end

  module WithTitleElement
    def title_element
      def active_title
        el(
          'span',
          attrs: { class: (self.collapsible ? ['ff-active-title', 'ff-collapsible'] : ['ff-active-title']) },
          children: [
            (el('i', attrs: { class: (self.collapsed ? ['ff-collapse', 'ff-collapsed'] : ['ff-collapse']) }) if self.collapsible),
            (el('img', attrs: { src: self.icon }) if self.icon),
            (el('span', text: self.title)),
          ].reject { |x| x.blank? }
        )
      end
      if self.title.present?
        title_acts = el('div', attrs: { class: 'ff-title-actions' },
          children: self.title_actions.map { |a| a.to_html(@model) }
        ) if self.title_actions.any?
        el('div', attrs: { class: 'ff-title' }, children: [ active_title, title_acts ])
      end
    end
  end
end
