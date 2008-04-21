require File.dirname(__FILE__) + "/test_helper"
require "logger"

class TestParser < Test::Unit::TestCase
  def setup
    @parser = Einstein::Parser.new
    @parser.logger = Logger.new(STDERR)
  end

  def test_rshift
    assert_sexp([[:rshift, [:lit, 2], [:lit, 3]]], @parser.parse("2>>3"))
    assert_sexp([[:rshift, [:lit, 2], [:lit, 3]]], @parser.parse("2 >> 3"))
  end

  def test_lshift
    assert_sexp([[:lshift, [:lit, 2], [:lit, 3]]], @parser.parse("2<<3"))
    assert_sexp([[:lshift, [:lit, 2], [:lit, 3]]], @parser.parse("2 << 3"))
  end

  def test_subtraction
    assert_sexp([[:subtract, [:lit, 2], [:lit, 1]]], @parser.parse("2-1"))
    assert_sexp([[:subtract, [:lit, 2], [:lit, 1]]], @parser.parse("2 - 1"))
  end

  def test_addition
    assert_sexp([[:add, [:lit, 1], [:lit, 2]]], @parser.parse("1+2"))
    assert_sexp([[:add, [:lit, 1], [:lit, 2]]], @parser.parse("1 + 2"))
  end

  def test_modulus
    assert_sexp([[:modulus, [:lit, 10], [:lit, 5]]], @parser.parse("10%5"))
    assert_sexp([[:modulus, [:lit, 10], [:lit, 5]]], @parser.parse("10 % 5"))
  end

  def test_division
    assert_sexp([[:divide, [:lit, 10], [:lit, 5]]], @parser.parse("10/5"))
    assert_sexp([[:divide, [:lit, 10], [:lit, 5]]], @parser.parse("10 / 5"))
  end

  def test_multiplication
    assert_sexp([[:multiply, [:lit, 5], [:lit, 10]]], @parser.parse("5*10"))
    assert_sexp([[:multiply, [:lit, 5], [:lit, 10]]], @parser.parse("5 * 10"))
  end

  def test_float_scientific
    # Unsigned number, unsigned exponent, lowercase e
    assert_sexp([[:lit, 1.0e1]], @parser.parse("1.0e1"))
    assert_sexp([[:lit, 1.1e2]], @parser.parse("1.1e2"))
    assert_sexp([[:lit, 10.10e3]], @parser.parse("10.10e3"))
    # Unsigned number, positive exponent, lowercase e
    assert_sexp([[:lit, 1.0e+1]], @parser.parse("1.0e+1"))
    assert_sexp([[:lit, 1.1e+2]], @parser.parse("1.1e+2"))
    assert_sexp([[:lit, 10.10e+3]], @parser.parse("10.10e+3"))
    # Unsigned number, negative exponent, lowercase e
    assert_sexp([[:lit, 1.0e-1]], @parser.parse("1.0e-1"))
    assert_sexp([[:lit, 1.1e-2]], @parser.parse("1.1e-2"))
    assert_sexp([[:lit, 10.10e-3]], @parser.parse("10.10e-3"))
    # Unsigned number, unsigned exponent, uppercase e
    assert_sexp([[:lit, 1.0E1]], @parser.parse("1.0E1"))
    assert_sexp([[:lit, 1.1E2]], @parser.parse("1.1E2"))
    assert_sexp([[:lit, 10.10E3]], @parser.parse("10.10E3"))
    # Unsigned number, positive exponent, uppercase e
    assert_sexp([[:lit, 1.0E+1]], @parser.parse("1.0E+1"))
    assert_sexp([[:lit, 1.1E+2]], @parser.parse("1.1E+2"))
    assert_sexp([[:lit, 10.10E+3]], @parser.parse("10.10E+3"))
    # Unsigned number, negative exponent, uppercase e
    assert_sexp([[:lit, 1.0E-1]], @parser.parse("1.0E-1"))
    assert_sexp([[:lit, 1.1E-2]], @parser.parse("1.1E-2"))
    assert_sexp([[:lit, 10.10E-3]], @parser.parse("10.10E-3"))

    # Positive number, unsigned exponent, lowercase e
    assert_sexp([[:u_plus, [:lit, 1.0e1]]], @parser.parse("+1.0e1"))
    assert_sexp([[:u_plus, [:lit, 1.1e2]]], @parser.parse("+1.1e2"))
    assert_sexp([[:u_plus, [:lit, 10.10e3]]], @parser.parse("+10.10e3"))
    # Positive number, positive exponent, lowercase e
    assert_sexp([[:u_plus, [:lit, 1.0e+1]]], @parser.parse("+1.0e+1"))
    assert_sexp([[:u_plus, [:lit, 1.1e+2]]], @parser.parse("+1.1e+2"))
    assert_sexp([[:u_plus, [:lit, 10.10e+3]]], @parser.parse("+10.10e+3"))
    # Positive number, negative exponent, lowercase e
    assert_sexp([[:u_plus, [:lit, 1.0e-1]]], @parser.parse("+1.0e-1"))
    assert_sexp([[:u_plus, [:lit, 1.1e-2]]], @parser.parse("+1.1e-2"))
    assert_sexp([[:u_plus, [:lit, 10.10e-3]]], @parser.parse("+10.10e-3"))
    # Positive number, unsigned exponent, uppercase e
    assert_sexp([[:u_plus, [:lit, 1.0E1]]], @parser.parse("+1.0E1"))
    assert_sexp([[:u_plus, [:lit, 1.1E2]]], @parser.parse("+1.1E2"))
    assert_sexp([[:u_plus, [:lit, 10.10E3]]], @parser.parse("+10.10E3"))
    # Positive number, positive exponent, uppercase e
    assert_sexp([[:u_plus, [:lit, 1.0E+1]]], @parser.parse("+1.0E+1"))
    assert_sexp([[:u_plus, [:lit, 1.1E+2]]], @parser.parse("+1.1E+2"))
    assert_sexp([[:u_plus, [:lit, 10.10E+3]]], @parser.parse("+10.10E+3"))
    # Positive number, negative exponent, uppercase e
    assert_sexp([[:u_plus, [:lit, 1.0E-1]]], @parser.parse("+1.0E-1"))
    assert_sexp([[:u_plus, [:lit, 1.1E-2]]], @parser.parse("+1.1E-2"))
    assert_sexp([[:u_plus, [:lit, 10.10E-3]]], @parser.parse("+10.10E-3"))

    # Negative number, unsigned exponent, lowercase e
    assert_sexp([[:u_minus, [:lit, 1.0e1]]], @parser.parse("-1.0e1"))
    assert_sexp([[:u_minus, [:lit, 1.1e2]]], @parser.parse("-1.1e2"))
    assert_sexp([[:u_minus, [:lit, 10.10e3]]], @parser.parse("-10.10e3"))
    # Negative number, positive exponent, lowercase e
    assert_sexp([[:u_minus, [:lit, 1.0e+1]]], @parser.parse("-1.0e+1"))
    assert_sexp([[:u_minus, [:lit, 1.1e+2]]], @parser.parse("-1.1e+2"))
    assert_sexp([[:u_minus, [:lit, 10.10e+3]]], @parser.parse("-10.10e+3"))
    # Negative number, negative exponent, lowercase e
    assert_sexp([[:u_minus, [:lit, 1.0e-1]]], @parser.parse("-1.0e-1"))
    assert_sexp([[:u_minus, [:lit, 1.1e-2]]], @parser.parse("-1.1e-2"))
    assert_sexp([[:u_minus, [:lit, 10.10e-3]]], @parser.parse("-10.10e-3"))
    # Negative number, unsigned exponent, uppercase e
    assert_sexp([[:u_minus, [:lit, 1.0E1]]], @parser.parse("-1.0E1"))
    assert_sexp([[:u_minus, [:lit, 1.1E2]]], @parser.parse("-1.1E2"))
    assert_sexp([[:u_minus, [:lit, 10.10E3]]], @parser.parse("-10.10E3"))
    # Negative number, positive exponent, uppercase e
    assert_sexp([[:u_minus, [:lit, 1.0E+1]]], @parser.parse("-1.0E+1"))
    assert_sexp([[:u_minus, [:lit, 1.1E+2]]], @parser.parse("-1.1E+2"))
    assert_sexp([[:u_minus, [:lit, 10.10E+3]]], @parser.parse("-10.10E+3"))
    # Negative number, negative exponent, uppercase e
    assert_sexp([[:u_minus, [:lit, 1.0E-1]]], @parser.parse("-1.0E-1"))
    assert_sexp([[:u_minus, [:lit, 1.1E-2]]], @parser.parse("-1.1E-2"))
    assert_sexp([[:u_minus, [:lit, 10.10E-3]]], @parser.parse("-10.10E-3"))
  end

  def test_float
    # Unsigned
    assert_sexp([[:lit, 0.0]], @parser.parse("0.0"))
    assert_sexp([[:lit, 1.1]], @parser.parse("1.1"))
    assert_sexp([[:lit, 10.10]], @parser.parse("10.10"))

    # Positive
    assert_sexp([[:u_plus, [:lit, 1.1]]], @parser.parse("+1.1"))
    assert_sexp([[:u_plus, [:lit, 10.10]]], @parser.parse("+10.10"))

    # Negative
    assert_sexp([[:u_minus, [:lit, 1.1]]], @parser.parse("-1.1"))
    assert_sexp([[:u_minus, [:lit, 10.10]]], @parser.parse("-10.10"))
  end

  def test_number_base2
    # Unsigned, lowercase b
    assert_sexp([[:lit, 0b0000]], @parser.parse("0b0"))
    assert_sexp([[:lit, 0b1111]], @parser.parse("0b1111"))
    assert_sexp([[:lit, 0b1010]], @parser.parse("0b1010"))
    # Unsigned, uppercase b
    assert_sexp([[:lit, 0B0000]], @parser.parse("0B0"))
    assert_sexp([[:lit, 0B1111]], @parser.parse("0B1111"))
    assert_sexp([[:lit, 0B1010]], @parser.parse("0B1010"))

    # Positive, lowercase b
    assert_sexp([[:u_plus, [:lit, 0b1111]]], @parser.parse("+0b1111"))
    assert_sexp([[:u_plus, [:lit, 0b1010]]], @parser.parse("+0b1010"))
    # Positive, uppercase b
    assert_sexp([[:u_plus, [:lit, 0B1111]]], @parser.parse("+0B1111"))
    assert_sexp([[:u_plus, [:lit, 0B1010]]], @parser.parse("+0B1010"))

    # Negative, lowercase b
    assert_sexp([[:u_minus, [:lit, 0b1111]]], @parser.parse("-0b1111"))
    assert_sexp([[:u_minus, [:lit, 0b1010]]], @parser.parse("-0b1010"))
    # Negative, uppercase b
    assert_sexp([[:u_minus, [:lit, 0B1111]]], @parser.parse("-0B1111"))
    assert_sexp([[:u_minus, [:lit, 0B1010]]], @parser.parse("-0B1010"))
  end

  def test_number_base8
    # Unsigned, lowercase x
    assert_sexp([[:lit, 0x0]], @parser.parse("0x0"))
    assert_sexp([[:lit, 0xaa]], @parser.parse("0xaa"))
    assert_sexp([[:lit, 0xFF]], @parser.parse("0xFF"))
    # Unsigned, uppercase x
    assert_sexp([[:lit, 0x0]], @parser.parse("0X0"))
    assert_sexp([[:lit, 0xaa]], @parser.parse("0Xaa"))
    assert_sexp([[:lit, 0xFF]], @parser.parse("0XFF"))

    # Positive, lowercase x
    assert_sexp([[:u_plus, [:lit, 0xaa]]], @parser.parse("+0xaa"))
    assert_sexp([[:u_plus, [:lit, 0xFF]]], @parser.parse("+0xFF"))
    # Positive, uppercase x
    assert_sexp([[:u_plus, [:lit, 0xaa]]], @parser.parse("+0Xaa"))
    assert_sexp([[:u_plus, [:lit, 0xFF]]], @parser.parse("+0XFF"))

    # Negative, lowercase x
    assert_sexp([[:u_minus, [:lit, 0xaa]]], @parser.parse("-0xaa"))
    assert_sexp([[:u_minus, [:lit, 0xFF]]], @parser.parse("-0xFF"))
    # Negative, uppercase x
    assert_sexp([[:u_minus, [:lit, 0xaa]]], @parser.parse("-0Xaa"))
    assert_sexp([[:u_minus, [:lit, 0xFF]]], @parser.parse("-0XFF"))
  end

  def test_number_base10
    # Unsigned
    assert_sexp([[:lit, 0]], @parser.parse("0"))
    assert_sexp([[:lit, 1]], @parser.parse("01"))
    assert_sexp([[:lit, 10]], @parser.parse("10"))

    # Positive
    assert_sexp([[:u_plus, [:lit, 1]]], @parser.parse("+1"))
    assert_sexp([[:u_plus, [:lit, 10]]], @parser.parse("+10"))

    # Negative
    assert_sexp([[:u_minus, [:lit, 1]]], @parser.parse("-1"))
    assert_sexp([[:u_minus, [:lit, 10]]], @parser.parse("-10"))
  end

  private

  def assert_sexp(expected, node)
    assert_equal(expected, node.to_sexp)
  end
end
