# -*- encoding : utf-8 -*-
require 'spec_helper'
include Forma::Form

describe 'Form Tab' do
  before(:all) do
    @tab = FormTab.new(title: 'General')
  end
  specify { @tab.title.should == 'General' }
  specify { @tab.icon.should be_nil }
  specify { @tab.should be_empty }
  specify { @tab.col1.should_not be_nil }
  specify { @tab.col1.should be_empty }
  specify { @tab.col2.should_not be_nil }
  specify { @tab.col2.should be_empty }
  context do
    [:email, :first_name, :last_name].each do |f|
      before(:all) do
        @tab << SimpleField.new(name: f)
        @tab_e = @tab.to_e
        @cols_e = @tab_e.children[0]
        @col_e = @cols_e.children[0]
      end
      specify { @tab.col1.should_not be_empty }
      specify { @tab.col2.should be_empty }
      specify { @tab_e.should_not be_nil }
      specify { @tab_e[:id].should_not be_nil }
      specify { @tab_e[:class].should == [ 'ff-form-tab-content' ] }
      specify { @tab_e.children.size.should == 1 }
      specify { @cols_e[:class].should == [ 'ff-form-cols' ] }
      specify { @cols_e.children.size.should == 1 }
      specify { @col_e[:class].should == [ 'ff-form-col', 'ff-col100' ] }
    end
  end
end
