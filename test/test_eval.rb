require File.dirname(__FILE__) + "/test_helper"
require "logger"

class TestEval < Test::Unit::TestCase
  def setup
    @parser = Einstein::Parser.new
    @parser.logger = Logger.new(STDERR)
  end

  def test_parentheses
    assert_equal (5 + 2) * (10 - 5), parse("(5 + 2) * (10 - 5)").eval
  end

  def test_order_of_operations
    assert_equal 3 + 4 * 2, parse("3 + 4 * 2").eval
    assert_equal 7 + 9 * 2 - 16 / 8, parse("7 + 9 * 2 - 16 / 8").eval
  end

  def test_resolve_should_raise_on_undefined_variable
    assert_raises(Einstein::ResolveError) { parse("x").eval }
  end

  def test_resolve
    assert_equal 5, parse("x").eval(:x => 5)
    assert_equal 5 + 5, parse("x + 5").eval(:x => 5)
    assert_equal 4 * 4, parse("x * 4").eval(:x => 4)
  end

  def test_bitwise_or
    assert_equal 0b1100 | 0b1111, parse("0b1100 | 0b1111").eval
  end

  def test_bitwise_xor
    assert_equal 0b1100 ^ 0b1111, parse("0b1100 ^ 0b1111").eval
  end

  def test_bitwise_and
    assert_equal 0b1100 & 0b1111, parse("0b1100 & 0b1111").eval
  end

  def test_subtraction
    assert_equal 10 - 5, parse("10 - 5").eval
    assert_equal 5 - 10, parse("5 - 10").eval
  end

  def test_addition
    assert_equal 1 + 2, parse("1 + 2").eval
    assert_equal 1.0 + 2.0, parse("1.0 + 2.0").eval
  end

  def test_modulus
    assert_equal 5 % 10, parse("5 % 10").eval
    assert_equal 10 % 5, parse("10 % 5").eval
  end

  def test_division_should_raise_on_divide_by_zero
    assert_raises(Einstein::ZeroDivisionError) { parse("1 / 0").eval }
  end

  def test_division
    assert_equal 10 / 5, parse("10 / 5").eval
    assert_equal 10.0 / 5.0, parse("10.0 / 5.0").eval
  end

  def test_multiplication
    assert_equal 5 * 10, parse("5 * 10").eval
    assert_equal 5.0 * 10.0, parse("5.0 * 10.0").eval
  end

  def test_float
    assert_equal 1.1, parse("1.1").eval
  end

  def test_number_base2
    # Unsigned
    assert_equal 0b0, parse("0b0").eval
    assert_equal 0b1111, parse("0b1111").eval
    assert_equal 0B1010, parse("0B1010").eval

    # Positive
    assert_equal +0b1111, parse("+0b1111").eval
    assert_equal +0B1010, parse("+0B1010").eval

    # Negative
    assert_equal -0b1111, parse("-0b1111").eval
    assert_equal -0B1010, parse("-0B1010").eval
  end

  def test_number_base8
    # Unsigned
    assert_equal 0x0, parse("0x0").eval
    assert_equal 0xff, parse("0xff").eval
    assert_equal 0XFF, parse("0XFF").eval

    # Positive
    assert_equal +0xff, parse("+0xff").eval
    assert_equal +0XFF, parse("+0XFF").eval

    # Negative
    assert_equal -0xff, parse("-0xff").eval
    assert_equal -0XFF, parse("-0XFF").eval
  end

  def test_number_base10
    # Unsigned
    assert_equal 0, parse("0").eval
    assert_equal 1, parse("01").eval
    assert_equal 10, parse("10").eval

    # Positive
    assert_equal +1, parse("+1").eval
    assert_equal +10, parse("+10").eval

    # Negative
    assert_equal -1, parse("-1").eval
    assert_equal -10, parse("-10").eval
  end

  private

  def parse(stmt)
    @parser.parse(stmt)
  end
end
