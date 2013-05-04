# -*- encoding : utf-8 -*-
require 'spec_helper'

include Forma::Html

describe 'attribute helper method' do
  specify { attr('id', 'forma4').to_s.should == 'id="forma4"' }
  specify { attr('btn').to_s.should == 'class="btn"' }
  specify { attr(['btn', 'btn-primary']).to_s.should == 'class="btn btn-primary"' }
  specify { attr({'font-size' => '10px', 'font-weight' => 'bold'}).to_s.should == 'style="font-size:10px;font-weight:bold"' }
end

describe 'element creation' do
  specify { el('div').to_s.should == '<div></div>' }
  specify { el('div', attrs: { id: 'forma4' }).to_s.should == '<div id="forma4"></div>' }
  specify { el('div', attrs: { id: 'forma4', class: 'main' }).to_s.should == '<div id="forma4" class="main"></div>' }
  specify { el('div', attrs: { id: 'forma4', class: ['main', 'very-important'], style: {'font-size' => '10px'} }).to_s.should == '<div id="forma4" class="main very-important" style="font-size:10px"></div>' }
end

describe 'element id' do
  specify { el('div').id.should be_nil }
  specify { el('div', attrs: { id: 'forma4' }).id.should == 'forma4' }
  specify { el('div', attrs: { class: 'myform1' }).klass.should == [ 'myform1' ] }
  specify { el('div', attrs: { class: ['myform1', 'myform2'] }).klass.should == [ 'myform1', 'myform2' ] }
end
