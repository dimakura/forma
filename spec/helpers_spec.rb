# -*- encoding : utf-8 -*-
require 'spec_helper'

RSpec.describe Forma::Helpers do

  context 'table helper' do
    before(:all) do
      models = [
        { first_name: 'Dimitri', last_name: 'Kurashvili', is_admin: true },
        { first_name: 'Misho', last_name: 'Kurashvili', is_admin: false }
      ]
      @table_html = Forma::Helpers.table_for(models) do |t|
        t.text_field 'first_name'
        t.text_field 'last_name'
        t.boolean_field 'is_admin', true_text: 'user is admin', false_text: 'user is not admin'
      end
    end

    specify { expect(@table_html).to include('Dimitri') }
    specify { expect(@table_html).to include('Misho') }
    specify { expect(@table_html).to include('Kurashvili') }
    specify { expect(@table_html).to include('user is admin') }
    specify { expect(@table_html).to include('user is not admin') }
  end

  context 'viewer helper' do
    before(:all) do
      model = User.new(
        first_name: 'Dimitri',
        last_name: 'Kurashvili',
        is_admin: true,
        birthdate: Time.new(1979, 4, 4, 6, 15),
        profile: Profile.new(
          total_friends: 100,
          total_followers: 200,
          email: 'dimakura@gmail.com',
          mobile: '555666777'
        )
      )
      @viewer_html = Forma::Helpers.viewer_for(model) do |v|
        v.text_field 'first_name'
        v.text_field 'last_name'
        v.boolean_field 'is_admin', true_text: 'user is admin', false_text: 'use is not admin'
        v.date_field 'birthdate', class_name: 'text-muted'
        v.text_field 'profile.total_followers'
        v.complex_field 'profile' do |p|
          p.text_field 'email', after: '&mdash;'.html_safe
          p.text_field 'mobile'
        end
      end
    end

    specify { expect(@viewer_html).to include('First Name') }
    specify { expect(@viewer_html).to include('Last Name') }
    specify { expect(@viewer_html).to include('Dimitri') }
    specify { expect(@viewer_html).to include('Kurashvili') }
    specify { expect(@viewer_html).to include('user is admin') }
    specify { expect(@viewer_html).not_to include('user is not admin') }
    specify { expect(@viewer_html).to include('4-Apr-1979 06:15') }
    specify { expect(@viewer_html).to include('class="forma-date-field text-muted"') }
    specify { expect(@viewer_html).to include('dimakura@gmail.com') }
    specify { expect(@viewer_html).to include('555666777') }
  end

end
