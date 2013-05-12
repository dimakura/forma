# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'module and actions' do
  before(:all) do
    @module = Forma::Module.new('site', controller: 'site', action: 'index')
    @action = Forma::ModuleAction.new(@module, 'register', action: 'register', url: 'user/register')
    @action_2 = Forma::ModuleAction.new(@action, 'terms', action: 'terms', url: 'terms')
  end
  context do
    subject { @module }
    its(:name) { should == 'site' }
    its(:label) { should == 'site' }
    its(:namespace) { should == 'site' }
    its(:i18n_key) { should == 'modules.site.name' }
    its(:parent) { should be_nil }
    its(:controller) { should == 'site' }
    its(:action) { should == 'index' }
    its(:path) { should == '/site' }
    specify { subject.children.size.should == 1 }
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
    its(:path) { should == '/site/user/register' }
    specify { subject.children.size.should == 1 }
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
    its(:path) { should == '/site/terms' }
    specify { subject.children.size.should == 0 }
  end
end

describe 'scope' do
  before(:all) do
    @module = Forma::Module.new('admin')
    @scope = Forma::Scope.new(@module, 'users', controller: 'users')
    @action = Forma::ModuleAction.new(@scope, 'home', url: 'show/:id', action: 'show')
  end
  context do
    subject { @action }
    its(:name) { should == 'admin_home' }
    its(:path) { should == '/admin/users/show/:id' }
    its(:action) { should == 'show' }
  end
end

describe 'module generation' do
  before(:all) do
    Forma.modules do |gen|
      gen.module 'site'
      gen.module 'support'
      gen.module 'admin'
    end
  end
  specify { Forma::ModuleGenerator.modules.size.should == 3 }
  specify { Forma::ModuleGenerator.modules[0].name.should == 'site' }
  specify { Forma::ModuleGenerator.modules[1].name.should == 'support' }
  specify { Forma::ModuleGenerator.modules[2].name.should == 'admin' }
end
