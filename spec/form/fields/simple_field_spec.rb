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
      subject { @f }
      its(:model) { should == @u }
      its(:value) { should == @u.send(f) }
    end
  end

end
