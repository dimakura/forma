# -*- encoding : utf-8 -*-
require 'forma/helpers/view_helpers'
require 'forma/helpers/edit_helpers'

module Forma

  class Engine < ::Rails::Engine
  end

  class Railtie < Rails::Railtie
    initializer 'forma.forma_helpers' do
      ActionView::Base.send :include, Forma::ViewHelpers
      ActionView::Base.send :include, Forma::EditHelpers
    end
  end

end
