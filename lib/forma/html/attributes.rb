# -*- encoding : utf-8 -*-
module Forma::Html

  class Attributes

    # Set this flag to `true` if `id` parameter
    # should be automatically provided for an element 
    # if not set explicitly.
    attr_accessor :ensure_id

    def initialize(attrs = {})
      update_ensure_id(attrs)
      update_attributes(attrs)
    end

    def [](k)
      case k.to_s
        when 'class' then v = @klass ||= []
        when 'style' then v = @style ||= {}
        when 'id'    then v = attributes['id'] ||= (next_id if self.ensure_id)
        else attributes[k.to_s]
      end
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
      attributes.empty? and klass.empty? and style.empty? and not self.ensure_id
    end

    def html
      generate_html unless empty?
    end

    private

    def update_ensure_id(attrs)
      self.ensure_id = attrs.delete(:ensure_id) || attrs.delete('ensure_id')
    end

    def update_attributes(attrs)
      attrs.each { |k, v| self[k] = v }
    end

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
      raise 'style should be a hash' unless v.nil? or v.is_a? Hash
      @style = v
    end

    def generate_html
      h = ''
      h << ' ' << generate_class_html unless klass.empty?
      h << ' ' << generate_style_html unless style.empty?
      h << ' ' << generate_attributes_html
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
      attributes['id'] = next_id if self.ensure_id and attributes['id'].blank?
      attributes.each { |k,v| s << %Q{#{k}="#{v}"} }
      s.join(' ')
    end

    @@id_counter = 0

    def next_id
      @@id_counter = 0 if @@id_counter > 10000
      @@id_counter += 1
      "ff-#{@@id_counter}"
    end

  end

end
