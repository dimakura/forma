# -*- encoding : utf-8 -*-
require 'spec_helper'
include Forma::Html

describe 'Element creation' do
  compare_object(Element.new('div'), { tag: 'div', text: nil, safe: nil, html: '<div/>' })
  compare_object(Element.new('SPAN', text: 'some text'), { tag: 'span', text: 'some text', safe: nil, html: '<span>some text</span>' } )
  compare_object(Element.new('div', text: '<a>b</a>'), { html: '<div>&lt;a&gt;b&lt;/a&gt;</div>' })
  compare_object(Element.new('div', safe: '<a>b</a>'), { html: '<div><a>b</a></div>' })
end

describe 'Element html generation' do
  before(:all) do
    @el1 = Element.new('div')
    @el2 = Element.new('div', text: 'text')
    @el3 = Element.new('div', text: 'text', attrs: { class: 'class1' })
    @el4 = Element.new('div', children: [ @el1 ])
  end
  specify { @el1.html.should == '<div/>' }
  specify { @el2.html.should == '<div>text</div>' }
  specify { @el3.html.should == '<div class="class1">text</div>' }
  specify { @el4.html.should == '<div><div/></div>' }
end
