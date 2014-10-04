# -*- encoding : utf-8 -*-
require 'forma/auto_initialize'

module Forma
  module WithActions
    def actions
      actions = ( self.options[:actions] ||= [] )
      yield self if block_given?
      actions
    end

    alias :with_actions :actions

    def add_action(act)
      self.actions << act ; act
    end

    def action(url, opts = {})
      act = Forma::AutoInitialize.new(opts)
      act.url = url
      self.actions << act
      act
    end

    alias :link_action :action

    def button_action(url, opts = {})
      action(url, opts.merge(button: 'default'))
    end
  end
end
