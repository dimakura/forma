# -*- encoding : utf-8 -*-
require 'spec_helper'

RSpec.describe Forma::Editor do
  before(:all) do
    @user = User.new({ username: 'dimakura', first_name: 'Dimitri', last_name: 'Kurashvili', age: 35 })
    @editor = Forma::Editor.new model: @user, label_width: 250
    @editor.with_fields do |e|
      e.readonly_text_field :username
      e.required_text_field :first_name
      e.text_field :last_name
      e.text_field :age
    end
    @html = @editor.to_html
  end

  specify { expect(@html).to include('forma-editor') }
  specify { expect(@html).to include('First Name') }
  specify { expect(@html).to include('Last Name') }
  specify { expect(@html).to include('Age') }
  specify { expect(@html).to include('>dimakura<') }
  specify { expect(@html).to include('val="Dimitri"') }
  specify { expect(@html).to include('val="Kurashvili"') }
  specify { expect(@html).to include('val="35"') }
  specify { expect(@html).to include('width="250"') }
  specify { expect(@html).to include('<tr class="forma-required">') }
end
