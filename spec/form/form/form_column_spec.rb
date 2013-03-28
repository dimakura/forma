# -*- encoding : utf-8 -*-
require 'spec_helper'
include Forma::Form

describe 'Form Column' do
  before(:all) do
    @col = FormColumn.new
  end
  subject { @col }
  it { should be_empty }
  its(:fields) { should_not be_nil }
  its(:fields) { should be_empty }
  its(:to_e) { should be_nil }
  [:email, :first_name, :last_name].each do |f|
    context do
      before(:all) do
        @col << SimpleField.new(name: f)
      end
      context do
        subject { @col }
        it { should_not be_empty }
        its(:fields) { should_not be_nil }
        its(:fields) { should_not be_empty }
        specify { subject.fields.last.name.should == f }
        its(:size) { should == @col.fields.size }
      end
      context do
        before(:all) do
          @element = @col.to_e
          @innerElement = @element.children[0]
        end
        specify { @element[:class].should == [ 'ff-form-col' ] }
        specify { @element.children.size.should == 1 }
        specify { @innerElement[:class].should == [ 'ff-form-col-inner' ] }
        specify { @innerElement.children.size.should == @col.fields.size }
        specify { @innerElement.children.last[:class].should == [ 'ff-field' ] }
      end
    end
  end
end
