# -*- encoding : utf-8 -*-
module Forma

  module ModuleHelper
    def init_routes(h)
      @controller = h[:controller]
      @action = h[:action]
      @verb = h[:verb]
      @path = h[:path]
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
      if is_a?(Forma::Module)
        @path || @name
      else
        raise 'path not defined' if @path.blank?
        "#{self.module.path}/#{@path}"
      end
    end
  end

  class Module
    include Forma::ModuleHelper

    attr_reader :name

    def initialize(name, h={})
      h = h.symbolize_keys
      @name = name
      @label = h[:label]
      init_routes(h)
    end

    def i18n_key
      "modules.#{@name}.name"
    end

    def parent; nil end
  end

  class ModuleAction
    include Forma::ModuleHelper

    attr_reader :parent, :module

    def initialize(name, parent, h={})
      @name = name
      @parent = parent
      if @parent.is_a?(Forma::Module)
        @module = @parent
      else
        @module = @parent.module
      end
      init_routes(h)
    end

    def name
      "#{@parent.name}_#{@name}"
    end

    def i18n_key
      def simple_name; name[(@module.name.length + 1)..-1] end
      "modules.#{@module.name}.actions.#{simple_name}"
    end
  end

end
