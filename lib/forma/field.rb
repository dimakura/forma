# -*- encoding : utf-8 -*-
module Forma

  # General field interface.
  class Field
    include Forma::Utils
    include Forma::Html

    attr_reader :id, :label, :hint
    attr_reader :required, :autofocus, :readonly
    attr_reader :width, :height
    attr_reader :before, :after
    attr_reader :url, :icon

    attr_accessor :model, :parent_name
    attr_writer   :model_name

    def initialize(h = {})
      h = h.symbolize_keys
      @id = h[:id]; @label = h[:label]; @hint = h[:hint]
      @required = h[:required]; @autofocus = h[:autofocus]; @readonly = (not not h[:readonly])
      @width = h[:width]; @height = h[:height]
      @before = h[:before]; @after = h[:after]
      @url = h[:url]; @icon = h[:icon]
    end

    # Convert this element into HTML.
    def to_html(edit)
      val = value_from_model(self.model)
      if edit and not readonly
        edit_element(val)
      else
        if val.present? or val == false
          view = view_element(val)
          view = el('a', attrs: { href: eval_url }, children: [ view ]) if @url
          el('div', children: [ before_element, icon_element, view, after_element ])
        else
          empty_element
        end
      end
    end

    # Returns model name.
    # Model name can be defined by user or determined automatically, based on model class.
    def model_name
      @model_name || singular_name(self.model)
    end

    def localization_key
      if self.respond_to?(:field_name)
        ["models", self.model_name, self.field_name].join('.')
      end
    end

    def localized_label
      self.label.present? ? self.label : I18n.t(localization_key, default: (self.name rescue nil))
    end

    def localized_hint
      self.hint.present? ? self.hint : I18n.t("#{localization_key}_hint", default: (self.name rescue nil))
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

    # field name for i18n
    def field_name
      (@i18n_name || self.name).to_s.gsub('.', '_')
    end

    def rails_array(model)
      [self.parent_name, self.model_name || singular_name(model), self.name].select { |x| x.present? }
    end

    # generate field's name by Rails convention.
    def field_rails_name(model)
      def field_name_from_array(array)
        if array.size == 1
          array[0]
        else
          "#{array[0]}_attributes[#{field_name_from_array(array[1..-1])}]"
        end
      end
      names = rails_array(model).join('.').split('.')
      if names.size == 1
        names[0]
      else
        "#{names[0]}[#{field_name_from_array(names[1..-1])}]"
      end
    end

    def id
      def complex_id
        if parent_name; "#{parent_name}_#{@name}"
        else; @name end
      end
      @id || complex_id
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

  # Named subform.
  class SubformField < SimpleField
    include Forma::Html
    include Forma::Utils
    include Forma::FieldHelper
    def initialize(h = {})
      h = h.symbolize_keys
      h[:label] = false
      @fields = h[:fields] || []
      super(h)
    end

    def add_field(f)
      @fields << f
    end

    def edit_element(model, val)
      to_subform_element(model, val, true)
    end

    def view_element(model, val)
      el('div', text: 'This is VIEW element.')
    end

    private

    def to_subform_element(model, val, edit)
      def title_element(model, val, edit)
        el('div', attrs: { class: 'ff-subtitle'}, text: label_i18n(model))
      end
      def body_element(model, val, edit)
        el('div', attrs: { class: 'ff-subform-body' }, children: @fields.map { |f| subform_field_element(f, model, val, edit) })
      end
      def subform_field_element(fld, model, val, edit)
        fld.parent_name = singular_name(model)
        fld.model_name = self.name
        el('div', attrs: { class: 'ff-field' }, children: [ fld.to_html(val, edit) ])
      end
      el('div', attrs: { class: 'ff-subform' }, children: [
        title_element(model, val, edit), body_element(model, val, edit)
      ])
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
