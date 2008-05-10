require 'rubygems'
require 'sexp_processor'

module Einstein
  # This processor walks the AST and evaluates the values of the nodes.
  class EvaluateProcessor < SexpProcessor
    # Initialize a new instance of this processor with the given +scope+, as a
    # hash.  This +scope+ should provide a mapping of variable names to
    # values.
    def initialize(scope = {})
      super()
      self.auto_shift_type = true
      self.strict = true
      self.expected = Numeric

      # Convert the scope hash keys from symbols to strings.
      @scope = scope.inject({}) do |hash, (key, value)|
        hash[key.to_s] = value
        hash
      end
    end

    # Returns the value of +exp+.
    def process_lit(exp)
      exp.shift
    end

    # Returns the value of +exp+.
    def process_u_plus(exp)
      process(exp.shift)
    end

    # Returns the negated value of +exp+.
    def process_u_minus(exp)
      -process(exp.shift)
    end

    # Performs a bitwise NOT operation on the value of +exp+.
    def process_bitwise_not(exp)
      ~process(exp.shift)
    end

    # Raises the left value of +exp+ by the right value of +exp+.
    def process_raise(exp)
      process(exp.shift) ** process(exp.shift)
    end

    # Multiplies the left and right values of +exp+.
    def process_multiply(exp)
      process(exp.shift) * process(exp.shift)
    end

    # Divides the left value of +exp+ by the right value of +exp+.
    def process_divide(exp)
      process(exp.shift) / process(exp.shift)
    end

    # Performs a modulus operation for the left and right values of +exp+.
    def process_modulus(exp)
      process(exp.shift) % process(exp.shift)
    end

    # Adds the left and right values of +exp+.
    def process_add(exp)
      process(exp.shift) + process(exp.shift)
    end

    # Subtracts the right value of +exp+ by the left value of +exp+.
    def process_subtract(exp)
      process(exp.shift) - process(exp.shift)
    end

    # Performs a bitwise left shift of the left value of +exp+ by the number
    # of bits specified in the right value of +exp+.
    def process_lshift(exp)
      process(exp.shift) << process(exp.shift)
    end

    # Performs a bitwise right shift of the left value of +exp+ by the number
    # of bits specified in the right value of +exp+.
    def process_rshift(exp)
      process(exp.shift) >> process(exp.shift)
    end

    # Performs a bitwise AND with the left and right values of +exp+.
    def process_bitwise_and(exp)
      process(exp.shift) & process(exp.shift)
    end

    # Performs a bitwise XOR with the left and right values of +exp+.
    def process_bitwise_xor(exp)
      process(exp.shift) ^ process(exp.shift)
    end

    # Performs a bitwise OR with the left and right values of +exp+.
    def process_bitwise_or(exp)
      process(exp.shift) | process(exp.shift)
    end

    # Performs a lookup for the value of +exp+ inside this processor's scope.
    # Raises ResolveError if the variable is not in scope.
    def process_resolve(exp)
      raise ResolveError, "undefined variable: #{exp.first}" unless @scope.has_key?(exp.first)
      @scope[exp.shift]
    end
  end
end
