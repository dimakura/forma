require 'spec_helper'

describe 'generate icon' do
  before(:all) do
    @icon = Forma::IconGenerator.to_html('user')
    @icon2 = Forma::IconGenerator.to_html('user', type: 'png', path: '/icons')
  end

  specify { expect(@icon).to eq('<i class="fa fa-user"/>') }
  specify { expect(@icon2).to eq('<img src="/icons/user.png"/>') }
end
