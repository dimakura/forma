# -*- encoding : utf-8 -*-
require 'spec_helper'

RSpec.describe Forma::Helpers do

  context 'table helpers' do
    before(:all) do
      models = [
        { first_name: 'Dimitri', last_name: 'Kurashvili' },
        { first_name: 'Misho', last_name: 'Kurashvili' }
      ]
      @table_html = Forma::Helpers.table_for(models) do |t|
        t.text_field 'first_name'
        t.text_field 'last_name'
      end
    end

    specify { expect(@table_html).to include('Dimitri') }
    specify { expect(@table_html).to include('Misho') }
    specify { expect(@table_html).to include('Kurashvili') }
  end

end
