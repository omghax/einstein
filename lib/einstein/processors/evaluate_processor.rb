require 'einstein/processor'

module Einstein
  class EvaluateProcessor < Processor
    def initialize(scope = {})
      super()
      self.expected = Numeric

      # Convert the scope hash keys from symbols to strings.
      @scope = scope.inject({}) do |hash, (key, value)|
        hash[key.to_s] = value
        hash
      end
    end

    def process_lit(exp)
      exp.shift
    end

    def process_u_plus(exp)
      process(exp.shift)
    end

    def process_u_minus(exp)
      -process(exp.shift)
    end

    def process_bitwise_not(exp)
      ~process(exp.shift)
    end

    def process_raise(exp)
      process(exp.shift) ** process(exp.shift)
    end

    def process_multiply(exp)
      process(exp.shift) * process(exp.shift)
    end

    def process_divide(exp)
      process(exp.shift) / process(exp.shift)
    end

    def process_modulus(exp)
      process(exp.shift) % process(exp.shift)
    end

    def process_add(exp)
      process(exp.shift) + process(exp.shift)
    end

    def process_subtract(exp)
      process(exp.shift) - process(exp.shift)
    end

    def process_lshift(exp)
      process(exp.shift) << process(exp.shift)
    end

    def process_rshift(exp)
      process(exp.shift) >> process(exp.shift)
    end

    def process_bitwise_and(exp)
      process(exp.shift) & process(exp.shift)
    end

    def process_bitwise_xor(exp)
      process(exp.shift) ^ process(exp.shift)
    end

    def process_bitwise_or(exp)
      process(exp.shift) | process(exp.shift)
    end

    def process_resolve(exp)
      raise ResolveError, "undefined variable: #{exp.first}" unless @scope.has_key?(exp.first)
      @scope[exp.shift]
    end
  end
end
