# -*- encoding : utf-8 -*-
require 'spec_helper'

RSpec.describe Forma::Helpers do

  context 'table helper' do
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

  context 'viewer helper' do
    before(:all) do
      model = User.new(first_name: 'Dimitri', last_name: 'Kurashvili')
      @viewer_html = Forma::Helpers.viewer_for(model) do |v|
        v.col1 do |c|
          c.text_field 'first_name'
          c.text_field 'last_name'
        end
      end
    end

    specify { expect(@viewer_html).to include('First Name') }
    specify { expect(@viewer_html).to include('Last Name') }
    specify { expect(@viewer_html).to include('Dimitri') }
    specify { expect(@viewer_html).to include('Kurashvili') }
  end

end
