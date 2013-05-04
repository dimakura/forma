# -*- encoding : utf-8 -*-

# Utilities for html text generation.
module Forma::Html

  # Attribute creation.
  def attr(*params)
    if params.length == 2
      SimpleAttr.new(params[0].to_s, params[1].to_s)
    elsif params.length == 1 and params[0].is_a?(Hash)
      StyleAttr.new(params[0])
    elsif params.length == 1
      ClassAttr.new(params[0])
    else
      raise "illegal attr specification: #{params}"
    end
  end

  # You can easily create elements using this method.
  #
  # ```
  # include Forma::Html
  # element = el("div", attrs = {id: 'main', class: 'header', style: {'font-size' => '20px'}})
  # html = element.to_s
  # ```
  def el(tag, opts = {})
    opts = opts.symbolize_keys
    h = { text: opts[:text] }
    if opts[:attrs]
      attributes = []
      opts[:attrs].each do |k, v|
        if k == :class || k == :style
          attributes << attr(v)
        else
          attributes << attr(k, v)
        end
      end
      h[:attrs] = attributes
    end
    h[:children] = opts[:children]
    Element.new(tag, h)
  end

  module_function :attr
  module_function :el

  private

  class Attr; end

  # Simple attribute.
  class SimpleAttr < Attr
    def initialize(name, value)
      @name = name
      @value = value
    end

    def name
      @name
    end

    def value
      @value
    end

    def to_s
      if @name.present? and @value.present?
        %Q{#{@name}="#{@value}"}
      end
    end
  end

  # Class attribute.
  class ClassAttr < Attr
    def initialize(values)
      @values = values
    end

    def values
      @values
    end

    def to_s
      if @values.present?
        if @values.is_a?(Array)
          %Q{class="#{@values.join(" ")}"}
        else
          %Q{class="#{@values}"}
        end
      end
    end
  end

  # Style attribute.
  class StyleAttr < Attr
    def initialize(styles)
      @styles = styles
    end

    def styles
      @styles
    end

    def to_s
      if @styles.present?
        %Q{style="#{@styles.map{ |k,v| "#{k}:#{v}" }.join(";")}"}
      end
    end
  end

  # Element class.
  class Element

    def initialize(tag, h)
      @tag = tag.to_s
      @text = h[:text]
      @attrs = h[:attrs] || []
      @children = []
      h[:children].each { |c| @children << c } if h[:children]
    end

    def id
      ids = @attrs.select { |x| x.is_a?(SimpleAttr) and x.name == "id" }.map { |x| x.value }
      ids[0] if ids.length > 0
    end

    def html_class
      # TODO:
    end

    def to_s
      generate_html.html_safe
    end

    private

    def generate_html
      h = ''
      h << '<' << @tag << generate_tag_and_attributes.to_s << '>'
      h << generate_inner_html
      h << '</' << @tag << '>'
      h
    end

    def generate_tag_and_attributes
      attrs = @attrs.map{|a| a.to_s}.reject{|s| s.blank? }.join(" ")
      ' ' << attrs unless attrs.blank?
    end

    def generate_inner_html
      h = ''
      if @text.html_safe?
        h << @text
      else
        h << ERB::Util.html_escape(@text)
      end
      h << generate_children unless @children.blank?
      h
    end

    def generate_children
      h = ''
      @children.each { |c| h << c.to_s }
      h
    end
  end

end
