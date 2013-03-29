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
