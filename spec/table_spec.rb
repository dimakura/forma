# -*- encoding : utf-8 -*-
require 'spec_helper'

RSpec.describe Forma::Field do

  before(:all) do
    fields = [ Forma::Field.new(name: 'first_name'),
               Forma::Field.new(name: 'last_name'),
               Forma::Field.new(name: 'age') ]
    @table = Forma::Table.new(fields: fields)
    @html = @table.viewer_html
  end

  specify{ expect(@html).to include('<table class="table">') }
  specify{ expect(@html).to include('<th>First Name</th>') }
end
