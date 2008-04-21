require "einstein/visitable"
require "einstein/visitors"

module Einstein
  module Nodes
    class Node
      include Einstein::Visitable
      include Einstein::Visitors

      def initialize(value)
        @value = value
      end

      attr_accessor :value

      def to_sexp
        SexpVisitor.new.accept(self)
      end
    end

    class SourceElementsNode < Node
    end

    class NumberNode < Node
    end

    class UnaryPlusNode < Node
    end

    class UnaryMinusNode < Node
    end

    class BitwiseNotNode < Node
    end

    class BinaryNode < Node
      def initialize(left, right)
        super(right)
        @left = left
      end

      attr_reader :left
    end

    class MultiplyNode < BinaryNode
    end

    class DivideNode < BinaryNode
    end

    class ModulusNode < BinaryNode
    end

    class AddNode < BinaryNode
    end

    class SubtractNode < BinaryNode
    end

    class LeftShiftNode < BinaryNode
    end

    class RightShiftNode < BinaryNode
    end
  end
end
