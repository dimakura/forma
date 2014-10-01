# -*- encoding : utf-8 -*-
require 'spec_helper'

RSpec.describe Forma::Field do

  before(:all) do
    fields = [ Forma::Field.new(name: 'first_name'),
               Forma::Field.new(name: 'last_name'),
               Forma::Field.new(name: 'age') ]
    @table = Forma::Table.new(fields: fields, models: [
      { first_name: 'Dimitri', last_name: 'Kurashvili', age: 35 },
      { first_name: 'Misho', last_name: 'Kurashvili', age: 8 },
    ])
    @html = @table.viewer_html
  end

  specify{ expect(@html).to include('<table class="table">') }
  specify{ expect(@html).to include('<th>First Name</th>') }
  specify{ expect(@html).to include('<th>Last Name</th>') }
  specify{ expect(@html).to include('<th>Age</th>') }

  specify{ expect(@html).to include('Dimitri') }
  specify{ expect(@html).to include('Kurashvili') }
  specify{ expect(@html).to include('Misho') }
end
