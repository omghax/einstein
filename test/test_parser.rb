require File.dirname(__FILE__) + '/helper'

class TestParser < Test::Unit::TestCase
  def setup
    @parser = Einstein::Parser.new
  end

  def test_parentheses
    assert_equal \
      [:multiply, 
        [:add, [:lit, 5], [:lit, 2]],
        [:subtract, [:lit, 10], [:lit, 5]]
      ],
      parse('(5 + 2) * (10 - 5)')
  end

  def test_order_of_operations
    assert_equal \
      [:subtract,
        [:add,
          [:divide, [:lit, 6], [:lit, 3]],
          [:multiply, [:lit, 4], [:lit, 2]]],
        [:lit, 5]
      ],
      parse('6 / 3 + 4 * 2 - 5')
  end

  def test_resolve
    assert_equal [:resolve, 'x'], parse('x')
    assert_equal [:resolve, 'with_underscores'], parse('with_underscores')
    assert_equal [:resolve, '_leading_underscore'], parse('_leading_underscore')
    assert_equal [:resolve, 'trailing_underscore_'], parse('trailing_underscore_')
  end

  def test_bitwise_or
    assert_equal [:bitwise_or, [:lit, 5], [:lit, 10]], parse('5 | 10')
  end

  def test_bitwise_xor
    assert_equal [:bitwise_xor, [:lit, 5], [:lit, 10]], parse('5 ^ 10')
  end

  def test_bitwise_and
    assert_equal [:bitwise_and, [:lit, 5], [:lit, 10]], parse('5 & 10')
  end

  def test_rshift
    assert_equal [:rshift, [:lit, 2], [:lit, 3]], parse('2 >> 3')
  end

  def test_lshift
    assert_equal [:lshift, [:lit, 2], [:lit, 3]], parse('2 << 3')
  end

  def test_subtraction
    assert_equal [:subtract, [:lit, 2], [:lit, 1]], parse('2 - 1')
  end

  def test_addition
    assert_equal [:add, [:lit, 1], [:lit, 2]], parse('1 + 2')
  end

  def test_modulus
    assert_equal [:modulus, [:lit, 10], [:lit, 5]], parse('10 % 5')
  end

  def test_division
    assert_equal [:divide, [:lit, 10], [:lit, 5]], parse('10 / 5')
  end

  def test_multiplication
    assert_equal [:multiply, [:lit, 5], [:lit, 10]], parse('5 * 10')
  end

  def test_exponent
    assert_equal [:exponent, [:lit, 5], [:lit, 2]], parse('5 ** 2')
    assert_equal [:exponent, [:lit, 3], [:unary_minus, [:lit, 6]]], parse('3 ** -6')
    assert_equal [:exponent, [:lit, 18], [:bitwise_not, [:lit, 4]]], parse('18 ** ~4')
  end

  def test_unary_bitwise_not
    assert_equal [:bitwise_not, [:lit, 10]], parse('~10')
  end

  def test_unary_minus
    assert_equal [:unary_minus, [:lit, 10]], parse('-10')
  end

  def test_unary_plus
    assert_equal [:unary_plus, [:lit, 10]], parse('+10')
  end

  def test_float_scientific
    assert_equal [:lit, 10.10e-3], parse('10.10e-3')
    assert_equal [:lit, 12.34E+4], parse('12.34E+4')
  end

  def test_float
    assert_equal [:lit, 10.10], parse('10.10')
  end

  def test_number_base2
    assert_equal [:lit, 0b1010], parse('0b1010')
    assert_equal [:lit, 0B0101], parse('0B0101')
  end

  def test_number_base8
    assert_equal [:lit, 011], parse('011')
  end

  def test_number_base16
    assert_equal [:lit, 0xdeadbeef], parse('0xdeadbeef')
    assert_equal [:lit, 0Xdeadbeef], parse('0Xdeadbeef')
    assert_equal [:lit, 0xCAFEBABE], parse('0xCAFEBABE')
    assert_equal [:lit, 0XCAFEBABE], parse('0XCAFEBABE')
  end

  def test_number_base10
    assert_equal [:lit, 15], parse('15')
  end

  private

  def parse(stmt)
    @parser.scan_str(stmt)
  end
end
