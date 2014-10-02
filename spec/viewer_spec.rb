# -*- encoding : utf-8 -*-
require 'spec_helper'

RSpec.describe Forma::Viewer do
  before(:all) do
    @user = User.new({ first_name: 'Dimitri', last_name: 'Kurashvili', age: 35 })
    @viewer = Forma::Viewer.new model: @user, label_width: 250
    @viewer.col1 do |c|
      c.text_field :first_name
      c.text_field :last_name
      c.text_field :age
    end
    @col1 = @viewer.col1
    @html = @viewer.to_html
  end

  specify{ expect(@col1.fields).not_to be_nil }

  specify{ expect(@html).to include('<div class="forma-viewer">') }
  specify{ expect(@html).to include('First Name') }
  specify{ expect(@html).to include('Last Name') }
  specify{ expect(@html).to include('Age') }
  specify{ expect(@html).to include('Dimitri') }
  specify{ expect(@html).to include('Kurashvili') }
  specify{ expect(@html).to include('35') }
  specify{ expect(@html).to include('width="250"') }
end
