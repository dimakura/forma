# -*- encoding : utf-8 -*-
require 'spec_helper'
include Forma::Form

describe 'Simple field' do
  before(:all) do
    @u = User.new(email: 'dimitri@c12.ge', first_name: 'Dimitri', last_name: 'Kurashvili')
  end
  ['email', 'first_name', 'last_name', 'full_name'].each do |f|
    describe do
      before(:all) do
        @f = SimpleField.new(name: f)
        @f.model = @u
      end
      context do
        subject { @f }
        its(:model) { should == @u }
        its(:value) { should == @u.send(f) }
      end
      context do
        subject { @f.cell_element }
        its(:tag) { should == 'div' }
        specify { subject[:class].should == [ 'ff-cell' ] }
        specify { subject.children.size.should == 1 }
        specify { subject.children[0][:class].should == [ 'ff-content' ] }
        specify { subject.children[0].text.should == @f.value }
        specify { subject.children[0].tag.should == 'span' }
      end
    end
  end

end
