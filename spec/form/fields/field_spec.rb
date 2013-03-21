# -*- encoding : utf-8 -*-
require 'spec_helper'
include Forma::Form

describe 'Field creation' do
  compare_object(Field.new(caption: 'Name', before: 'Mr.', required: true), { caption: 'Name', before: 'Mr.', after: nil, readonly: false, required: true })
  compare_object(Field.new(caption: 'Amount', after: 'GEL', required: true), { caption: 'Amount', before: nil, after: 'GEL', readonly: false, required: true })
  compare_object(Field.new(caption: 'Created', readonly: true), { caption: 'Created', before: nil, after: nil, readonly: true, required: false })
end

describe 'Field generation' do
  before(:all) do
    @f = TextField.new(caption: 'First Name', name: 'first_name')
  end
  context do
    subject { @f }
    its(:caption) { should == 'First Name' }
    its(:name) { should == 'first_name'}
  end
  context do
    subject { @f.cell_node }
    its(:tag) { should == 'div'}
    specify { subject[:class].should == [ 'ff-cell' ] }
  end
end
