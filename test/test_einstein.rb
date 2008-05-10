require File.dirname(__FILE__) + "/helper"

class TestEinstein < Test::Unit::TestCase
  def test_evaluate
    assert_equal(1, Einstein.evaluate("1"))
    assert_equal(35, Einstein.evaluate("(5 + 2) * (10 - 5)"))
  end
end
