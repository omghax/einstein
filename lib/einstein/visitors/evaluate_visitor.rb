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
      o.value.accept(self)
    end

    # Returns the negated value of +o+.
    def visit_UnaryMinusNode(o)
      -o.value.accept(self)
    end

    # Raises the left value of +o+ by the right value of +o+.
    def visit_ExponentNode(o)
      o.left.accept(self) ** o.value.accept(self)
    end

    # Multiplies the left and right values of +o+.
    def visit_MultiplyNode(o)
      o.left.accept(self) * o.value.accept(self)
    end

    # Divides the left value of +o+ by the right value of +o+.  Raises
    # ZeroDivisionError if the right value of +o+ is zero.
    def visit_DivideNode(o)
      dividend = o.value.accept(self)
      raise ZeroDivisionError, "divided by zero" if dividend == 0
      o.left.accept(self) / dividend
    end

    # Performs a modulus operation for the left and right values of +o+.
    def visit_ModulusNode(o)
      o.left.accept(self) % o.value.accept(self)
    end

    # Adds the left and right values of +o+.
    def visit_AddNode(o)
      o.left.accept(self) + o.value.accept(self)
    end

    # Subtracts the right value of +o+ by the left value of +o+.
    def visit_SubtractNode(o)
      o.left.accept(self) - o.value.accept(self)
    end

    # Performs a bitwise left shift of the left value of +o+ by the number
    # of bits specified in the right value of +o+.
    def visit_LeftShiftNode(o)
      o.left.accept(self) << o.value.accept(self)
    end

    # Performs a bitwise right shift of the left value of +o+ by the number
    # of bits specified in the right value of +o+.
    def visit_RightShiftNode(o)
      o.left.accept(self) >> o.value.accept(self)
    end

    # Performs a bitwise AND with the left and right values of +o+.
    def visit_BitwiseAndNode(o)
      o.left.accept(self) & o.value.accept(self)
    end

    # Performs a bitwise XOR with the left and right values of +o+.
    def visit_BitwiseXorNode(o)
      o.left.accept(self) ^ o.value.accept(self)
    end

    # Performs a bitwise OR with the left and right values of +o+.
    def visit_BitwiseOrNode(o)
      o.left.accept(self) | o.value.accept(self)
    end

    # Performs a lookup for the value of +o+ inside this visitor's scope. 
    # Raises ResolveError if the variable is not in scope.
    def visit_ResolveNode(o)
      raise ResolveError, "undefined variable: #{o.value}" unless @scope.has_key?(o.value)
      @scope[o.value]
    end
  end
end
