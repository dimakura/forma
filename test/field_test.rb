# -*- encoding : utf-8 -*-
require 'test_helper'

class FieldTest < Test::Unit::TestCase
  include Forma

  def test_general_field
    fld = Field.new(model_name: 'user', name: 'first_name', value: 'fake value')
    assert_equal 'user', fld.model_name
    assert_equal 'first_name', fld.name
    assert_equal 'models.user.first_name', fld.localization_key
    assert_equal 'fake value', fld.value
  end

  def test_text_field
    model = { first_name: 'Dimitri', last_name: 'Kurashvili' }
    fld_first_name = TextField.new(model_name: 'user', name: 'first_name', model: model)
    fld_last_name = TextField.new(model_name: 'user', name: 'last_name', model: model)
    assert_equal 'first_name', fld_first_name.name
    assert_equal 'Dimitri', fld_first_name.value
    assert_equal 'last_name', fld_last_name.name
  end

  def test_text_field_value_override
    model = { first_name: 'Dimitri', last_name: 'Kurashvili' }
    fld_first_name = TextField.new(model_name: 'user', name: 'first_name', model: model, value: 'other_name')
    assert_equal 'other_name', fld_first_name.value
    fld_first_name.value = nil
    assert_equal 'Dimitri', fld_first_name.value
  end

  def test_compex_field
    model = { first_name: 'Dimitri', last_name: 'Kurashvili' }
    fld = ComplexField.new(fields: [ TextField.new(name: 'first_name'), TextField.new(name: 'last_name') ])
    fld.model = model
    assert_equal ['Dimitri', 'Kurashvili'], fld.value
  end
end
