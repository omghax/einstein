module Einstein
  module Visitors
    class Visitor
      TERMINAL_NODES = %w{
        Number
      }
      SINGLE_VALUE_NODES = %w{
        BitwiseNot UnaryMinus UnaryPlus
      }
      BINARY_NODES = %w{
        Add Divide LeftShift Modulus Multiply RightShift Subtract
      }
      ARRAY_VALUE_NODES = %w{
        SourceElements
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

      ARRAY_VALUE_NODES.each do |type|
        define_method("visit_#{type}Node") do |o|
          o.value && o.value.map { |v| v ? v.accept(self) : nil }
        end
      end

      SINGLE_VALUE_NODES.each do |type|
        define_method(:"visit_#{type}Node") do |o|
          o.value.accept(self)
        end
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
    end
  end
end
