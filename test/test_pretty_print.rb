require File.dirname(__FILE__) + "/test_helper"
require "logger"

class TestPrettyPrint < Test::Unit::TestCase
  def setup
    @parser = Einstein::Parser.new
    @parser.logger = Logger.new(STDERR)
  end

  def test_parentheses
    assert_equal "((5 + 2) * (10 - 5))", parse("(5 + 2) * (10 - 5)").inspect
  end

  def test_order_of_operations
    assert_equal "(3 + (4 * 2))", parse("3 + 4 * 2").inspect
    assert_equal "((7 + (9 * 2)) - (16 / 8))", parse("7 + 9 * 2 - 16 / 8").inspect
  end

  def test_resolve
    assert_equal "x", parse("x").inspect
    assert_equal "(x + 5)", parse("x + 5").inspect
    assert_equal "(x * 4)", parse("x * 4").inspect
  end

  def test_bitwise_or
    assert_equal "(12 | 15)", parse("0b1100 | 0b1111").inspect
  end

  def test_bitwise_xor
    assert_equal "(12 ^ 15)", parse("0b1100 ^ 0b1111").inspect
  end

  def test_bitwise_and
    assert_equal "(12 & 15)", parse("0b1100 & 0b1111").inspect
  end

  def test_rshift
    assert_equal("(10 >> 2)", parse("10 >> 2").inspect)
  end

  def test_lshift
    assert_equal("(10 << 2)", parse("10 << 2").inspect)
  end

  def test_subtraction
    assert_equal "(10 - 5)", parse("10 - 5").inspect
    assert_equal "(5 - 10)", parse("5 - 10").inspect
  end

  def test_addition
    assert_equal "(1 + 2)", parse("1 + 2").inspect
    assert_equal "(1.0 + 2.0)", parse("1.0 + 2.0").inspect
  end

  def test_modulus
    assert_equal "(5 % 10)", parse("5 % 10").inspect
    assert_equal "(10 % 5)", parse("10 % 5").inspect
  end

  def test_division
    assert_equal "(10 / 5)", parse("10 / 5").inspect
    assert_equal "(10.0 / 5.0)", parse("10.0 / 5.0").inspect
  end

  def test_multiplication
    assert_equal "(5 * 10)", parse("5 * 10").inspect
    assert_equal "(5.0 * 10.0)", parse("5.0 * 10.0").inspect
  end

  def test_exponent
    assert_equal "(5 ** 2)", parse("5 ** 2").inspect
  end

  def test_float
    assert_equal "1.1", parse("1.1").inspect
  end

  def test_number_base2
    assert_equal "0", parse("0b0").inspect
    assert_equal "15", parse("0b1111").inspect
    assert_equal "10", parse("0B1010").inspect

    assert_equal "+15", parse("+0b1111").inspect
    assert_equal "+10", parse("+0B1010").inspect

    assert_equal "-15", parse("-0b1111").inspect
    assert_equal "-10", parse("-0B1010").inspect
  end

  def test_number_base16
    assert_equal "0", parse("0x0").inspect
    assert_equal "255", parse("0xff").inspect
    assert_equal "255", parse("0XFF").inspect

    assert_equal "+255", parse("+0xff").inspect
    assert_equal "+255", parse("+0XFF").inspect

    assert_equal "-255", parse("-0xff").inspect
    assert_equal "-255", parse("-0XFF").inspect
  end

  def test_number_base10
    assert_equal "0", parse("0").inspect
    assert_equal "1", parse("01").inspect
    assert_equal "10", parse("10").inspect

    assert_equal "+1", parse("+1").inspect
    assert_equal "+10", parse("+10").inspect

    assert_equal "-1", parse("-1").inspect
    assert_equal "-10", parse("-10").inspect
  end

  private

  def parse(stmt)
    @parser.parse(stmt)
  end
end
