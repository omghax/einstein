require File.dirname(__FILE__) + "/helper"

class TestTokenizer < Test::Unit::TestCase
  def setup
    @tokenizer = Einstein::Tokenizer.new
  end

  def test_rshift
    assert_equal [[:RSHIFT, ">>"]], tokenize(">>")
  end

  def test_lshift
    assert_equal [[:LSHIFT, "<<"]], tokenize("<<")
  end

  def test_raise
    assert_equal [[:RAISE, "**"]], tokenize("**")
  end

  def test_single_char
    assert_equal [["(", "("]], tokenize("(")
    assert_equal [["{", "{"]], tokenize("{")
    assert_equal [["!", "!"]], tokenize("!")
  end

  def test_comment
    assert_equal [[:COMMENT, "/* hope this works... */"]], tokenize("/* hope this works... */")
  end

  def test_whitespace
    assert_equal [[:WS, " \t\r\n"]], tokenize(" \t\r\n")
  end

  def test_ident
    assert_equal [[:IDENT, "x"]], tokenize("x")
  end

  def test_float_scientific
    assert_equal [[:NUMBER, 10.10e-3]], tokenize("10.10e-3")
  end

  def test_float
    assert_equal [[:NUMBER, 10.10]], tokenize("10.10")
  end

  def test_number_base2
    assert_equal [[:NUMBER, 0b1010]], tokenize("0b1010")
  end

  def test_number_base8
    assert_equal [[:NUMBER, 011]], tokenize("011")
  end

  def test_number_base16
    assert_equal [[:NUMBER, 0xdeadbeef]], tokenize("0xdeadbeef")
    assert_equal [[:NUMBER, 0xCAFEBABE]], tokenize("0xCAFEBABE")
  end

  def test_number_base10
    assert_equal [[:NUMBER, 15]], tokenize("15")
  end

  private

  def tokenize(stmt)
    @tokenizer.tokenize(stmt)
  end
end
