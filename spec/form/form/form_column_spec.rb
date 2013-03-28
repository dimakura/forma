# -*- encoding : utf-8 -*-
require 'spec_helper'
include Forma::Form

describe 'Column' do
  before(:all) do
    @col = FormColumn.new
  end
  subject { @col }
  it { should be_empty }
  its(:fields) { should_not be_nil }
  its(:fields) { should be_empty }
  [:email, :first_name, :last_name].each do |f|
    context do
      before(:all) do
        @col << SimpleField.new(name: f)
      end
      subject { @col }
      it { should_not be_empty }
      its(:fields) { should_not be_nil }
      its(:fields) { should_not be_empty }
      specify { subject.fields.last.name.should == f }
    end
  end
end
