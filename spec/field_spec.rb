# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'mongoid'

include Forma

class User
  include Mongoid::Document
end

describe 'field naming' do
  context do
    specify { TextField.new(name: 'first_name').field_rails_name(User.new).should == 'user[first_name]' }
    specify { TextField.new(name: 'address.city').field_rails_name(User.new).should == 'user[address_attributes[city]]' }
  end
end

describe 'text field' do
  before(:all) do
    @fld = TextField.new(name: 'name')
  end
  specify { @fld.name.should == 'name' }
end

describe 'complex field' do
  before(:all) do
    @cmplx = ComplexField.new()
    @cmplx.text_field name: 'first_name'
    @cmplx.text_field name: 'last_name'
  end
  specify { @cmplx.fields.size.should == 2 }
end
