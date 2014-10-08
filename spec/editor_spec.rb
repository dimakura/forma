# -*- encoding : utf-8 -*-
require 'spec_helper'

RSpec.describe Forma::Editor do
  before(:all) do
    @user = User.new({
      username: 'dimakura',
      first_name: 'Dimitri',
      last_name: 'Kurashvili',
      age: 35,
      password: 'secret',
      city: 'ABS',
      contacts: [
        { id: 1, type: 'email', value: 'dimakura@gmail.com' },
        { id: 2, type: 'mobile', value: '555666777' },
      ]
    })
    @editor = Forma::Editor.new model: @user, label_width: 250, url: '/register'
    @editor.with_fields do |e|
      e.readonly_text_field :username
      e.required_text_field :first_name
      e.password_field :password
      e.text_field :last_name
      e.text_field :age
      e.combo_field 'city', collection: { 'TBS' => 'Tbilisi', 'KTS' => 'Kutaisi', 'BTM' => 'Batumi', 'ABS' => 'Abasha' }
      e.many_field :contacts, add_text: 'New Contact' do |contacts_form|
        contacts_form.text_field :type
        contacts_form.text_field :value
      end
      e.submit 'Register'
    end
    @html = @editor.to_html
    #puts @html
  end

  specify { expect(@html).to include('forma-editor') }
  specify { expect(@html).to include('First Name') }
  specify { expect(@html).to include('Last Name') }
  specify { expect(@html).to include('Age') }
  specify { expect(@html).to include('>dimakura<') }
  specify { expect(@html).to include('value="Dimitri"') }
  specify { expect(@html).to include('value="Kurashvili"') }
  specify { expect(@html).to include('value="35"') }
  specify { expect(@html).to include('value="secret"') }
  specify { expect(@html).to include('width="250"') }
  specify { expect(@html).to include('<tr class="forma-required">') }
  specify { expect(@html).to include('<button type="submit" class="btn btn-primary">Register</button>') }
  specify { expect(@html).to include('method="post"') }
  specify { expect(@html).to include('action="/register"') }
  specify { expect(@html).to include('<select class="forma-combo2-field" name="user[city]">') }
  specify { expect(@html).to include('<option selected value="ABS">Abasha</option>') }
  specify { expect(@html).to include('<option value="TBS">Tbilisi</option>') }

  # many field
  specify { expect(@html).to include('<div class="forma-many-field">') }
  specify { expect(@html).to include('<input name="user[contacts_attributes][0][id]" value="1" type="hidden" class="forma-hidden-field forma-id form-control"/>') }
  specify { expect(@html).to include('<input name="user[contacts_attributes][1][id]" value="2" type="hidden" class="forma-hidden-field forma-id form-control"/>') }
  specify { expect(@html).to include('<input name="user[contacts_attributes][0][_destroy]" value="" type="hidden" class="forma-hidden-field forma-destroy form-control"/>') }
  specify { expect(@html).to include('<input name="user[contacts_attributes][1][_destroy]" value="" type="hidden" class="forma-hidden-field forma-destroy form-control"/>') }
  specify { expect(@html).to include('<input name="user[contacts_attributes][0][type]" value="email" type="text" class="forma-text-field form-control"/>') }
  specify { expect(@html).to include('<input name="user[contacts_attributes][0][value]" value="dimakura@gmail.com" type="text" class="forma-text-field form-control"/>') }
  specify { expect(@html).to include('<input name="user[contacts_attributes][1][type]" value="mobile" type="text" class="forma-text-field form-control"/>') }
  specify { expect(@html).to include('<input name="user[contacts_attributes][1][value]" value="555666777" type="text" class="forma-text-field form-control"/>') }
  specify { expect(@html).to include('<a class="forma-many-action" href="#">') }
  specify { expect(@html).to include 'New Contact' }
end
