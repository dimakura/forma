# -*- encoding : utf-8 -*-
require 'spec_helper'

APP = nil

describe 'module' do
  before(:all) do
    @module = Forma::Module.new(APP, 'site')
  end
  subject { @module }
  its(:name) { should == 'site' }
  its(:label) { should == 'site' }
end
