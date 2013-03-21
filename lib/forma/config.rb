# -*- encoding : utf-8 -*-
require 'singleton'

module Forma

  class Config
    include Singleton

    def num
      @num ||= Forma::NumberConfig.new
    end

    def date
      @date ||= Forma::DateConfig.new
    end

  end

  class NumberConfig
    attr_accessor :delimiter
    attr_accessor :separator

    def initialize
      self.delimiter = ','
      self.separator = '.'
    end
  end

  class DateConfig
    attr_accessor :formatter

    def initialize
      self.formatter = '%d-%b-%Y'
    end
  end

  class << self
    def config
      Forma::Config.instance
    end
  end

end
