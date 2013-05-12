# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'module' do
  before(:all) do
    @module = Forma::Module.new('site', controller: 'site', action: 'index')
    @action = Forma::ModuleAction.new('register', @module, action: 'register', path: 'user/register')
    @action_2 = Forma::ModuleAction.new('terms', @action, action: 'terms', path: 'terms')
  end
  context do
    subject { @module }
    its(:name) { should == 'site' }
    its(:label) { should == 'site' }
    its(:i18n_key) { should == 'modules.site.name' }
    its(:parent) { should be_nil }
    its(:controller) { should == 'site' }
    its(:action) { should == 'index' }
    its(:path) { should == 'site' }
  end
  context do
    subject { @action }
    its(:name) { should == 'site_register' }
    its(:parent) { should == @module }
    its(:module) { should == @module }
    its(:i18n_key) { should == 'modules.site.actions.register' }
    its(:label) { should == 'register' }
    its(:controller) { should == 'site' }
    its(:action) { should == 'register' }
    its(:path) { should == 'site/user/register' }
  end
  context do
    subject { @action_2 }
    its(:name) { should == 'site_register_terms' }
    its(:parent) { should == @action }
    its(:module) { should == @module }
    its(:i18n_key) { should == 'modules.site.actions.register_terms' }
    its(:label) { should == 'terms' }
    its(:controller) { should == 'site' }
    its(:action) { should == 'terms' }
    its(:path) { should == 'site/terms' }
  end
end
