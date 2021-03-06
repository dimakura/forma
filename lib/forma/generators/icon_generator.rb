# -*- encoding : utf-8 -*-
require 'forma/generators/html'

module Forma
  module IconGeneratorMethods
    def to_html(iconDef, opts = {})
      icon = nil ; type = nil ; path = ''
      if iconDef.instance_of?(Hash)
        icon = iconDef[:icon]
        type = iconDef[:type]
        path = iconDef[:path] || '/'
      else
        icon = iconDef
        type = 'fa'
      end

      icon = icon.call(opts[:model]) if icon.instance_of?(Proc)

      case type
      when 'fa' then
        el('i', { class: "fa fa-#{icon}" })
      else
        el('img', { src: File.join(path, "#{icon}.#{type}") })
      end
    end
  end

  class IconGenerator
    extend Forma::HtmlMethods
    extend IconGeneratorMethods
  end
end
