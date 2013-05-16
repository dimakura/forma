# -*- encoding : utf-8 -*-
require 'test_helper'

class FieldTest < Test::Unit::TestCase
  include Forma

  def test_general_field
    fld = Field.new(model_name: 'user', name: 'first_name', value: 'fake value', label: 'First Name')
    assert_equal 'user', fld.model_name
    assert_equal 'first_name', fld.name
    assert_equal 'models.user.first_name', fld.localization_key
    assert_equal 'First Name', fld.label
    assert_equal 'First Name', fld.localized_label
    assert_equal nil, fld.hint
    assert_equal '', fld.localized_hint
    assert_equal 'fake value', fld.value
    assert_equal 'user_first_name', fld.id
  end

  def test_text_field
    model = { first_name: 'Dimitri', last_name: 'Kurashvili' }
    fld_first_name = TextField.new(model_name: 'user', name: 'first_name', model: model, hint: "user's first name")
    fld_last_name = TextField.new(model_name: 'user', name: 'last_name', model: model)
    assert_equal 'first_name', fld_first_name.name
    assert_equal "user's first name", fld_first_name.hint
    assert_equal "user's first name", fld_first_name.localized_hint
    assert_equal 'Dimitri', fld_first_name.value
    assert_equal 'last_name', fld_last_name.name
    assert_equal 'user_first_name', fld_first_name.id
    assert_equal 'user[first_name]', fld_first_name.parameter_name
    assert_equal 'user_last_name', fld_last_name.id
    assert_equal 'user[last_name]', fld_last_name.parameter_name
    fld_first_name_ka = TextField.new(name: 'ka', parent: fld_first_name)
    assert_equal 'user_first_name_ka', fld_first_name_ka.id
    assert_equal 'user[first_name_attributes[ka]]', fld_first_name_ka.parameter_name
  end

  def test_text_field_value_override
    model = { first_name: 'Dimitri', last_name: 'Kurashvili' }
    fld_first_name = TextField.new(model_name: 'user', name: 'first_name', model: model, value: 'other_name')
    assert_equal 'other_name', fld_first_name.value
    fld_first_name.value = nil
    assert_equal 'Dimitri', fld_first_name.value
  end

  def test_generated_text_field
    model = { first_name: 'Dimitri', last_name: 'Kurashvili' }
    fld_first_name = TextField.new(model_name: 'user', name: 'first_name', model: model)
    el = fld_first_name.edit_element('Dimitri')
    assert_equal 'input', el.tag
    assert_equal 'user_first_name', el.attrs_by_name('id').first.value
    assert_equal 'user[first_name]', el.attrs_by_name('name').first.value
    assert_equal 'text', el.attrs_by_name('type').first.value
    assert_equal 'Dimitri', el.attrs_by_name('value').first.value
  end

  def test_compex_field
    model = { first_name: 'Dimitri', last_name: 'Kurashvili' }
    fld = ComplexField.new(fields: [ TextField.new(name: 'first_name'), TextField.new(name: 'last_name') ])
    fld.model = model
    assert_equal ['Dimitri', 'Kurashvili'], fld.value
  end
end
