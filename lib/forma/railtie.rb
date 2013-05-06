# -*- encoding : utf-8 -*-
require 'forma/helpers'

module Forma

  class Engine < ::Rails::Engine
  end

  class Railtie < Rails::Railtie
    initializer 'forma.helpers' do
      ActionView::Base.send :include, Forma::Helpers
    end
  end

end
