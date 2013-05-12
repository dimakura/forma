# -*- encoding : utf-8 -*-
module Forma

  def self.modules_menu
    "THIS SHOULD BE A MENU"
  end

  def self.modules(app = nil, &block)
    Forma::ModuleGenerator.modules(app, &block)
  end

  class ModuleGenerator
    @@app = nil
    @@modules = []

    def self.modules(app = nil)
      if block_given?
        @@app = app
        @@modules = []
        yield ModuleGenerator.new
        ModuleGenerator.draw_routes
      end
      @@modules
    end

    def self.draw_routes
      if @@app
        @@app.routes.draw do
          @@modules.each do |m|
            namespace m.name do
              get '/', controller: m.controller, action: m.action, as: 'home'
            end
          end
        end
      end
    end

    def module(name, h={})
      @@modules << Forma::Module.new(name, h)
    end
  end

  module ModuleHelper
    attr_reader :url, :children

    def default_init(h)
      @controller = h[:controller]
      @action = h[:action]
      @verb = h[:verb]
      @url = h[:url]
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

    def action
      raise 'action not defined' if @action.blank?
      @action
    end

    def path
      paths = []; obj = self
      while(not obj.nil?) do
        if obj == self or obj.is_a?(Forma::Module) or obj.is_a?(Forma::Scope)
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
      default_init(h)
    end

    def i18n_key
      "modules.#{@name}.name"
    end

    def parent; nil end
  end

  class ModuleAction
    include Forma::ModuleHelper

    attr_reader :parent, :module

    def initialize(parent, name, h={})
      @name = name
      @parent = parent
      if @parent.is_a?(Forma::Module)
        @module = @parent
      else
        @module = @parent.module
      end
      default_init(h)
    end

    def name
      "#{@parent.name}_#{@name}"
    end

    def i18n_key
      def simple_name; name[(@module.name.length + 1)..-1] end
      "modules.#{@module.name}.actions.#{simple_name}"
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
