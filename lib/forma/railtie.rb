# -*- encoding : utf-8 -*-
require 'forma/helpers/view_helpers'

module Forma

  class Engine < ::Rails::Engine
  end

  class Railtie < Rails::Railtie
    initializer 'forma.view_helpers' do
      ActionView::Base.send :include, Forma::ViewHelpers
    end
  end

end
