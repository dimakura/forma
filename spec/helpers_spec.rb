# -*- encoding : utf-8 -*-
require 'spec_helper'
include Forma::Helpers

describe "forma helper" do
  before(:all) do
    @user_password = { username: 'dimitri', password: 'secret', age: 33, email: 'dimakura@gmail.com' }
    @forma = forma_for(@user_password) do |f|
      f.text_field :username
      f.password_field :password
      f.number_field :age
      f.email_field :email
    end
    # puts Nokogiri::XML(@forma, &:noblanks).to_xhtml(indent: 2)
  end
  specify { @forma.should_not be_nil }
  specify { @forma.should be_a String }
end
