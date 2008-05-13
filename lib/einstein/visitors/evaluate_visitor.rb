require 'einstein/visitor'

module Einstein
  # This visitor walks the AST and evaluates the values of the nodes.
  class EvaluateVisitor < Visitor
    # Initialize a new instance of this visitor with the given +scope+, as a
    # hash.  This +scope+ should provide a mapping of variable names to
    # values.
    def initialize(scope)
      super()

      # Convert the scope hash keys from symbols to strings.
      @scope = scope.inject({}) do |hash, (key, value)|
        hash[key.to_s] = value
        hash
      end
    end

    # Returns the value of +o+.
    def visit_NumberNode(o)
      o.value
    end

    # Returns the value of +o+.
    def visit_UnaryPlusNode(o)
      accept(o.value)
    end

    # Returns the negated value of +o+.
    def visit_UnaryMinusNode(o)
      -accept(o.value)
    end

    # Raises the left value of +o+ by the right value of +o+.
    def visit_ExponentNode(o)
      accept(o.left) ** accept(o.value)
    end

    # Multiplies the left and right values of +o+.
    def visit_MultiplyNode(o)
      accept(o.left) * accept(o.value)
    end

    # Divides the left value of +o+ by the right value of +o+.  Raises
    # ZeroDivisionError if the right value of +o+ is zero.
    def visit_DivideNode(o)
      dividend = accept(o.value)
      raise ZeroDivisionError, "divided by zero" if dividend == 0
      accept(o.left) / dividend
    end

    # Performs a modulus operation for the left and right values of +o+.
    def visit_ModulusNode(o)
      accept(o.left) % accept(o.value)
    end

    # Adds the left and right values of +o+.
    def visit_AddNode(o)
      accept(o.left) + accept(o.value)
    end

    # Subtracts the right value of +o+ by the left value of +o+.
    def visit_SubtractNode(o)
      accept(o.left) - accept(o.value)
    end

    # Performs a bitwise left shift of the left value of +o+ by the number
    # of bits specified in the right value of +o+.
    def visit_LeftShiftNode(o)
      accept(o.left) << accept(o.value)
    end

    # Performs a bitwise right shift of the left value of +o+ by the number
    # of bits specified in the right value of +o+.
    def visit_RightShiftNode(o)
      accept(o.left) >> accept(o.value)
    end

    # Performs a bitwise AND with the left and right values of +o+.
    def visit_BitwiseAndNode(o)
      accept(o.left) & accept(o.value)
    end

    # Performs a bitwise XOR with the left and right values of +o+.
    def visit_BitwiseXorNode(o)
      accept(o.left) ^ accept(o.value)
    end

    # Performs a bitwise OR with the left and right values of +o+.
    def visit_BitwiseOrNode(o)
      accept(o.left) | accept(o.value)
    end

    # Performs a lookup for the value of +o+ inside this visitor's scope. 
    # Raises ResolveError if the variable is not in scope.
    def visit_ResolveNode(o)
      raise ResolveError, "undefined variable: #{o.value}" unless @scope.has_key?(o.value)
      @scope[o.value]
    end
  end
end
