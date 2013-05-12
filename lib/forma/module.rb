# -*- encoding : utf-8 -*-
module Forma

  def self.modules(app, &block)
    Forma::Module.clear_modules
    gen = Forma::ModuleGenerator.new(app)
    yield gen
  end

  class ModuleGenerator
    attr_reader :app

    def initialize(app)
      @app = app
    end

    def module(name, h={})
      mod = Forma::Module.new(@app, name, h)
      yield mod if block_given?
      mod
    end
  end

  # `Module` is used to make your applications more modular.
  class Module
    @@modules = []
    def self.clear_modules
      @@modules = []
    end
    def self.modules
      @@modules
    end

    def self.modules_menu
      Forma::Html.el('ul', attrs: { class: 'ff-modules' },
        children: self.modules.map do |mod|
          Forma::Html.el('li', attrs: {  }, children: [
            Forma::Html.el('a', attrs: { href: mod.url }, text: mod.label )
          ])
        end
      )
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

    def url
      "/#{name}"
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
