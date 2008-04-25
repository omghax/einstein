require File.dirname(__FILE__) + "/test_helper"
require "logger"

class TestEvaluate < Test::Unit::TestCase
  def setup
    @parser = Einstein::Parser.new
    @parser.logger = Logger.new(STDERR)
  end

  def test_parentheses
    assert_equal (5 + 2) * (10 - 5), parse("(5 + 2) * (10 - 5)").evaluate
  end

  def test_order_of_operations
    assert_equal 3 + 4 * 2, parse("3 + 4 * 2").evaluate
    assert_equal 7 + 9 * 2 - 16 / 8, parse("7 + 9 * 2 - 16 / 8").evaluate
  end

  def test_resolve_should_raise_on_undefined_variable
    assert_raises(Einstein::ResolveError) { parse("x").evaluate }
  end

  def test_resolve
    assert_equal 5, parse("x").evaluate(:x => 5)
    assert_equal 5 + 5, parse("x + 5").evaluate(:x => 5)
    assert_equal 4 * 4, parse("x * 4").evaluate(:x => 4)
  end

  def test_bitwise_or
    assert_equal 0b1100 | 0b1111, parse("0b1100 | 0b1111").evaluate
  end

  def test_bitwise_xor
    assert_equal 0b1100 ^ 0b1111, parse("0b1100 ^ 0b1111").evaluate
  end

  def test_bitwise_and
    assert_equal 0b1100 & 0b1111, parse("0b1100 & 0b1111").evaluate
  end

  def test_subtraction
    assert_equal 10 - 5, parse("10 - 5").evaluate
    assert_equal 5 - 10, parse("5 - 10").evaluate
  end

  def test_addition
    assert_equal 1 + 2, parse("1 + 2").evaluate
    assert_equal 1.0 + 2.0, parse("1.0 + 2.0").evaluate
  end

  def test_modulus
    assert_equal 5 % 10, parse("5 % 10").evaluate
    assert_equal 10 % 5, parse("10 % 5").evaluate
  end

  def test_division_should_raise_on_divide_by_zero
    assert_raises(Einstein::ZeroDivisionError) { parse("1 / 0").evaluate }
  end

  def test_division
    assert_equal 10 / 5, parse("10 / 5").evaluate
    assert_equal 10.0 / 5.0, parse("10.0 / 5.0").evaluate
  end

  def test_multiplication
    assert_equal 5 * 10, parse("5 * 10").evaluate
    assert_equal 5.0 * 10.0, parse("5.0 * 10.0").evaluate
  end

  def test_exponent
    assert_equal 5 ** 2, parse("5 ** 2").evaluate
  end

  def test_float
    assert_equal 1.1, parse("1.1").evaluate
  end

  def test_number_base2
    assert_equal 0b0, parse("0b0").evaluate
    assert_equal 0b1111, parse("0b1111").evaluate
    assert_equal 0B1010, parse("0B1010").evaluate

    assert_equal +0b1111, parse("+0b1111").evaluate
    assert_equal +0B1010, parse("+0B1010").evaluate

    assert_equal -0b1111, parse("-0b1111").evaluate
    assert_equal -0B1010, parse("-0B1010").evaluate
  end

  def test_number_base16
    assert_equal 0x0, parse("0x0").evaluate
    assert_equal 0xff, parse("0xff").evaluate
    assert_equal 0XFF, parse("0XFF").evaluate

    assert_equal +0xff, parse("+0xff").evaluate
    assert_equal +0XFF, parse("+0XFF").evaluate

    assert_equal -0xff, parse("-0xff").evaluate
    assert_equal -0XFF, parse("-0XFF").evaluate
  end

  def test_number_base10
    assert_equal 0, parse("0").evaluate
    assert_equal 1, parse("01").evaluate
    assert_equal 10, parse("10").evaluate

    assert_equal +1, parse("+1").evaluate
    assert_equal +10, parse("+10").evaluate

    assert_equal -1, parse("-1").evaluate
    assert_equal -10, parse("-10").evaluate
  end

  private

  def parse(stmt)
    @parser.parse(stmt)
  end
end
