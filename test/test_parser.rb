require File.dirname(__FILE__) + "/test_helper"
require "logger"

class TestParser < Test::Unit::TestCase
  def setup
    @parser = Einstein::Parser.new
    @parser.logger = Logger.new(STDERR)
  end

  def test_resolve
    assert_equal [[:resolve, "x"]], parse("x").to_sexp
  end

  def test_bitwise_or
    assert_equal [[:bitwise_or, [:lit, 5], [:lit, 10]]], parse("5 | 10").to_sexp
  end

  def test_bitwise_xor
    assert_equal [[:bitwise_xor, [:lit, 5], [:lit, 10]]], parse("5 ^ 10").to_sexp
  end

  def test_bitwise_and
    assert_equal [[:bitwise_and, [:lit, 5], [:lit, 10]]], parse("5 & 10").to_sexp
  end

  def test_rshift
    assert_equal [[:rshift, [:lit, 2], [:lit, 3]]], parse("2>>3").to_sexp
    assert_equal [[:rshift, [:lit, 2], [:lit, 3]]], parse("2 >> 3").to_sexp
  end

  def test_lshift
    assert_equal [[:lshift, [:lit, 2], [:lit, 3]]], parse("2<<3").to_sexp
    assert_equal [[:lshift, [:lit, 2], [:lit, 3]]], parse("2 << 3").to_sexp
  end

  def test_subtraction
    assert_equal [[:subtract, [:lit, 2], [:lit, 1]]], parse("2-1").to_sexp
    assert_equal [[:subtract, [:lit, 2], [:lit, 1]]], parse("2 - 1").to_sexp
  end

  def test_addition
    assert_equal [[:add, [:lit, 1], [:lit, 2]]], parse("1+2").to_sexp
    assert_equal [[:add, [:lit, 1], [:lit, 2]]], parse("1 + 2").to_sexp
  end

  def test_modulus
    assert_equal [[:modulus, [:lit, 10], [:lit, 5]]], parse("10%5").to_sexp
    assert_equal [[:modulus, [:lit, 10], [:lit, 5]]], parse("10 % 5").to_sexp
  end

  def test_division
    assert_equal [[:divide, [:lit, 10], [:lit, 5]]], parse("10/5").to_sexp
    assert_equal [[:divide, [:lit, 10], [:lit, 5]]], parse("10 / 5").to_sexp
  end

  def test_multiplication
    assert_equal [[:multiply, [:lit, 5], [:lit, 10]]], parse("5*10").to_sexp
    assert_equal [[:multiply, [:lit, 5], [:lit, 10]]], parse("5 * 10").to_sexp
  end

  def test_unary_bitwise_not
    assert_equal [[:bitwise_not, [:lit, 10]]], parse("~10").to_sexp
  end

  def test_unary_minus
    assert_equal [[:u_minus, [:lit, 10]]], parse("-10").to_sexp
  end

  def test_unary_plus
    assert_equal [[:u_plus, [:lit, 10]]], parse("+10").to_sexp
  end

  def test_float_scientific
    # Unsigned exponent, lowercase e
    assert_equal [[:lit, 1.0e1]], parse("1.0e1").to_sexp
    assert_equal [[:lit, 1.1e2]], parse("1.1e2").to_sexp
    assert_equal [[:lit, 10.10e3]], parse("10.10e3").to_sexp
    # Unsigned exponent, uppercase e
    assert_equal [[:lit, 1.0E1]], parse("1.0E1").to_sexp
    assert_equal [[:lit, 1.1E2]], parse("1.1E2").to_sexp
    assert_equal [[:lit, 10.10E3]], parse("10.10E3").to_sexp

    # Positive exponent, lowercase e
    assert_equal [[:lit, 1.0e+1]], parse("1.0e+1").to_sexp
    assert_equal [[:lit, 1.1e+2]], parse("1.1e+2").to_sexp
    assert_equal [[:lit, 10.10e+3]], parse("10.10e+3").to_sexp
    # Positive exponent, uppercase e
    assert_equal [[:lit, 1.0E+1]], parse("1.0E+1").to_sexp
    assert_equal [[:lit, 1.1E+2]], parse("1.1E+2").to_sexp
    assert_equal [[:lit, 10.10E+3]], parse("10.10E+3").to_sexp

    # Negative exponent, lowercase e
    assert_equal [[:lit, 1.0e-1]], parse("1.0e-1").to_sexp
    assert_equal [[:lit, 1.1e-2]], parse("1.1e-2").to_sexp
    assert_equal [[:lit, 10.10e-3]], parse("10.10e-3").to_sexp
    # Negative exponent, uppercase e
    assert_equal [[:lit, 1.0E-1]], parse("1.0E-1").to_sexp
    assert_equal [[:lit, 1.1E-2]], parse("1.1E-2").to_sexp
    assert_equal [[:lit, 10.10E-3]], parse("10.10E-3").to_sexp
  end

  def test_float
    # Unsigned
    assert_equal [[:lit, 0.0]], parse("0.0").to_sexp
    assert_equal [[:lit, 1.1]], parse("1.1").to_sexp
    assert_equal [[:lit, 10.10]], parse("10.10").to_sexp

    # Positive
    assert_equal [[:u_plus, [:lit, 1.1]]], parse("+1.1").to_sexp
    assert_equal [[:u_plus, [:lit, 10.10]]], parse("+10.10").to_sexp

    # Negative
    assert_equal [[:u_minus, [:lit, 1.1]]], parse("-1.1").to_sexp
    assert_equal [[:u_minus, [:lit, 10.10]]], parse("-10.10").to_sexp
  end

  def test_number_base2
    # Unsigned, lowercase b
    assert_equal [[:lit, 0b0000]], parse("0b0").to_sexp
    assert_equal [[:lit, 0b1111]], parse("0b1111").to_sexp
    assert_equal [[:lit, 0b1010]], parse("0b1010").to_sexp
    # Unsigned, uppercase b
    assert_equal [[:lit, 0B0000]], parse("0B0").to_sexp
    assert_equal [[:lit, 0B1111]], parse("0B1111").to_sexp
    assert_equal [[:lit, 0B1010]], parse("0B1010").to_sexp

    # Positive, lowercase b
    assert_equal [[:u_plus, [:lit, 0b1111]]], parse("+0b1111").to_sexp
    assert_equal [[:u_plus, [:lit, 0b1010]]], parse("+0b1010").to_sexp
    # Positive, uppercase b
    assert_equal [[:u_plus, [:lit, 0B1111]]], parse("+0B1111").to_sexp
    assert_equal [[:u_plus, [:lit, 0B1010]]], parse("+0B1010").to_sexp

    # Negative, lowercase b
    assert_equal [[:u_minus, [:lit, 0b1111]]], parse("-0b1111").to_sexp
    assert_equal [[:u_minus, [:lit, 0b1010]]], parse("-0b1010").to_sexp
    # Negative, uppercase b
    assert_equal [[:u_minus, [:lit, 0B1111]]], parse("-0B1111").to_sexp
    assert_equal [[:u_minus, [:lit, 0B1010]]], parse("-0B1010").to_sexp
  end

  def test_number_base16
    # Unsigned, lowercase x
    assert_equal [[:lit, 0x0]], parse("0x0").to_sexp
    assert_equal [[:lit, 0xaa]], parse("0xaa").to_sexp
    assert_equal [[:lit, 0xFF]], parse("0xFF").to_sexp
    # Unsigned, uppercase x
    assert_equal [[:lit, 0x0]], parse("0X0").to_sexp
    assert_equal [[:lit, 0xaa]], parse("0Xaa").to_sexp
    assert_equal [[:lit, 0xFF]], parse("0XFF").to_sexp

    # Positive, lowercase x
    assert_equal [[:u_plus, [:lit, 0xaa]]], parse("+0xaa").to_sexp
    assert_equal [[:u_plus, [:lit, 0xFF]]], parse("+0xFF").to_sexp
    # Positive, uppercase x
    assert_equal [[:u_plus, [:lit, 0xaa]]], parse("+0Xaa").to_sexp
    assert_equal [[:u_plus, [:lit, 0xFF]]], parse("+0XFF").to_sexp

    # Negative, lowercase x
    assert_equal [[:u_minus, [:lit, 0xaa]]], parse("-0xaa").to_sexp
    assert_equal [[:u_minus, [:lit, 0xFF]]], parse("-0xFF").to_sexp
    # Negative, uppercase x
    assert_equal [[:u_minus, [:lit, 0xaa]]], parse("-0Xaa").to_sexp
    assert_equal [[:u_minus, [:lit, 0xFF]]], parse("-0XFF").to_sexp
  end

  def test_number_base10
    # Unsigned
    assert_equal [[:lit, 0]], parse("0").to_sexp
    assert_equal [[:lit, 1]], parse("01").to_sexp
    assert_equal [[:lit, 10]], parse("10").to_sexp

    # Positive
    assert_equal [[:u_plus, [:lit, 1]]], parse("+1").to_sexp
    assert_equal [[:u_plus, [:lit, 10]]], parse("+10").to_sexp

    # Negative
    assert_equal [[:u_minus, [:lit, 1]]], parse("-1").to_sexp
    assert_equal [[:u_minus, [:lit, 10]]], parse("-10").to_sexp
  end

  private

  def parse(stmt)
    @parser.parse(stmt)
  end
end
