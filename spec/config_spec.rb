# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'Number configuration' do
  specify { Forma.config.num.delimiter.should == ',' }
  specify { Forma.config.num.separator.should == '.' }
end

describe 'Date configuration' do
  specify { Forma.config.date.formatter.should == '%d-%b-%Y' }
end
