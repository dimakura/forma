# -*- encoding : utf-8 -*-
require 'spec_helper'

class FieldSet < Forma::WithFields; end

RSpec.describe Forma::WithFields do

  before(:all) do
    form = FieldSet.new
    @firstNameField = form.text_field 'first_name'
    @lastNameField = form.required_text_field 'last_name'
    @emailField = form.readonly_email_field 'email'
    @usernameField = form.readonly_required_text_field 'username'
  end

  specify{ expect(@firstNameField.name).to eq('first_name') }
  specify{ expect(@firstNameField.type).to eq('text') }

  specify{ expect(@lastNameField.name).to eq('last_name') }
  specify{ expect(@lastNameField.type).to eq('text') }
  specify{ expect(@lastNameField.required).to eq(true) }

  specify{ expect(@emailField.type).to eq('email') }
  specify{ expect(@emailField.readonly).to eq(true) }

  specify{ expect(@usernameField.type).to eq('text') }
  specify{ expect(@usernameField.readonly).to eq(true) }
  specify{ expect(@usernameField.required).to eq(true) }
end
