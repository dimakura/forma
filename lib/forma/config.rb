# -*- encoding : utf-8 -*-
require 'singleton'

module Forma

  class Config
    include Singleton

    def num
      @num ||= Forma::NumberConfig.new(delimiter: ',', separator: '.')
    end

    def date
      @date ||= Forma::DateConfig.new(formatter: '%d-%b-%Y')
    end

  end

  class NumberConfig
    include Forma::Init
    attr_accessor :delimiter
    attr_accessor :separator
  end

  class DateConfig
    include Forma::Init
    attr_accessor :formatter
  end

  class << self
    def config
      Forma::Config.instance
    end
  end

end
