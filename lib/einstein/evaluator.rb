require 'einstein/processor'

module Einstein
  # This processor walks the AST and evaluates the values of the nodes.
  class Evaluator < Processor
    # Initialize a new instance of this processor with the given +scope+, as a
    # hash.  This +scope+ should provide a mapping of variable names to
    # values.
    def initialize(scope = {})
      # Convert symbol keys into strings.
      @scope = scope.inject({}) do |hash, (key, value)|
        hash[key.to_s] = value
        hash
      end
    end

    # Returns the value of +exp+.
    def process_lit(exp)
      exp[1]
    end

    # Returns the value of +exp+.
    def process_unary_plus(exp)
      process(exp[1])
    end

    # Returns the negated value of +exp+.
    def process_unary_minus(exp)
      -process(exp[1])
    end

    # Performs a bitwise NOT operation on the value of +exp+.
    def process_bitwise_not(exp)
      ~process(exp[1])
    end

    # Raises the left value of +exp+ by the right value of +exp+.
    def process_exponent(exp)
      process(exp[1]) ** process(exp[2])
    end

    # Multiplies the left and right values of +exp+.
    def process_multiply(exp)
      process(exp[1]) * process(exp[2])
    end

    # Divides the left value of +exp+ by the right value of +exp+.  Will raise
    # ZeroDivisionError if the right value of +exp+ evaluates to 0.
    def process_divide(exp)
      process(exp[1]) / process(exp[2])
    end

    # Performs a modulus operation for the left and right values of +exp+.
    def process_modulus(exp)
      process(exp[1]) % process(exp[2])
    end

    # Adds the left and right values of +exp+.
    def process_add(exp)
      process(exp[1]) + process(exp[2])
    end

    # Subtracts the right value of +exp+ by the left value of +exp+.
    def process_subtract(exp)
      process(exp[1]) - process(exp[2])
    end

    # Performs a bitwise left shift of the left value of +exp+ by the number
    # of bits specified in the right value of +exp+.
    def process_lshift(exp)
      process(exp[1]) << process(exp[2])
    end

    # Performs a bitwise right shift of the left value of +exp+ by the number
    # of bits specified in the right value of +exp+.
    def process_rshift(exp)
      process(exp[1]) >> process(exp[2])
    end

    # Performs a bitwise AND with the left and right values of +exp+.
    def process_bitwise_and(exp)
      process(exp[1]) & process(exp[2])
    end

    # Performs a bitwise XOR with the left and right values of +exp+.
    def process_bitwise_xor(exp)
      process(exp[1]) ^ process(exp[2])
    end

    # Performs a bitwise OR with the left and right values of +exp+.
    def process_bitwise_or(exp)
      process(exp[1]) | process(exp[2])
    end

    # Performs a lookup for the value of +exp+ inside this processor's scope.
    # Raises ResolveError if the variable is not in scope.
    def process_resolve(exp)
      raise ResolveError, "Undefined variable: #{exp[1]}" unless @scope.has_key?(exp[1])
      @scope[exp[1]]
    end
  end
end
