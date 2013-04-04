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

def check_text_field(form, model, fld, cell_e)
  specify { cell_e.children.size.should == 1 }
  if form.edit
    input_e = cell_e.children[0]
    specify { input_e.tag.should == 'input' }
    specify { input_e[:type].should == 'text' }
    specify { input_e[:class].should == [ 'ff-content' ] }
    specify { input_e[:value].should == model.send(fld.name) }
  else
    # TODO
  end
end

def check_field_element(form, model, fld, fld_e)
  specify { fld_e[:class].should == [ 'ff-field' ] }
  specify { fld_e.children.size.should == 2 }
  caption_e = fld_e.children[0]
  cell_e = fld_e.children[1]
  if fld.required
    specify { caption_e[:class].should == [ 'ff-caption', 'ff-required' ] }
  else
    specify { caption_e[:class].should == [ 'ff-caption' ] }
  end
  specify { cell_e[:class].should == [ 'ff-cell' ] }
  specify { cell_e.children.size.should == 1 }
  check_text_field(form, model, fld, cell_e) if fld.class == Forma::Form::TextField
end

def check_column_element(form, model, col, col_element)
  specify { col_element.children.size.should == 1 }
  inner_e = col_element.children[0]
  specify { inner_e[:class].should == [ 'ff-form-col-inner' ] }
  specify { inner_e.children.size.should == col.fields.size }
  (0..col.fields.size-1).each do |i|
    fld = col.fields[i]
    fld_e = inner_e.children[i]
    check_field_element(form, model, fld, fld_e)
  end
end

def check_tab_elemet(form, model, tab, tab_element, index)
  specify { tab_element[:id].should_not be_nil }
  specify { tab_element[:id].should_not be_nil }
  classes = index == 0 ? [ 'ff-form-tab-content' ] : [ 'ff-form-tab-content', 'ff-hidden' ]
  specify { tab_element[:class].should == classes }
  specify { tab_element.children.size.should == 1 }
  cols_wrapper = tab_element.children[0]
  specify { cols_wrapper[:class].should == ['ff-form-cols'] }
  cols_size = tab.col2.empty? ? 1 : 2
  specify { cols_wrapper.children.size.should == cols_size }
  col1_e = cols_wrapper.children[0]
  col2_e = cols_wrapper.children[1] if cols_size == 2
  if col2_e
    specify { col1_e[:class].should == [ 'ff-form-col', 'ff-col50' ] }
    specify { col2_e[:class].should == [ 'ff-form-col', 'ff-col50' ] }
    check_column_element(form, model, tab.col1, col1_e)
    check_column_element(form, model, tab.col1, col2_e)
  else
    specify { col1_e[:class].should == [ 'ff-form-col', 'ff-col100' ] }
    check_column_element(form, model, tab.col1, col1_e)
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
  index = 0
  form.tabs.each do |tab|
    check_tab_elemet(form, model, tab, tabs_element.children[index], index)
    index += 1
  end
end

def check_form_element(form, model, form_element)
  describe do
    specify { form_element[:class].should == [ 'ff-form' ] }
    specify { form_element.children.size.should == 2 }
    specify { form_element[:id].should_not be_nil }
    specify { form_element.attributes.ensure_id.should == true }
  end
  title_element = form_element.children[0]
  body_element = form_element.children[1]
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

describe 'Edit form' do
  user = User.new(email: 'dimakura@gmail.com', first_name: 'Dimitri', last_name: 'Kurashvili', mobile: '595335514')
  form = Form.new(title: 'User Properties', icon: 'user.png', model: user, edit: true)
  form.tabs[0].title = 'General'
  form << TextField.new(name: 'email', caption: 'Email')
  tab2 = FormTab.new(title: 'Name')
  tab2 << TextField.new(name: 'first_name', caption: 'First Name', required: true)
  tab2 << TextField.new(name: 'last_name', caption: 'Last Name', required: true)
  form.tabs << tab2
  check_form_element(form, user, form.to_e)
  context do
    specify { form.edit.should == true }
  end
end
