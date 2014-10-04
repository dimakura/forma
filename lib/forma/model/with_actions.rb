# -*- encoding : utf-8 -*-
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
      self.url = url
      self.options.merge( opts )
    end
  end
end
