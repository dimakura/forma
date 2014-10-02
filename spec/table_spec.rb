# -*- encoding : utf-8 -*-
require 'spec_helper'

RSpec.describe Forma::Table do

  before(:all) do
    fields = [ Forma::Field.new(name: 'first_name'),
               Forma::Field.new(name: 'last_name'),
               Forma::Field.new(name: 'age') ]
    @table = Forma::Table.new(fields: fields, models: [
      User.new({ first_name: 'Dimitri', last_name: 'Kurashvili', age: 35 }),
      User.new({ first_name: 'Misho', last_name: 'Kurashvili', age: 8 }),
    ])
    @html = @table.viewer_html
    @table2 = Forma::Table.new(fields: fields)
    @html2 = @table2.viewer_html
    @html3 = @table.viewer_html(hide_header: true)
  end

  specify{ expect(@html).to include('<table class="table table-bordered table-striped">') }
  specify{ expect(@html).to include('<th>First Name</th>') }
  specify{ expect(@html).to include('<th>Last Name</th>') }
  specify{ expect(@html).to include('<th>Age</th>') }

  specify{ expect(@html).to include('Dimitri') }
  specify{ expect(@html).to include('Kurashvili') }
  specify{ expect(@html).to include('Misho') }

  specify{ expect(@html2).to include('<td colspan="3" class="forma-no-data">no-data</td>') }

  specify{ expect(@html3).not_to include('<th>First Name</th>') }
end
