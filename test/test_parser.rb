require File.dirname(__FILE__) + "/helper"
require "logger"

class TestParser < Test::Unit::TestCase
  def setup
    @parser = Einstein::Parser.new
    @parser.logger = Logger.new(STDERR)
  end

  def test_parentheses
    assert_equal \
      [:multiply, 
        [:add, [:lit, 5], [:lit, 2]],
        [:subtract, [:lit, 10], [:lit, 5]]
      ],
      parse("(5 + 2) * (10 - 5)")
  end

  def test_order_of_operations
    assert_equal \
      [:subtract,
        [:add,
          [:divide, [:lit, 6], [:lit, 3]],
          [:multiply, [:lit, 4], [:lit, 2]]],
        [:lit, 5]
      ],
      parse("6 / 3 + 4 * 2 - 5")
  end

  def test_resolve
    assert_equal [:resolve, "x"], parse("x")
  end

  def test_bitwise_or
    assert_equal [:bitwise_or, [:lit, 5], [:lit, 10]], parse("5 | 10")
  end

  def test_bitwise_xor
    assert_equal [:bitwise_xor, [:lit, 5], [:lit, 10]], parse("5 ^ 10")
  end

  def test_bitwise_and
    assert_equal [:bitwise_and, [:lit, 5], [:lit, 10]], parse("5 & 10")
  end

  def test_rshift
    assert_equal [:rshift, [:lit, 2], [:lit, 3]], parse("2 >> 3")
  end

  def test_lshift
    assert_equal [:lshift, [:lit, 2], [:lit, 3]], parse("2 << 3")
  end

  def test_subtraction
    assert_equal [:subtract, [:lit, 2], [:lit, 1]], parse("2 - 1")
  end

  def test_addition
    assert_equal [:add, [:lit, 1], [:lit, 2]], parse("1 + 2")
  end

  def test_modulus
    assert_equal [:modulus, [:lit, 10], [:lit, 5]], parse("10 % 5")
  end

  def test_division
    assert_equal [:divide, [:lit, 10], [:lit, 5]], parse("10 / 5")
  end

  def test_multiplication
    assert_equal [:multiply, [:lit, 5], [:lit, 10]], parse("5 * 10")
  end

  def test_exponent
    assert_equal [:raise, [:lit, 5], [:lit, 2]], parse("5 ** 2")
    assert_equal [:raise, [:lit, 3], [:u_minus, [:lit, 6]]], parse("3 ** -6")
    assert_equal [:raise, [:lit, 18], [:bitwise_not, [:lit, 4]]], parse("18 ** ~4")
  end

  def test_unary_bitwise_not
    assert_equal [:bitwise_not, [:lit, 10]], parse("~10")
  end

  def test_unary_minus
    assert_equal [:u_minus, [:lit, 10]], parse("-10")
  end

  def test_unary_plus
    assert_equal [:u_plus, [:lit, 10]], parse("+10")
  end

  def test_float_scientific
    assert_equal [:lit, 10.10e-3], parse("10.10e-3")
  end

  def test_float
    assert_equal [:lit, 10.10], parse("10.10")
  end

  def test_number_base2
    assert_equal [:lit, 0b1010], parse("0b1010")
  end

  def test_number_base8
    assert_equal [:lit, 011], parse("011")
  end

  def test_number_base16
    assert_equal [:lit, 0xdeadbeef], parse("0xdeadbeef")
    assert_equal [:lit, 0xCAFEBABE], parse("0xCAFEBABE")
  end

  def test_number_base10
    assert_equal [:lit, 0], parse("0")
    assert_equal [:lit, 1], parse("01")
    assert_equal [:lit, 10], parse("10")
  end

  private

  def parse(stmt)
    @parser.parse(stmt).to_sexp
  end
end
