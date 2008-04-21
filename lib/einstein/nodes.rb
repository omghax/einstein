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
  end
end
