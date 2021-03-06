# -*- encoding : utf-8 -*-
module Forma
  module UtilsMethods
    def model_value(model, name)
      name.to_s.split('.').each do |fld|
        if model.instance_of?(Hash)
          model = model[ fld.to_sym ]
        else
          model = model.send( fld.to_sym )
        end
      end
      model
    end
  end

  class Utils
    extend UtilsMethods
  end
end
