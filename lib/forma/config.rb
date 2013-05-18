# -*- encoding : utf-8 -*-
require 'singleton'

module Forma

  class << self
    def config
      Forma::Config.instance
    end
  end

  private

  class Config
    include Singleton

    def num
      @num ||= NumberConfig.new
    end

    def date
      @date ||= DateConfig.new
    end

    def texts
      @texts ||= TextsConfig.new
    end

    def map
      @map ||= MapConfig.new
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

  class TextsConfig
    attr_accessor :empty, :table_empty
    def initialize
      self.empty = '(empty)'
      self.table_empty = '(no data)'
    end
  end  

  class MapConfig
    attr_accessor :default_latitude
    attr_accessor :default_longitude
    attr_accessor :zoom_level
    def initialize
      self.default_latitude = 41.711447
      self.default_longitude = 44.754514
      self.zoom_level = 17
    end
  end
end
