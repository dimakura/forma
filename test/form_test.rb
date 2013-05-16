# -*- encoding : utf-8 -*-
require 'test_helper'

class FormTest < Test::Unit::TestCase
  include Forma

  def test_general_field
    model = { first_name: 'Dimitri', last_name: 'Kurashvili' }
    fld_first_name = TextField.new(model_name: 'user', name: 'first_name', model: model)
    fld_last_name = TextField.new(model_name: 'user', name: 'last_name', model: model)
    frm = Form.new
    frm.add_field(fld_first_name)
    frm.add_field(fld_last_name)
    puts frm.to_html
  end
end
