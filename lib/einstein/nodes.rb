require "einstein/visitors"

module Einstein
  module Nodes
    # Base class for all Einstein nodes.
    class Node
      include Einstein::Visitors

      # Initializes a new instance of this node with the given +value+.
      def initialize(value)
        @value = value
      end

      # The value of this node.
      attr_accessor :value

      # Implements the visitor pattern by calling a method named
      # visit_SomeNode when visiting a class named SomeNode.  This way we
      # separate the tree traversal logic from the nodes themselves, which
      # makes it easier to modify the visitors, or to add new ones.
      def accept(visitor, &block)
        klass = self.class.ancestors.find do |ancestor|
          visitor.respond_to?("visit_#{ancestor.name.split(/::/)[-1]}")
        end

        if klass
          visitor.send("visit_#{klass.name.split(/::/)[-1]}", self, &block)
        else
          raise "No visitor for '#{self.class}'"
        end
      end

      # Evaluate this node against the given +scope+.  Returns a numeric value
      # calculated by walking the AST with an instance of EvaluateVisitor.
      def evaluate(scope = {})
        EvaluateVisitor.new(scope).accept(self)
      end

      def inspect
        PrettyPrintVisitor.new.accept(self)
      end

      # Returns this node as an s-expression.  Built by walking the AST with
      # an instance of SexpVisitor.
      def to_sexp
        SexpVisitor.new.accept(self)
      end
    end

    # Node representing an entire Einstein statement.  This is the root-level
    # node of the parser.  This node's +value+ is the tree of expressions that
    # make up a single logical statement.
    class StatementNode < Node
    end

    # Node representing a number.  This is a terminal node.
    class NumberNode < Node
    end

    # Node representing a unary + (plus) operation.  Not to be confused with
    # the addition operator, this node is generated when you specify a number
    # with an explicit positive sign.
    # 
    # Example:
    #   # This would generate a UnaryPlusNode with the value 1.25.
    #   +1.25
    class UnaryPlusNode < Node
    end

    # Node representing a unary - (minus) operation.  Not to be confused with
    # the subtraction operator, this node is generated when you specify a
    # negative number.
    #  
    # Example:
    #   # This would generate a UnaryMinusNode with the value 3.3.
    #   -3.3
    class UnaryMinusNode < Node
    end

    # Node representing a bitwise NOT operation.
    class BitwiseNotNode < Node
    end

    # Base class for all binary nodes.  Binary nodes operate on two values.
    class BinaryNode < Node
      # Initializes a new instance of this node with the given +left+ and
      # +right+ values.
      def initialize(left, right)
        super(right)
        @left = left
      end

      # The secondary value given to #initialize.
      attr_reader :left
    end

    # Node representing an exponential raise.  This node's +left+ value is the
    # base, and the +right+ value is the exponent.
    class ExponentNode < BinaryNode
    end

    # Node representing multiplication of two values.
    class MultiplyNode < BinaryNode
    end

    # Node representing division of two values.
    class DivideNode < BinaryNode
    end

    # Node representing modulus of two values.
    class ModulusNode < BinaryNode
    end

    # Node representing addition of two nodes.
    class AddNode < BinaryNode
    end

    # Node representing subtraction of two nodes.
    class SubtractNode < BinaryNode
    end

    # Node representing an LSHIFT (left shift) operation.  This node's +left+
    # value is the number to be shifted, and the +right+ value is the number
    # of bits to shift the value by.
    class LeftShiftNode < BinaryNode
    end

    # Node representing an RSHIFT (right shift) operation.  This node's +left+
    # value is the number to be shifted, and the +right+ value is the number
    # of bits to shift the value by.
    class RightShiftNode < BinaryNode
    end

    # Node representing a bitwise AND operation.
    class BitwiseAndNode < BinaryNode
    end

    # Node representing a bitwise XOR operation.
    class BitwiseXorNode < BinaryNode
    end

    # Node representing a bitwise OR operation.
    class BitwiseOrNode < BinaryNode
    end

    # Node representing a variable lookup.  This node's +value+ is the
    # variable's name, as a string.
    class ResolveNode < Node
    end
  end
end
