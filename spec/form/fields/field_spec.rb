# -*- encoding : utf-8 -*-
require 'spec_helper'
include Forma::Form

describe 'Field creation' do
  compare_object(Field.new(caption: 'Name', before: 'Mr.', required: true, options: {width: 100, height: 300}),
    {
      caption: 'Name', before: 'Mr.', after: nil, readonly: false, required: true,
      'options.width' => 100, 'options.height' => 300
    }
  )
  compare_object(Field.new(caption: 'Amount', after: 'GEL', required: true),
    {
      caption: 'Amount', before: nil, after: 'GEL', readonly: false, required: true
    }
  )
  compare_object(Field.new(caption: 'Created', readonly: true), { caption: 'Created', before: nil, after: nil, readonly: true, required: false })
end

describe 'Field generation' do
  before(:all) do
    @f = Field.new(caption: 'Amount', before: '=', after: 'GEL')
  end
  context do
    subject { @f }
    its(:caption) { should == 'Amount' }
  end
  context do
    subject { @f.cell_element }
    its(:tag) { should == 'div'}
    specify { subject[:class].should == [ 'ff-cell' ] }
    specify { subject.children.size.should == 2 }
  end
  context do
    subject { @f.cell_element.children[0] }
    specify { subject.tag.should == 'span' }
    specify { subject[:class].should == [ 'ff-before' ] }
    specify { subject.text.should == '=' }
  end
  context do
    subject { @f.cell_element.children[1] }
    specify { subject.tag.should == 'span' }
    specify { subject[:class].should == [ 'ff-after' ] }
    specify { subject.text.should == 'GEL' }
  end
end
