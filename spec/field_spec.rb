# -*- encoding : utf-8 -*-
require 'spec_helper'

RSpec.describe Forma::Field do

  before(:all) do
    @field1 = Forma::Field.new(value: 'Dimitri')
    @field2 = Forma::Field.new(name: 'last_name', model: { first_name: 'Dimitri', last_name: 'Kurashvili' }, url: 'http://mecniereba.org')
    user = User.new(age: 33)
    @field3 = Forma::Field.new(name: 'age', model: user, tag: 'code')
    @field4 = Forma::Field.new(model_name: 'Sys::User')
  end

  specify{ expect(@field1.viewer_html).to eq('<span class="forma-text-field">Dimitri</span>') }
  specify{ expect(@field2.viewer_html).to eq('<span class="forma-text-field"><a href="http://mecniereba.org">Kurashvili</a></span>') }
  specify{ expect(@field3.viewer_html).to eq('<code class="forma-text-field">33</code>') }
  specify{ expect(Forma::FieldGenerator.model_name_eval(@field4, {})).to eq('sys_user') }
end
