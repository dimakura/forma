# -*- encoding : utf-8 -*-
require 'test_helper'

class UtilsTest < Test::Unit::TestCase
  include Forma::Utils

  def test_number_format
    assert_equal '123,456', number_format(123_456)
    assert_equal '123,456.00', number_format(123_456, min_digits: 2)
    assert_equal '123,456.79', number_format(123_456.789)
    assert_equal '123,456.789', number_format(123_456.789, max_digits: 3)
    assert_equal '123,456.789', number_format(123_456.789, max_digits: 4)
    assert_equal '123,456.7890', number_format(123_456.789, max_digits: 4, min_digits: 4)
  end
end