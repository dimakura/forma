# -*- encoding : utf-8 -*-
module Forma::Form

  class DateField < SimpleField

    protected

    def view_element_content
      self.value.strftime('%d-%b-%Y') if self.value.present?
    end

  end

  class DateTimeField < SimpleField
    protected

    def view_element_content
      self.value.strftime('%d-%b-%Y %H:%M:%S') if self.value.present?
    end
  end

end
