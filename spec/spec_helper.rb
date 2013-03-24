# -*- encoding : utf-8 -*-
require 'rspec'
require 'forma'
require 'models'

RSpec.configure do |config|
  config.include(RSpec::Matchers)
end

def compare_object(obj, properties)
  properties.each do |k, v|
    val = obj
    k.to_s.split('.').each do |key|
      val = val.send(key)
    end
    specify { val.should == v }
  end
end
