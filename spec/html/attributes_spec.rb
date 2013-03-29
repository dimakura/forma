# -*- encoding : utf-8 -*-
require 'spec_helper'
include Forma::Html

def test_attributes_emptiness(attrs, empty = true)
  if empty
    specify { attrs.klass.should be_empty }
    specify { attrs.style.should be_empty }
    specify { attrs.should be_empty }
    specify { attrs.html.should be_nil }
  else
    specify { attrs.should_not be_empty }
    specify { attrs.html.should_not be_nil }
  end
end

describe 'Empty attributes' do
  test_attributes_emptiness(Attributes.new)
  test_attributes_emptiness(Attributes.new(class: []))
  test_attributes_emptiness(Attributes.new(style: {}))
  test_attributes_emptiness(Attributes.new(class: [], style: {}))
  test_attributes_emptiness(Attributes.new(id: '1'), false)
  test_attributes_emptiness(Attributes.new(class: 'myclass'), false)
  test_attributes_emptiness(Attributes.new(style: {'font-size' => '12px'}), false)
end

describe 'Attributes creation' do
  before(:all) do
    @attrs = Attributes.new(id: 'id-1', class: 'myclass', 'data-method' => 'delete', style: { 'font-size' => '10px', 'color' => 'red' })
    @attrs.add_class('important')
    @attrs.add_style('font-weigh', 'bold')
  end
  specify { @attrs.klass.should == [ 'myclass', 'important' ] }
  specify { @attrs.style['font-size'].should == '10px' }
  specify { @attrs.style['color'].should == 'red' }
  specify { @attrs.style['font-weigh'].should == 'bold' }
end

describe 'Html generation' do
  before(:all) do
    @attr1 = Attributes.new(class: 'myclass')
    @attr2 = Attributes.new(class: ['class1', 'class2'])
    @attr3 = Attributes.new(style: {'font-size' => '14px', 'color' => 'red'})
    @attr4 = Attributes.new(class: ['class1', 'class2'], style: {'font-size' => '14px', 'color' => 'red'})
    @attr5 = Attributes.new(id: 'id1', class: ['class1', 'class2'], style: {'font-size' => '14px', 'color' => 'red'})
    @attr6 = Attributes.new(id: 'id1', class: ['class1', 'class2'], style: {'font-size' => '14px', 'color' => 'red'}, 'data-method' => 'delete')
  end
  specify { @attr1.html.should == 'class="myclass"' }
  specify { @attr2.html.should == 'class="class1 class2"' }
  specify { @attr3.html.should == 'style="font-size:14px;color:red"' }
  specify { @attr4.html.should == 'class="class1 class2" style="font-size:14px;color:red"' }
  specify { @attr5.html.should == 'class="class1 class2" style="font-size:14px;color:red" id="id1"' }
  specify { @attr6.html.should == 'class="class1 class2" style="font-size:14px;color:red" id="id1" data-method="delete"' }
end

describe 'Ensure attribute id' do
  before(:all) do
    @a = Attributes.new(class: 'myclass', ensure_id: true)
  end
  specify { @a.ensure_id.should == true }
  specify { @a.html.index('id').should_not be_nil }
end
