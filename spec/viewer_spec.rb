# -*- encoding : utf-8 -*-
require 'spec_helper'

RSpec.describe Forma::Viewer do
  before(:all) do
    @user = User.new({ first_name: 'Dimitri', last_name: 'Kurashvili', age: 35 })
    @viewer = Forma::Viewer.new model: @user, label_width: 250
    @viewer.with_fields do |v|
      v.required_text_field :first_name, after: '&mdash;'
      v.text_field :last_name
      v.text_field :age
    end
    @html = @viewer.to_html
  end

  specify { expect(@html).to include('forma-viewer') }
  specify { expect(@html).to include('First Name') }
  specify { expect(@html).to include('Last Name') }
  specify { expect(@html).to include('Age') }
  specify { expect(@html).to include('Dimitri') }
  specify { expect(@html).to include('Kurashvili') }
  specify { expect(@html).to include('35') }
  specify { expect(@html).to include('width="250"') }
  specify { expect(@html).to include('&mdash;') }
  specify { expect(@html).to include('<tr class="forma-required">') }
end
