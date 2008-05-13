require 'einstein/visitor'

module Einstein
  module Visitors
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
