# -*- encoding : utf-8 -*-
module Forma

  # Helper for creating modules.
  def self.module(app, name, h={})
    unless Forma.module_names.include?(name)
      mod = Forma::Module.new(app, name, h)
      yield mod if block_given?
      mod
    end
  end

  def self.modules
    Forma::Module.modules
  end

  def self.module_names
    Forma.modules.map { |m| m.name }
  end

  # `Module` is used to make your applications more modular.
  class Module
    @@modules = []
    def self.modules
      @@modules
    end

    attr_reader :app, :name, :parent

    def initialize(app, name, h={})
      @app = app
      @name = name
      @parent = nil # module has no parent
      h = h.symbolize_keys
      @label = h[:label]
      @@modules << self
    end

    def label
      @label || I18n.t("modules.#{name}.name", default: name)
    end
  end

  class Group
    attr_reader :parent

    def initialize(parent, name, h={})
      h = h.symbolize_keys
      @name = name
      @parent = parent
    end
  end

  # Action class.
  class Action
    include Forma::Html
    # attr_reader :label, :icon, :method, :confirm, :as
    attr_reader :url 

    def initialize(h={})
      h = h.symbolize_keys
      @label = h[:label]
      @icon = h[:icon]
      @url = h[:url]
      @method = h[:method]
      @confirm = h[:confirm]
      @as = h[:as]
    end

    def to_html(model)
      children = [ (el('img', attrs: { src: @icon }) if @icon.present?), el('span', text: @label) ]
      button = (@as.to_s == 'button')
      el(
        'a',
        attrs: {
          class: ['ff-action', ('btn' if button)],
          href: url, 'data-method' => @method, 'data-confirm' => @confirm
        },
        children: children
      )
    end
  end

end
