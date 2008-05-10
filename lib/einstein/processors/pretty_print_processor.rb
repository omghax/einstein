require 'rubygems'
require 'sexp_processor'

module Einstein
  class PrettyPrintProcessor < SexpProcessor
    def initialize
      super
      self.auto_shift_type = true
      self.strict = true
      self.expected = String
    end

    def process_lit(exp)
      exp.shift.to_s
    end

    def process_u_plus(exp)
      "+#{process(exp.shift)}"
    end

    def process_u_minus(exp)
      "-#{process(exp.shift)}"
    end

    def process_bitwise_not(exp)
      "~#{process(exp.shift)}"
    end

    def process_raise(exp)
      "(#{process(exp.shift)} ** #{process(exp.shift)})"
    end

    def process_multiply(exp)
      "(#{process(exp.shift)} * #{process(exp.shift)})"
    end

    def process_divide(exp)
      "(#{process(exp.shift)} / #{process(exp.shift)})"
    end

    def process_modulus(exp)
      "(#{process(exp.shift)} % #{process(exp.shift)})"
    end

    def process_add(exp)
      "(#{process(exp.shift)} + #{process(exp.shift)})"
    end

    def process_subtract(exp)
      "(#{process(exp.shift)} - #{process(exp.shift)})"
    end

    def process_lshift(exp)
      "(#{process(exp.shift)} << #{process(exp.shift)})"
    end

    def process_rshift(exp)
      "(#{process(exp.shift)} >> #{process(exp.shift)})"
    end

    def process_bitwise_and(exp)
      "(#{process(exp.shift)} & #{process(exp.shift)})"
    end

    def process_bitwise_xor(exp)
      "(#{process(exp.shift)} ^ #{process(exp.shift)})"
    end

    def process_bitwise_or(exp)
      "(#{process(exp.shift)} | #{process(exp.shift)})"
    end

    def process_resolve(exp)
      exp.shift
    end
  end
end
