# -*- encoding : utf-8 -*-
require 'forma/auto_initialize'

module Forma
  class WithFields < Forma::AutoInitialize
    AUTO_PROPERTIES = [ 'required', 'readonly' ]

    def fields
      fields = ( self.options[:fields] ||= [] )
      yield self if block_given?
      fields
    end

    alias :with_fields :fields

    def add_field(fld)
      self.options[:fields] ||= []
      self.options[:fields] << fld
      fld
    end

    def method_missing(method_name, *args, &block)
      method_str = method_name.to_s
      if method_str =~ /^(.)+_field$/
        name = opts = nil
        if args[0].instance_of?(Hash)
          opts = args[0]
        else
          name = args[0]
          opts = args[1] || {}
        end
        type = extract_type( method_str[0..-7], opts )

        fld = add_field Forma::Field.new(opts.merge(name: name, type: type))
        yield fld if block_given?
        return fld
      end

      super
    end

    private

    def extract_type(type, opts)
      types = type.split('_') ; cnt = 0
      types.each do |t|
        if AUTO_PROPERTIES.index(t) then opts[t.to_sym] = true
        else break end
          cnt += 1
      end
      types[cnt..-1].join('_')
    end
  end
end
