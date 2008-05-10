require 'einstein/processors/evaluate_processor'
require 'einstein/processors/pretty_print_processor'

module Einstein
  # Node representing an entire Einstein statement.  This is the root-level
  # node of the parser.  This node's +exp+ is the tree of expressions that
  # make up a single logical statement.
  class Expression
    # Initialize a new expression wrapping the given +sexp+, which is expected
    # to be an s-expression represented as a set of nested arrays.
    # 
    # Example:
    #   Expression.new([:lit, 10]) # => 10
    #   Expression.new([:multiply, [:lit, 10], [:lit, 5]]) # => (10 * 5)
    def initialize(sexp)
      @sexp = sexp
    end

    # The s-expression given to this Expression's constructor.
    attr_reader :sexp
    alias_method :to_sexp, :sexp

    # Evaluate this node against the given +scope+. Returns a numeric value
    # calculated by walking the AST with an instance of EvaluateProcessor.
    def evaluate(scope = {})
      EvaluateProcessor.new(scope).process(sexp)
    end

    # Performs a "pretty print" of this expression.
    def to_s
      PrettyPrintProcessor.new.process(sexp)
    end

    # Also use #to_s for inspecting a node in IRB.
    alias_method :inspect, :to_s
  end
end
