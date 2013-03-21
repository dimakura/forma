# -*- encoding : utf-8 -*-
module Forma::Html

  class Attributes

    def initialize(attrs = {})
      self.update_attributes(attrs) if attrs.present?
    end

    def update_attributes(attrs)
      attrs.each { |k, v| self[k] = v }
    end

    def [](k)
      k = k.to_s
      v = attributes[k.to_s]
      case k
      when 'class' then v = @klass ||= []
      when 'style' then v = @style ||= {}
      end
      v
    end

    def []=(k,v)
      k = k.to_s
      case k
      when 'class' then assign_class(v)
      when 'style' then assign_style(v)
      else attributes[k] = v
      end
    end

    def add_class(k)
      klass << k
    end

    def add_style(k,v)
      style[k] = v
    end

    def klass
      self[:class]
    end

    def style
      self[:style]
    end

    def empty?
      attributes.empty? and klass.empty? and style.empty?
    end

    def html
      generate_html unless empty?
    end

    private

    def attributes
      @attributes ||= {}
    end

    def assign_class(v)
      if v.is_a? Array
        @klass = v
      elsif v.nil?
        @klass = []
      else
        @klass = [ v ]
      end
    end

    def assign_style(v)
      raise 'style should be a hash' unless v.is_a? Hash
      @style = v
    end

    def generate_html
      h = ''
      h << ' ' << generate_class_html unless klass.empty?
      h << ' ' << generate_style_html unless style.empty?
      h << ' ' << generate_attributes_html unless attributes.empty?
      h.strip
    end

    def generate_class_html
      %Q{class="#{klass.join(' ')}"}
    end

    def generate_style_html
      st = []
      style.each { |k,v| st << "#{k}:#{v}" }
      %Q{style="#{st.join(';')}"}
    end

    def generate_attributes_html
      s = []
      attributes.each { |k,v| s << %Q{#{k}="#{v}"} }
      s.join(' ')
    end

  end

end
