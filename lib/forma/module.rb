# -*- encoding : utf-8 -*-
module Forma

  # This creates a global module menu.
  def self.modules_menu(request)
    mods = ModuleGenerator.modules
    curr = ModuleGenerator.current_module(request)
    Forma::Html.el('ul', attrs: { class: 'ff-modules-menu' }, children: mods.map {|m|
      Forma::Html.el('li', attrs: { class: ('ff-active' if m == curr) }, children: [
        Forma::Html.el('a', attrs: { href: m.path }, text: m.label)
      ])
    }).to_s
  end

  # Create menu for current module.
  def self.module_menu(request)
    mod = ModuleGenerator.current_module(request)
    "TOP MENU"
  end

  def self.modules(app = nil, &block)
    Forma::ModuleGenerator.modules(app, &block)
  end

  class ModuleGenerator
    @@app = nil
    @@modules = []
    @@actions = {}

    def self.modules(app = nil)
      if block_given?
        @@app = app
        @@modules = []
        @@actions = {}
        yield ModuleGenerator.new
        ModuleGenerator.draw_routes
      end
      @@modules
    end

    def self.register_action(act)
      cntr = act.controller
      actn = act.action
      name = act.action_name
      verb = act.verb
      key = "#{act.name}/#{cntr}##{actn}"
      @@actions[key] = act
      @@app.routes.draw do
        namespace (act.namespace || act.module.namespace) do
          match act.path, controller: cntr, action: actn, as: name, via: verb
        end
      end
    end

    def self.draw_routes
      @@modules.each { |m| register_action(m) } if @@app
    end

    def self.current_action(request)
      @@actions["#{request.params[:controller]}##{request.params[:action]}"]
    end

    def self.current_module(request)
      action = current_action(request)
      if action.is_a?(Forma::Module)
        action
      else
        action.module
      end
    end

    def module(name, h={})
      mod = Forma::Module.new(name, h)
      @@modules << mod
      if block_given?
        yield mod
      end
    end
  end

  module ModuleHelper
    attr_reader :url, :children, :namespace

    def default_init(h)
      @controller = h[:controller]
      @action = h[:action]
      @verb = h[:verb]
      @url = h[:url]
      @namespace = h[:namespace]
      @children = []
      parent.children << self if parent
    end

    def label
      @label || I18n.t(i18n_key, default: @name)
    end

    def controller
      contr = @controller
      contr = parent.controller if (parent && contr.blank?)
      raise 'controller not defined' if contr.blank?
      contr
    end

    def verb
      if @verb.is_a?(Array)
        @verb
      else
        [ @verb ]
      end
    end

    def action
      raise 'action not defined' if @action.blank?
      @action
    end

    def path
      paths = []; obj = self
      while(not obj.nil?) do
        if (obj == self and not obj.is_a?(Forma::Module)) or obj.is_a?(Forma::Scope)
          paths << obj.url if obj.url
        end
        obj = obj.parent
      end
      "/#{paths.reverse.join('/')}"
    end
  end

  class Module
    include Forma::ModuleHelper

    attr_reader :name

    def initialize(name, h={})
      h = h.symbolize_keys
      @name = name
      h[:url] = name if h[:url].blank?
      @label = h[:label]
      h[:verb] = 'get'
      h[:namespace] = name
      default_init(h)
    end

    def i18n_key
      "modules.#{@name}.name"
    end

    def parent; nil end

    def menu_action(name, h={})
      h[:menu] = true
      act = ModuleAction.new(self, name, h)
      yield act
    end

    def action_name
      'home'
    end
  end

  class ModuleAction
    include Forma::ModuleHelper

    attr_reader :parent, :module
    attr_reader :menu

    def initialize(parent, name, h={})
      h = h.symbolize_keys
      @name = name
      @parent = parent
      if @parent.is_a?(Forma::Module)
        @module = @parent
      else
        @module = @parent.module
      end
      @menu = (not not h[:menu])
      default_init(h)
    end

    def name
      "#{@parent.name}_#{@name}"
    end

    def action_name
      name[(@module.name.length + 1)..-1]
    end

    def i18n_key
      "modules.#{@module.name}.actions.#{action_name}"
    end
  end

  class Scope
    include Forma::ModuleHelper

    attr_reader :parent, :module

    def initialize(parent, url, h={})
      h = h.symbolize_keys
      h[:url] = url
      @parent = parent
      # @name = path
      if @parent.is_a?(Forma::Module)
        @module = @parent
      else
        @module = @parent.module
      end
      default_init(h)
    end

    def name
      @parent.name
    end
  end

end
