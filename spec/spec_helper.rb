# -*- encoding : utf-8 -*-
require 'rspec'
require 'forma'

RSpec.configure do |config|
  config.include(RSpec::Matchers)
end

def compare_object(obj, properties)
  properties.each do |k, v|
    specify { obj.send(k).should == v }
  end
end
