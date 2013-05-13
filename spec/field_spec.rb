# -*- encoding : utf-8 -*-
require 'spec_helper'

include Forma

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
