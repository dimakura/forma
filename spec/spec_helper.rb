# -*- encoding : utf-8 -*-
require 'rspec'
require 'forma'
require 'forma/auto_initialize'
require 'forma/generators/html'
require 'forma/generators/field_generator'
require 'forma/helpers'

I18n.enforce_available_locales = false

class User < Forma::AutoInitialize; end
class Profile < Forma::AutoInitialize; end
