module Einstein
  class Visitor
    # Terminal types (numbers, variables, etc.).
    TERMINAL_NODES = %w{
      Number
      Resolve
    }

    # Define a visit_xNode method for each terminal node type.
    TERMINAL_NODES.each do |type|
      define_method("visit_#{type}Node") { |o| }
    end

    # Nodes that take a single value.
    SINGLE_VALUE_NODES = %w{
      BitwiseNot
      Statement
      UnaryMinus
      UnaryPlus
    }

    # Define a visit_xNode method for each single-value node type.
    SINGLE_VALUE_NODES.each do |type|
      define_method("visit_#{type}Node") { |o| accept(o.value) }
    end

    # Nodes that take two values.
    BINARY_NODES = %w{
      Add
      BitwiseAnd
      BitwiseOr
      BitwiseXor
      Divide
      Exponent
      LeftShift
      Modulus
      Multiply
      RightShift
      Subtract
    }

    # Define a visit_xNode method for each binary node type.
    BINARY_NODES.each do |type|
      define_method("visit_#{type}Node") { |o| [accept(o.left), accept(o.right)] }
    end

    # Visits the given +target+ by calling its #accept method on this visitor.
    def accept(target)
      target.accept(self)
    end
  end
end
