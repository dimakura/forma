# -*- encoding : utf-8 -*-
require 'spec_helper'
include Forma::Helpers

describe "forma helper" do
  before(:all) do
    @user_password = { username: 'dimitri', password: 'secret' }
    @forma = forma_for(@user_password) do |f|
      f.text_field :username
      f.password_field :password
    end
    #puts Nokogiri::XML(@forma, &:noblanks).to_xhtml(indent: 2)
  end
  specify { @forma.should_not be_nil }
end
