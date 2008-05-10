require 'einstein/processors/evaluate_processor'
require 'einstein/processors/pretty_print_processor'

module Einstein
  class Expression
    def initialize(exp)
      @exp = exp
    end

    def to_sexp
      @exp
    end

    def evaluate(scope = {})
      EvaluateProcessor.new(scope).process(@exp)
    end

    def to_s
      PrettyPrintProcessor.new.process(@exp)
    end

    alias_method :inspect, :to_s
  end
end
