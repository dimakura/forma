# -*- encoding : utf-8 -*-
require 'spec_helper'

RSpec.describe Forma::Field do

  before(:all) do
    fields = [ Forma::Field.new(name: 'first_name'),
               Forma::Field.new(name: 'last_name'),
               Forma::Field.new(name: 'age') ]
    @table = Forma::Table.new(fields: fields)
  end

  specify{ expect(@table.viewer_html).to eq('<table/>') }
end
