# -*- encoding : utf-8 -*-
module Forma
  module Html
    class Element
      def initialize(tag, params, children)
        @tag = tag ; @params = params ; @children = children
      end

      def to_s
        [ tag_open, body, tag_close ].join('')
      end

      private

      def body
        @children.join('')
      end

      def params
        if @params.any?
          ' ' + @params.map{|k,v| "#{k}=\"#{v}\""}.join(' ')
        end
      end

      def tag_open
        ary = ['<', @tag]
        ary << params
        ary << '>' if @children.any?
        ary.join('')
      end

      def tag_close
        if @children.any?
          '</' + @tag + '>'
        else
          '/>'
        end
      end
    end

    def el(*args)
      tag = nil ; children = nil ; params = nil

      args.each do |arg|
        if arg.instance_of?(String)
          if tag.nil?
            tag = arg
          elsif children.nil?
            children = arg
          end
        elsif arg.instance_of?(Hash)
          params = arg if params.nil? 
        elsif arg.instance_of?(Array)
          children = arg if children.nil?
        end
      end

      tag ||= 'div' ; children ||= [] ; params ||= {}

      Element.new(tag, params, children).to_s
    end

    module_function :el
  end
end
