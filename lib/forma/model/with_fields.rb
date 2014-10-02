# -*- encoding : utf-8 -*-
require 'forma/auto_initialize'

module Forma
  class WithFields < Forma::AutoInitialize

    def fields; self.options[:fields] end

    def add_field(fld)
      self.options[:fields] = [] if self.options[:fields].blank?
      self.options[:fields] << fld
    end

    def method_missing(method_name, *args, &block)
      method_str = method_name.to_s
      if method_str =~ /^(.)+_field$/
        type = method_str[0..-7] ; name = args[0] ; opts = args[1] || {}
        add_field Forma::Field.new(opts.merge(name: name, type: type))
        return
      end

      super
    end

  end
end