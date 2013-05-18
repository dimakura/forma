# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'Number configuration' do
  specify { Forma.config.num.delimiter.should == ',' }
  specify { Forma.config.num.separator.should == '.' }
end

describe 'Date configuration' do
  specify { Forma.config.date.formatter.should == '%d-%b-%Y' }
end

describe 'Texts configuration' do
  specify { Forma.config.texts.empty.should == '(empty)' }
end

describe 'Map configuration' do
  specify { Forma.config.map.default_latitude == 41.711447 }
  specify { Forma.config.map.default_longitude == 44.754514 }
end
