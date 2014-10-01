# -*- encoding : utf-8 -*-
require 'forma/auto_initialize'
require 'forma/generators/table_generator'
require 'forma/model/field'

module Forma
  class Table < Forma::AutoInitialize

    def viewer_html(opts={})
      raise 'no fields defined' unless self.fields
      Forma::TableGenerator.viewer_html(self, opts)
    end

    def add_field(fld)
      self.options[:fields] = [] if self.options[:fields].nil?
      self.options[:fields] << fld
    end

    def fields; self.options[:fields] end

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
