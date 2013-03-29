# -*- encoding : utf-8 -*-
require 'spec_helper'
include Forma::Html

describe 'Element creation' do
  compare_object(Element.new('div'), { tag: 'div', text: nil, html: '<div></div>' })
  compare_object(Element.new('SPAN', text: 'some text'), { tag: 'span', text: 'some text', html: '<span>some text</span>' } )
  compare_object(Element.new('div', text: '<a>b</a>'), { html: '<div>&lt;a&gt;b&lt;/a&gt;</div>' })
  compare_object(Element.new('div', text: '<a>b</a>'.html_safe), { html: '<div><a>b</a></div>' })
end

describe 'Element html generation' do
  before(:all) do
    @el1 = Element.new('div')
    @el2 = Element.new('div', text: 'text')
    @el3 = Element.new('div', text: 'text', attrs: { class: 'class1' })
    @el4 = Element.new('div', children: [ @el1 ])
    @el5 = Element.new('div', attrs: { ensure_id: true })
  end
  specify { @el1.html.should == '<div></div>' }
  specify { @el2.html.should == '<div>text</div>' }
  specify { @el3.html.should == '<div class="class1">text</div>' }
  specify { @el4.html.should == '<div><div></div></div>' }
  specify { @el5.attributes.ensure_id.should == true }
  specify { @el5.html.index('id').should_not be_nil }
end

describe 'Element children' do
  before(:all) do
    @el = Element.new('span')
    @el << Element.new('a')
    @el << nil
    @el << Element.new('em')
  end
  specify { @el.children.size.should == 2 }
  specify { @el.children[0].tag.should == 'a' }
  specify { @el.children[1].tag.should == 'em' }
end
