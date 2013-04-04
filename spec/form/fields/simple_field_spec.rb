# -*- encoding : utf-8 -*-
require 'spec_helper'
include Forma::Form

def simple_field_value_checking(field, model, value)
  context 'field values' do
    subject { field }
    its(:model) { should == model }
    its(:value) { should == value }
  end
end

# Checks field to be a 'cell' element.
def simple_field_cell_checking(field, element)
  context do
    specify { element[:class].should == [ 'ff-cell' ] }
    specify { element.children.size.should == 1 }
    specify do
      if field.value.present?
        element.children[0][:class].should == [ 'ff-content' ]
        element.children[0][:title].should == field.tooltip
        element.children[0].text.should == field.value
        element.children[0][:style].should == {}
      else
        element.children[0][:class].should == [ 'ff-empty', 'ff-content' ]
        element.children[0].text.should == Forma.config.texts.empty
      end
    end
  end
end

# Checks field to be an editable 'cell' element.
def simple_field_editcell_checking(field, element)
  context 'cell element: edit' do
    subject { element }
    its(:tag) { should == 'div' }
    specify { subject[:class].should == [ 'ff-cell' ] }
    specify { subject.children.size.should == 1 }
    specify { subject.children[0][:class].should == [ 'ff-content' ] }
    specify { subject.children[0].tag.should == 'input' }
    specify { subject.children[0][:type].should == 'text' }
    specify { subject.children[0][:value].should == (field.value || '') }
    specify { subject.children[0][:style].should == { width: "200px" } }
  end
end

# Check field to be a caption.
def simple_field_caption_checking(caption, element)
  context 'caption element' do
    subject { element }
    its(:tag) { should == 'div' }
    its(:text) { should == caption }
    specify { subject[:class].should == ['ff-caption', 'ff-required'] }
  end
end

# Check field to be a field.
def simple_field_element_checking(field, element)
  simple_field_cell_checking(field, element.children[1]);
  context 'field element' do
    subject { element }
    its(:tag) { should == 'div' }
    specify { subject.children.size.should == 2 }
    specify { subject.children[0].tag.should == 'div' }
    specify { subject.children[1].tag.should == 'div' }
    specify { subject.children[0][:class].should == ['ff-caption', 'ff-required'] }
    specify { subject.children[1][:class].should == ['ff-cell'] }
  end
end

describe 'Simple field' do
  user = User.new(email: 'dimitri@c12.ge', first_name: 'Dimitri', last_name: 'Kurashvili')
  ['email', 'first_name', 'last_name', 'full_name', 'mobile'].each do |f|
    field = SimpleField.new(name: f, tooltip: f, caption: f.capitalize, options: { width: 200 }, required: true, model: user)
    simple_field_value_checking(field, user, user.send(f))
    # cell
    simple_field_cell_checking(field, field.cell_element)
    simple_field_cell_checking(field, field.to_e(:cell))
    # cell[edit: true]
    field.edit = true
    simple_field_editcell_checking(field, field.cell_element)
    simple_field_editcell_checking(field, field.to_e(:cell))
    field.edit = false
    # caption
    simple_field_caption_checking(field.caption.capitalize, field.caption_element)
    simple_field_caption_checking(field.caption.capitalize, field.to_e(:caption))
    # field
    simple_field_element_checking(field, field.field_element)
    simple_field_element_checking(field, field.to_e)
  end
end

describe 'Simple field: manual assignment of a value' do
  before(:all) do
    @user = User.new(email: 'dimitri@c12.ge')
    @email = "dimakura@gmail.com"
    @f1 = TextField.new(name: 'email', model: @user)
    @f2 = TextField.new(name: 'email', model: @user, value: @email)
  end
  specify { @f1.value.should == @user.email }
  specify { @f2.value.should == @email }
end
