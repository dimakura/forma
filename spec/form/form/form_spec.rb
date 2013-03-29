# -*- encoding : utf-8 -*-
require 'spec_helper'
include Forma::Form

describe 'Form' do
  before(:all) do
    @form = Form.new(title: 'Title', icon: 'user.png')
  end
  specify { @form.title.should == 'Title' }
  specify { @form.icon.should == 'user.png' }
  specify { @form.tabs.should_not be_nil }
  specify { @form.tabs.should_not be_empty }
  specify { @form.tabs.size.should == 1 }
  ['email', 'first_name', 'last_name', 'mobile'].each do |f|
    context do
      before(:all) do
        @form << SimpleField.new(name: f, caption: f.capitalize)
        @tab = @form.tabs[0]
      end
      specify { @form.tabs.size.should == 1 }
      specify { @tab.fields.should_not be_empty }
      specify { @tab.fields.size.should == @tab.col1.fields.size }
      specify { @form.fields.size.should == @tab.fields.size }
    end
  end
end
