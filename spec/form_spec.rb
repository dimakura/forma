# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'nokogiri'

include Forma

describe 'simple form' do
  before(:all) do
    @form = Form.new(
      id: 'user-login',
      title: 'User Login',
      collapsible: true,
      collapsed: false,
      icon: '/assets/user.png',
      edit: true,
      url: '/login',
      method: 'post',
      selected_tab: 0,
      tabs: [
        Tab.new(title: 'Login', icon: '/assets/user.png', col1: Col.new([
          TextField.new(name: 'username', label: 'Username', required: true),
          TextField.new(name: 'password', label: 'Password', required: true)
        ])),
        Tab.new(title: 'Reset password', icon: '/assets/password.png'),
      ]
    )
    @element = @form.to_html
    puts Nokogiri::XML(@element.to_s, &:noblanks).to_xhtml(indent: 2)
  end
  specify { @element.tag.should == 'div' }
  specify { @element.id.should == 'user-login' }
  specify { @element.klass.should == ['ff-form', 'ff-theme-blue'] }
end
