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
        define_method(:"visit_#{type}Node") do |o|
          [o.left && o.left.accept(self), o.value && o.value.accept(self)]
        end
      end

      SINGLE_VALUE_NODES.each do |type|
        define_method(:"visit_#{type}Node") do |o|
          o.value.accept(self)
        end
      end
    end

    class EvaluateVisitor < Visitor
      def initialize(scope)
        super()
        @scope = scope
      end

      def visit_NumberNode(o)
        o.value
      end

      def visit_UnaryPlusNode(o)
        o.value.accept(self)
      end

      def visit_UnaryMinusNode(o)
        -o.value.accept(self)
      end

      def visit_ExponentNode(o)
        o.left.accept(self) ** o.value.accept(self)
      end

      def visit_MultiplyNode(o)
        o.left.accept(self) * o.value.accept(self)
      end

      def visit_DivideNode(o)
        dividend = o.value.accept(self)
        raise ZeroDivisionError, "divided by zero" if dividend == 0
        o.left.accept(self) / dividend
      end

      def visit_ModulusNode(o)
        o.left.accept(self) % o.value.accept(self)
      end

      def visit_AddNode(o)
        o.left.accept(self) + o.value.accept(self)
      end

      def visit_SubtractNode(o)
        o.left.accept(self) - o.value.accept(self)
      end

      def visit_BitwiseAndNode(o)
        o.left.accept(self) & o.value.accept(self)
      end

      def visit_BitwiseXorNode(o)
        o.left.accept(self) ^ o.value.accept(self)
      end

      def visit_BitwiseOrNode(o)
        o.left.accept(self) | o.value.accept(self)
      end

      def visit_ResolveNode(o)
        raise ResolveError, "undefined variable: #{o.value}" unless @scope.has_key?(o.value.to_sym)
        @scope[o.value.to_sym]
      end
    end

    class SexpVisitor < Visitor
      def visit_NumberNode(o)
        [:lit, o.value]
      end

      def visit_UnaryPlusNode(o)
        [:u_plus, super]
      end
      
      def visit_UnaryMinusNode(o)
        [:u_minus, super]
      end

      def visit_BitwiseNotNode(o)
        [:bitwise_not, super]
      end

      def visit_ExponentNode(o)
        [:raise, *super]
      end

      def visit_MultiplyNode(o)
        [:multiply, *super]
      end

      def visit_DivideNode(o)
        [:divide, *super]
      end

      def visit_ModulusNode(o)
        [:modulus, *super]
      end

      def visit_AddNode(o)
        [:add, *super]
      end

      def visit_SubtractNode(o)
        [:subtract, *super]
      end

      def visit_LeftShiftNode(o)
        [:lshift, *super]
      end

      def visit_RightShiftNode(o)
        [:rshift, *super]
      end

      def visit_BitwiseAndNode(o)
        [:bitwise_and, *super]
      end

      def visit_BitwiseXorNode(o)
        [:bitwise_xor, *super]
      end

      def visit_BitwiseOrNode(o)
        [:bitwise_or, *super]
      end

      def visit_ResolveNode(o)
        [:resolve, o.value]
      end
    end
  end
end
