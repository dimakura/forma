# -*- encoding : utf-8 -*-
require 'forma/generators/html'

module Forma
  module IconGenerator
    extend Forma::Html

    def to_html(icon, opts={})
      type = opts[:type] || (icon.respond_to?(:type) and icon.type) || 'fa'
      case type
      when 'fa' then
        el('i', { class: "fa fa-#{icon}" })
      else
        path = opts[:path] || (icon.respond_to?(:path) and icon.path) || '/'
        el('img', { src: File.join(path, "#{icon}.#{type}") })
      end
    end

    module_function :to_html
  end
end
