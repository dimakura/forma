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

def form_user(user)
  form = Form.new(title: 'User Properties', icon: 'user.png', model: user)
  form << TextField.new(name: 'email', caption: 'Email')
  form << TextField.new(name: 'first_name', caption: 'First Name')
  form << TextField.new(name: 'last_name', caption: 'Last Name')
  form
end

def check_form_title_element(form, model, title_element)
  if form.collapsible
    colapsible_element = title_element.children[0]
    clps_element = colapsible_element.children[0]
    icon_element = colapsible_element.children[1]
    text_element = colapsible_element.children[2]
    children_cnt = 1
  else
    icon_element = title_element.children[0]
    text_element = title_element.children[1]
    children_cnt = 2
  end
  describe do
    if clps_element
      if form.collapsed
        specify { clps_element[:class].should == [ 'ff-collapse', 'ff-collapsed' ] }
      else
        specify { clps_element[:class].should == [ 'ff-collapse' ] }
      end
      specify { colapsible_element[:class].should == [ 'ff-collapsible' ] }
      specify { clps_element.tag.should == 'span' }
    end
    specify { title_element[:class].should == [ 'ff-title' ] }
    specify { title_element.children.size.should == children_cnt }
    specify { icon_element[:class].should == [ 'ff-icon' ] }
    specify { icon_element[:src].should == form.icon }
    specify { text_element[:class].should == [ 'ff-title-text' ] }
    specify { text_element.text.should == form.title }
  end
end

def check_form_body_element(form, model, body_element)
  has_multiple_tabs = form.tabs.size > 1
  tabs_element = has_multiple_tabs ? body_element.children[1] : body_element.children[0]
  tabsHeader_element = has_multiple_tabs ? body_element.children[0] : nil
  describe do
    specify { body_element[:class].should == [ 'ff-form-body' ] }
    specify { body_element.children.size.should == (has_multiple_tabs ? 2 : 1) }
    specify { tabs_element.should_not be_nil }
    specify { tabs_element.children.size.should == form.tabs.size }
    specify { tabs_element[:class].should == [ 'ff-tabs' ] }
    if has_multiple_tabs
      specify { tabsHeader_element.should_not be_nil }
      specify { tabsHeader_element.tag.should == 'ul' }
      specify { tabsHeader_element[:class].should == [ 'ff-tabs-header' ] }
      specify { tabsHeader_element.children.size.should == form.tabs.size }
    end
  end
end

def check_form_element(form, model, form_element)
  title_element = form_element.children[0]
  body_element = form_element.children[1]
  describe do
    specify { form_element[:class].should == [ 'ff-form' ] }
    specify { form_element.children.size.should == 2 }
    specify { form_element[:id].should_not be_nil }
    specify { form_element.attributes.ensure_id.should == true }
  end
  check_form_title_element(form, model, title_element)
  check_form_body_element(form, model, body_element)
end

describe 'Simple Form' do
  user = User.new(email: 'dimakura@gmail.com', first_name: 'Dimitri', last_name: 'Kurashvili', mobile: '595335514')
  form = form_user(user)
  check_form_element(form, user, form.to_e)
end

describe 'Form with collapsible title' do
  user = User.new(email: 'dimakura@gmail.com', first_name: 'Dimitri', last_name: 'Kurashvili', mobile: '595335514')
  form = form_user(user)
  form.collapsible = true
  check_form_element(form, user, form.to_e)
  form.collapsed = true
  check_form_element(form, user, form.to_e)
end

describe 'Form with two tabs' do
  user = User.new(email: 'dimakura@gmail.com', first_name: 'Dimitri', last_name: 'Kurashvili', mobile: '595335514')
  form = Form.new(title: 'User Properties', icon: 'user.png', model: user)
  form.tabs[0].title = 'General'
  form << TextField.new(name: 'email', caption: 'Email')
  tab2 = FormTab.new(title: 'Name')
  tab2 << TextField.new(name: 'first_name', caption: 'First Name')
  tab2 << TextField.new(name: 'last_name', caption: 'Last Name')
  form.tabs << tab2
  check_form_element(form, user, form.to_e)
end
