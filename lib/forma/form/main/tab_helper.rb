# -*- encoding : utf-8 -*-
module Forma
  module Form
    module TabHelper
      def tab(opts={}, &block)
        @__tab_index ||= 0
        tab = tabs[@__tab_index] ||= Forma::Form::FormTab.new
        tab.update_with(opts)
        yield tab
        @__tab_index += 1
      end
    end
  end
end
