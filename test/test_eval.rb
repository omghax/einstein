require File.dirname(__FILE__) + "/test_helper"
require "logger"

class TestEval < Test::Unit::TestCase
  def setup
    @parser = Einstein::Parser.new
    @parser.logger = Logger.new(STDERR)
  end

  def test_resolve_should_raise_on_undefined_variable
    assert_raises(Einstein::ResolveError) { @parser.parse("x").eval({}) }
  end

  def test_resolve
    assert_eval(5, "x", :x => 5)
    assert_eval(10, "x + 5", :x => 5)
    assert_eval(16, "x * 4", :x => 4)
  end

  def test_bitwise_or
    assert_eval(0b1111, "0b1100 | 0b1111")
  end

  def test_bitwise_xor
    assert_eval(0b0011, "0b1100 ^ 0b1111")
  end

  def test_bitwise_and
    assert_eval(0b1100, "0b1100 & 0b1111")
  end

  def test_subtraction
    assert_eval(5, "10 - 5")
    assert_eval(-5, "5 - 10")
  end

  def test_addition
    assert_eval(3, "1 + 2")
    assert_eval(3.0, "1.0 + 2.0")
  end

  def test_modulus
    assert_eval(5, "5 % 10")
    assert_eval(0, "10 % 5")
  end

  def test_division_should_raise_on_divide_by_zero
    assert_raises(Einstein::ZeroDivisionError) { @parser.parse("1 / 0").eval }
  end

  def test_division
    assert_eval(2, "10 / 5")
    assert_eval(2.0, "10.0 / 5.0")
  end

  def test_multiplication
    assert_eval(50, "5 * 10")
    assert_eval(50.0, "5.0 * 10.0")
  end

  def test_float
    assert_eval(1.1, "1.1")
  end

  def test_number_base2
    # Unsigned
    assert_eval(0b0, "0b0")
    assert_eval(0b1111, "0b1111")
    assert_eval(0B1010, "0B1010")

    # Positive
    assert_eval(0b1111, "+0b1111")
    assert_eval(0B1010, "+0B1010")

    # Negative
    assert_eval(-0b1111, "-0b1111")
    assert_eval(-0B1010, "-0B1010")
  end

  def test_number_base8
    # Unsigned
    assert_eval(0x0, "0x0")
    assert_eval(0xff, "0xff")
    assert_eval(0XFF, "0XFF")

    # Positive
    assert_eval(0xff, "+0xff")
    assert_eval(0XFF, "+0XFF")

    # Negative
    assert_eval(-0xff, "-0xff")
    assert_eval(-0XFF, "-0XFF")
  end

  def test_number_base10
    # Unsigned
    assert_eval(0, "0")
    assert_eval(1, "01")
    assert_eval(10, "10")

    # Positive
    assert_eval(1, "+1")
    assert_eval(10, "+10")

    # Negative
    assert_eval(-1, "-1")
    assert_eval(-10, "-10")
  end

  private

  def assert_eval(expected, str, env = {})
    assert_equal expected, @parser.parse(str).eval(env)
  end
end
