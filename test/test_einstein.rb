require File.dirname(__FILE__) + '/helper'

class TestEinstein < Test::Unit::TestCase
  def test_evaluate
    assert_equal(1, Einstein.evaluate('1'))
    assert_equal(35, Einstein.evaluate('(5 + 2) * (10 - 5)'))
  end

  def test_parse
    exp = Einstein.parse('1')
    assert_equal [:lit, 1], exp.to_sexp
    assert_equal 1, exp.evaluate
    assert_equal '1', exp.to_s

    exp = Einstein.parse('2 + 5')
    assert_equal [:add, [:lit, 2], [:lit, 5]], exp.to_sexp
    assert_equal 7, exp.evaluate
    assert_equal '(2 + 5)', exp.to_s
  end
end
