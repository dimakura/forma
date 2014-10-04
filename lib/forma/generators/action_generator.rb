# -*- encoding : utf-8 -*-
require 'forma/generators/html'
require 'forma/generators/icon_generator'

module Forma
  module ActionGenerator
    extend Forma::Html

    def to_html(actionDef, opts = {})
      url = opts[:url] || actionDef.url
      method = opts[:http_method] || actionDef.http_method
      params = { href: url }
      params['data-method'] = method if method.present?
      params[:class] = 'forma-action'

      case (opts[:as] || actionDef.as).to_s
      when 'button' then params[:class] += ' btn btn-default'
      end

      inner_html = opts[:label] || actionDef.label || ''

      icon = opts[:icon] || actionDef.icon
      inner_html = "#{Forma::IconGenerator.to_html(icon)} #{inner_html}" if icon

      el('a', params, [ inner_html ] )
    end

    module_function :to_html
  end
end