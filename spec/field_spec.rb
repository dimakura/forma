# -*- encoding : utf-8 -*-
require 'spec_helper'

RSpec.describe Forma::Field do

  before(:all) do
    @field = Forma::Field.new(name: 'first_name', type: 'text')
  end

  it 'field options' do
    expect(@field.name).to eq('first_name')
    expect(@field.type).to eq('text')
    expect(@field.id).to be_nil
    expect(@field.class).to eq(Forma::Field)
  end

end
