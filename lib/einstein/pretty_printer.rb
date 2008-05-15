require 'einstein/processor'

module Einstein
  # This processor walks the AST and builds a "pretty print" of the values. 
  # This means that it returns an unambiguous string representation of the
  # tree.  All binary expressions are wrapped in parentheses.
  class PrettyPrinter < Processor
    # Example: 4
    def process_lit(exp)
      exp[1].to_s
    end

    # Example: +4
    def process_unary_plus(exp)
      unary_op("+", exp)
    end

    # Example: -4
    def process_unary_minus(exp)
      unary_op("-", exp)
    end

    # Example: ~4
    def process_bitwise_not(exp)
      unary_op("~", exp)
    end

    # Example: (2 ** 3)
    def process_exponent(exp)
      binary_op("**", exp)
    end

    # Example: (2 * 3)
    def process_multiply(exp)
      binary_op("*", exp)
    end

    # Example: (6 / 3)
    def process_divide(exp)
      binary_op("/", exp)
    end

    # Example: (7 % 3)
    def process_modulus(exp)
      binary_op("%", exp)
    end

    # Example: (5 + 8)
    def process_add(exp)
      binary_op("+", exp)
    end

    # Example: (6 - 3)
    def process_subtract(exp)
      binary_op("-", exp)
    end

    # Example: (8 << 2)
    def process_lshift(exp)
      binary_op("<<", exp)
    end

    # Example: (8 >> 2)
    def process_rshift(exp)
      binary_op(">>", exp)
    end

    # Example: (4 & 16)
    def process_bitwise_and(exp)
      binary_op("&", exp)
    end

    # Example: (4 ^ 6)
    def process_bitwise_xor(exp)
      binary_op("^", exp)
    end

    # Example: (4 | 6)
    def process_bitwise_or(exp)
      binary_op("|", exp)
    end

    # Example: x
    def process_resolve(exp)
      exp[1]
    end

    private

    def unary_op(operation, exp)
      "#{operation}#{process(exp[1])}"
    end

    def binary_op(operation, exp)
      "(#{process(exp[1])} #{operation} #{process(exp[2])})"
    end
  end
end
