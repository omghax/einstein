require File.dirname(__FILE__) + "/helper"

class TestPrettyPrintProcessor < Test::Unit::TestCase
  def setup
    @processor = Einstein::PrettyPrintProcessor.new
  end

  def test_resolve
    assert_equal "x", process([:resolve, "x"])
  end

  def test_bitwise_or
    assert_equal "(10 | 5)", process([:bitwise_or, [:lit, 10], [:lit, 5]])
  end

  def test_bitwise_xor
    assert_equal "(10 ^ 5)", process([:bitwise_xor, [:lit, 10], [:lit, 5]])
  end

  def test_bitwise_and
    assert_equal "(10 & 5)", process([:bitwise_and, [:lit, 10], [:lit, 5]])
  end

  def test_rshift
    assert_equal "(10 >> 5)", process([:rshift, [:lit, 10], [:lit, 5]])
  end

  def test_lshift
    assert_equal "(10 << 5)", process([:lshift, [:lit, 10], [:lit, 5]])
  end

  def test_subtract
    assert_equal "(10 - 5)", process([:subtract, [:lit, 10], [:lit, 5]])
  end

  def test_add
    assert_equal "(10 + 5)", process([:add, [:lit, 10], [:lit, 5]])
  end

  def test_modulus
    assert_equal "(10 % 5)", process([:modulus, [:lit, 10], [:lit, 5]])
  end

  def test_divide
    assert_equal "(10 / 5)", process([:divide, [:lit, 10], [:lit, 5]])
  end

  def test_multiply
    assert_equal "(10 * 5)", process([:multiply, [:lit, 10], [:lit, 5]])
  end

  def test_exponent
    assert_equal "(10 ** 5)", process([:raise, [:lit, 10], [:lit, 5]])
  end

  def test_bitwise_not
    assert_equal "~10", process([:bitwise_not, [:lit, 10]])
  end

  def test_u_minus
    assert_equal "-10", process([:u_minus, [:lit, 10]])
  end

  def test_u_plus
    assert_equal "+10", process([:u_plus, [:lit, 10]])
  end

  def test_lit
    assert_equal "0", process([:lit, 0])
    assert_equal "1", process([:lit, 1])
    assert_equal "10", process([:lit, 10])

    assert_equal "10.1", process([:lit, 10.1])
  end

  private

  def process(exp)
    @processor.process(exp)
  end
end
