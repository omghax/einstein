require 'rubygems'
require 'sexp_processor'

module Einstein
  # This processor walks the AST and builds a "pretty print" of the values. 
  # This means that it returns an unambiguous string representation of the
  # tree.  All binary expressions are wrapped in parentheses.  This processor
  # is used when calling #inspect on an expression.
  class PrettyPrintProcessor < SexpProcessor
    def initialize
      super
      self.auto_shift_type = true
      self.strict = true
      self.expected = String
    end

    # Example: 4
    def process_lit(exp)
      exp.shift.to_s
    end

    # Example: +4
    def process_u_plus(exp)
      "+#{process(exp.shift)}"
    end

    # Example: -4
    def process_u_minus(exp)
      "-#{process(exp.shift)}"
    end

    # Example: ~4
    def process_bitwise_not(exp)
      "~#{process(exp.shift)}"
    end

    # Example: (2 ** 3)
    def process_raise(exp)
      "(#{process(exp.shift)} ** #{process(exp.shift)})"
    end

    # Example: (2 * 3)
    def process_multiply(exp)
      "(#{process(exp.shift)} * #{process(exp.shift)})"
    end

    # Example: (6 / 3)
    def process_divide(exp)
      "(#{process(exp.shift)} / #{process(exp.shift)})"
    end

    # Example: (7 % 3)
    def process_modulus(exp)
      "(#{process(exp.shift)} % #{process(exp.shift)})"
    end

    # Example: (5 + 8)
    def process_add(exp)
      "(#{process(exp.shift)} + #{process(exp.shift)})"
    end

    # Example: (6 - 3)
    def process_subtract(exp)
      "(#{process(exp.shift)} - #{process(exp.shift)})"
    end

    # Example: (8 << 2)
    def process_lshift(exp)
      "(#{process(exp.shift)} << #{process(exp.shift)})"
    end

    # Example: (8 >> 2)
    def process_rshift(exp)
      "(#{process(exp.shift)} >> #{process(exp.shift)})"
    end

    # Example: (4 & 16)
    def process_bitwise_and(exp)
      "(#{process(exp.shift)} & #{process(exp.shift)})"
    end

    # Example: (4 ^ 6)
    def process_bitwise_xor(exp)
      "(#{process(exp.shift)} ^ #{process(exp.shift)})"
    end

    # Example: (4 | 6)
    def process_bitwise_or(exp)
      "(#{process(exp.shift)} | #{process(exp.shift)})"
    end

    # Example: x
    def process_resolve(exp)
      exp.shift
    end
  end
end
