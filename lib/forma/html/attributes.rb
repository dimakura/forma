# -*- encoding : utf-8 -*-
module Forma::Html

  def attr(*params)
    if params.length == 2 and params[0].is_a?(String) and params[1].is_a?(String)
      SimpleAttr.new(params[0], params[1])
    elsif params.length == 1 and params[0].is_a?(Hash)
      StyleAttr.new(params[0])
    elsif params.length == 1
      ClassAttr.new(params[0])
    else
      raise "illegal attr specification"
    end
  end

  module_function :attr

  class Attr; end

  private

  # Simple attribute.
  class SimpleAttr < Attr
    def initialize(name, value)
      @name = name
      @value = value
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

    def to_s
      if @styles.present?
        %Q{style="#{@styles.map{ |k,v| "#{k}:#{v}" }.join(";")}"}
      end
    end
  end

end
