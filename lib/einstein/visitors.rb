module Einstein
  module Visitors
    class Visitor
      TERMINAL_NODES = %w{
        Number
      }
      SINGLE_VALUE_NODES = %w{
        UnaryMinus UnaryPlus
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
    end
  end
end
