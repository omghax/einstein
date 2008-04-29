module Einstein
  module Visitors
    class Visitor
      TERMINAL_NODES = %w{
        Number
      }
      SINGLE_VALUE_NODES = %w{
        BitwiseNot Resolve Statement UnaryMinus UnaryPlus
      }
      BINARY_NODES = %w{
        Add BitwiseAnd BitwiseOr BitwiseXor Divide Exponent LeftShift Modulus
        Multiply RightShift Subtract
      }

      def accept(target)
        target.accept(self)
      end

      TERMINAL_NODES.each do |type|
        define_method("visit_#{type}Node") { |o| }
      end

      BINARY_NODES.each do |type|
        define_method("visit_#{type}Node") do |o|
          [o.left && o.left.accept(self), o.value && o.value.accept(self)]
        end
      end

      SINGLE_VALUE_NODES.each do |type|
        define_method("visit_#{type}Node") do |o|
          o.value.accept(self)
        end
      end
    end

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

    # This visitor walks the AST and returns an s-expression.
    class SexpVisitor < Visitor
      # Example: [:lit, 3]
      def visit_NumberNode(o)
        [:lit, o.value]
      end

      # Example: [:u_plus, [:lit, 3]]
      def visit_UnaryPlusNode(o)
        [:u_plus, super]
      end

      # Example: [:u_minus, [:lit, 3]]
      def visit_UnaryMinusNode(o)
        [:u_minus, super]
      end

      # Example: [:bitwise_not, [:lit, 3]]
      def visit_BitwiseNotNode(o)
        [:bitwise_not, super]
      end

      # Example: [:raise, [:lit, 2], [:lit, 3]]
      def visit_ExponentNode(o)
        [:raise, *super]
      end

      # Example: [:multiply, [:lit, 2], [:lit, 3]]
      def visit_MultiplyNode(o)
        [:multiply, *super]
      end

      # Example: [:divide, [:lit, 4], [:lit, 2]]
      def visit_DivideNode(o)
        [:divide, *super]
      end

      # Example: [:modulus, [:lit, 3], [:lit, 5]]
      def visit_ModulusNode(o)
        [:modulus, *super]
      end

      # Example: [:add, [:lit, 2], [:lit, 2]]
      def visit_AddNode(o)
        [:add, *super]
      end

      # Example: [:subtract, [:lit, 5], [:lit, 2]]
      def visit_SubtractNode(o)
        [:subtract, *super]
      end

      # Example: [:lshift, [:lit, 2], [:lit, 3]]
      def visit_LeftShiftNode(o)
        [:lshift, *super]
      end

      # Example: [:rshift, [:lit, 8], [:lit, 2]]
      def visit_RightShiftNode(o)
        [:rshift, *super]
      end

      # Example: [:bitwise_and, [:lit, 4], [:lit, 2]]
      def visit_BitwiseAndNode(o)
        [:bitwise_and, *super]
      end

      # Example: [:bitwise_xor, [:lit, 4], [:lit, 2]]
      def visit_BitwiseXorNode(o)
        [:bitwise_xor, *super]
      end

      # Example: [:bitwise_or, [:lit, 4], [:lit, 2]]
      def visit_BitwiseOrNode(o)
        [:bitwise_or, *super]
      end

      # Example: [:resolve, "x"]
      def visit_ResolveNode(o)
        [:resolve, o.value]
      end
    end
  end
end
