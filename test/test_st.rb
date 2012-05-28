$VERBOSE = true
require_relative 'test_helper'

class TestST < Test::Unit::TestCase

  def test_assertions_succeed
    it = 'Sample String'
    
    assert_same true, it.IS?('Sample String')
    assert_same true, it.MATCH?(/\S+ \S+/)
    assert_same true, it.KIND?(Object)
    assert_same true, it.A?(String)
    assert_same true, it.EQL?('Sample String')
    assert_same true, it.EQUAL?(it)
    assert_same true, it.FAMILY?('ANY')
    assert_same true, it.RESPOND?(:to_str)
    assert_same true, it.NOT?(:'Sample String')
  end

  def test_assertions_failed
    it = 'Sample String'
    
    assert_same false, it.IS?('Sample String~')
    assert_same false, it.MATCH?(/\d+ \d+/)
    assert_same false, it.KIND?(Symbol)
    assert_same false, it.A?(Object)
    assert_same false, it.EQL?('sample string')
    assert_same false, it.EQUAL?(it.dup)
    assert_same false, it.FAMILY?(:ANY)
    assert_same false, it.RESPOND?(:to_ary)
    assert_same false, it.NOT?('Sample String')
  end

end
