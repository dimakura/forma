# -*- encoding : utf-8 -*-
require 'spec_helper'
include Forma::Form

describe 'Form' do
  before(:all) do
    @user = User.new(email: 'dimakura@gmail.com', first_name: 'Dimitri', last_name: 'Kurashvili', mobile: '595335514')
    @form = Form.new(title: 'Title', icon: 'user.png', model: @user)
  end
  specify { @form.title.should == 'Title' }
  specify { @form.icon.should == 'user.png' }
  specify { @form.tabs.should_not be_nil }
  specify { @form.tabs.should_not be_empty }
  specify { @form.tabs.size.should == 1 }
  specify { @form.model.should== @user }
  ['email', 'first_name', 'last_name', 'mobile'].each do |f|
    context do
      before(:all) do
        @field = SimpleField.new(name: f, caption: f.capitalize)
        @form << @field
        @tab = @form.tabs[0]
      end
      specify { @form.tabs.size.should == 1 }
      specify { @tab.fields.should_not be_empty }
      specify { @tab.fields.size.should == @tab.col1.fields.size }
      specify { @form.fields.size.should == @tab.fields.size }
      specify { @field.model.should == @user }
      specify { @field.value.should == @user.send(f) }
    end
  end
end

def check_form_title_element(form, model, title_element)
  icon_element = title_element.children[0]
  text_element = title_element.children[1]
  describe do
    specify { title_element[:class].should == [ 'ff-title' ] }
    specify { title_element.children.size.should == 2 }
    specify { icon_element[:class].should == [ 'ff-icon' ] }
    specify { icon_element[:src].should == form.icon }
    specify { text_element[:class].should == [ 'ff-title-text' ] }
    specify { text_element.text.should == form.title }
  end
end

def check_form_body_element(form, model, body_element)
  describe do
    specify { body_element[:class].should == [ 'ff-form-body' ] }
  end
end

def check_form_element(form, model, form_element)
  title_element = form_element.children[0]
  body_element = form_element.children[1]
  describe do
    specify { form_element[:class].should == [ 'ff-form' ] }
    specify { form_element.children.size.should == 2 }
  end
  check_form_title_element(form, model, title_element)
  check_form_body_element(form, model, body_element)
end

describe 'Form Generation' do
  user = User.new(email: 'dimakura@gmail.com', first_name: 'Dimitri', last_name: 'Kurashvili', mobile: '595335514')
  form = Form.new(title: 'User Properties', icon: 'user.png', model: user)
  check_form_element(form, user, form.to_e)
end
