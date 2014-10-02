# -*- encoding : utf-8 -*-
require 'forma/model'
require 'forma/generators/viewer_generator'

module Forma
  class Viewer < Forma::AutoInitialize
    def col1
      @col1 ||= Forma::FieldSet.new
      yield @col1 if block_given?
      @col1
    end

    def col2
      @col2 ||= Forma::FieldSet.new
      yield @col2 if block_given?
      @col2
    end

    def two_columns?; not not @col2 end
    def to_html(opts={}); Forma::ViewerGenerator.to_html(self, opts) end

    def method_missing(method_name, *args, &block)
      method_str = method_name.to_s
      if method_str =~ /^(.)+_field$/
        col1.send method_name, *args, &block
        return
      end

      super
    end
  end
end
