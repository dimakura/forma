# -*- encoding : utf-8 -*-
require 'spec_helper'
include Forma::Form

describe 'Simple field' do
  before(:all) do
    @u = User.new(email: 'dimitri@c12.ge', first_name: 'Dimitri', last_name: 'Kurashvili')
  end
  ['email', 'first_name', 'last_name', 'full_name', 'mobile'].each do |f|
    describe do
      before(:all) do
        @f = SimpleField.new(name: f, tooltip: f, caption: f.capitalize, options: { width: 200 }, required: true)
        @f.model = @u
      end
      context 'field values' do
        subject { @f }
        its(:model) { should == @u }
        its(:value) { should == @u.send(f) }
      end
      context 'cell element' do
        subject { @f.cell_element }
        its(:tag) { should == 'div' }
        specify { subject[:class].should == [ 'ff-cell' ] }
        specify { subject.children.size.should == 1 }
        specify do
          if @f.value.present?
            subject.children[0][:class].should == [ 'ff-content' ]
            subject.children[0][:title].should == f
            subject.children[0].text.should == @f.value
            subject.children[0][:style].should == {}
          else
            subject.children[0][:class].should == [ 'ff-empty', 'ff-content' ]
            subject.children[0].text.should == Forma.config.texts.empty
          end
        end
      end
      context 'cell element: edit' do
        subject { @f.cell_element(edit: true) }
        its(:tag) { should == 'div' }
        specify { subject[:class].should == [ 'ff-cell' ] }
        specify { subject.children.size.should == 1 }
        specify { subject.children[0][:class].should == [ 'ff-content' ] }
        specify { subject.children[0].tag.should == 'input' }
        specify { subject.children[0][:type].should == 'text' }
        specify { subject.children[0][:val].should == (@f.value || '') }
        specify { subject.children[0][:style].should == { width: "200px" } }
      end
      context 'caption element' do
        subject { @f.caption_element }
        its(:tag) { should == 'div' }
        its(:text) { should == f.capitalize }
        specify { subject[:class].should == ['ff-caption', 'ff-required'] }
      end
      context 'field element' do
        subject { @f.field_element }
        its(:tag) { should == 'div' }
        specify { subject.children.size.should == 2 }
        specify { subject.children[0].tag.should == 'div' }
        specify { subject.children[1].tag.should == 'div' }
        specify { subject.children[0][:class].should == ['ff-caption', 'ff-required'] }
        specify { subject.children[1][:class].should == ['ff-cell'] }
      end
    end
  end
end
