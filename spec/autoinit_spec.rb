# -*- encoding : utf-8 -*-
require 'spec_helper'

RSpec.describe Forma::AutoInitialize do

  before(:all) do
    @user = User.new(first_name: 'Dimitri', last_name: 'Kurashvili')
    @user.username = '555666777'
    @user.number 42
  end

  specify{ expect(@user.first_name).to eq('Dimitri') }
  specify{ expect(@user.last_name).to eq('Kurashvili') }
  specify{ expect(@user.username).to eq('555666777') }
  specify{ expect(@user.number).to eq(42) }
end
