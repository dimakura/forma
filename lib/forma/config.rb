# -*- encoding : utf-8 -*-
require 'singleton'

module Forma

  class Config
    include Singleton

    def num
      @num ||= NumberConfig.new(delimiter: ',', separator: '.')
    end

    def date
      @date ||= DateConfig.new(formatter: '%d-%b-%Y')
    end

    def texts
      @texts ||= TextsConfig.new(empty: '(empty)')
    end

  end

  class << self
    def config
      Forma::Config.instance
    end
  end

  private

  class NumberConfig
    include Forma::Init
    attr_accessor :delimiter
    attr_accessor :separator
  end

  class DateConfig
    include Forma::Init
    attr_accessor :formatter
  end

  class TextsConfig
    include Forma::Init
    attr_accessor :empty
  end  

end
