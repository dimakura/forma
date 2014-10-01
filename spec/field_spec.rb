# -*- encoding : utf-8 -*-
require 'spec_helper'

class User
  attr_accessor :first_name, :last_name, :age
end

RSpec.describe Forma::Field do

  before(:all) do
    @field1 = Forma::Field.new(value: 'Dimitri')
    @field2 = Forma::Field.new(name: 'last_name', model: { first_name: 'Dimitri', last_name: 'Kurashvili' })
    user = User.new ; user.age = 33
    @field3 = Forma::Field.new(name: 'age', model: user, tag: 'code')
  end

  specify{ expect(@field1.viewer_html).to eq('<span class="forma-text-field">Dimitri</span>') }
  specify{ expect(@field2.viewer_html).to eq('<span class="forma-text-field">Kurashvili</span>') }
  specify{ expect(@field3.viewer_html).to eq('<code class="forma-text-field">33</code>') }
end
