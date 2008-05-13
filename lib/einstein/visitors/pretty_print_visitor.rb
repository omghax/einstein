require 'einstein/visitor'

module Einstein
  # This visitor walks the AST and builds a "pretty print" of the values.
  # This means that it returns an unambiguous string representation of the
  # tree.  All binary expressions are wrapped in parentheses.  This visitor
  # is used when calling #inspect on a node.
  class PrettyPrintVisitor < Visitor
    # Example: 4
    def visit_NumberNode(o)
      o.value.inspect
    end

    # Example: +4
    def visit_UnaryPlusNode(o)
      "+#{accept(o.value)}"
    end

    # Example: -4
    def visit_UnaryMinusNode(o)
      "-#{accept(o.value)}"
    end

    # Example: ~4
    def visit_BitwiseNotNode(o)
      "~#{accept(o.value)}"
    end

    # Example: (2 ** 3)
    def visit_ExponentNode(o)
      "(#{accept(o.left)} ** #{accept(o.value)})"
    end

    # Example: (2 * 3)
    def visit_MultiplyNode(o)
      "(#{accept(o.left)} * #{accept(o.value)})"
    end

    # Example: (6 / 3)
    def visit_DivideNode(o)
      "(#{accept(o.left)} / #{accept(o.value)})"
    end

    # Example: (7 % 3)
    def visit_ModulusNode(o)
      "(#{accept(o.left)} % #{accept(o.value)})"
    end

    # Example: (5 + 8)
    def visit_AddNode(o)
      "(#{accept(o.left)} + #{accept(o.value)})"
    end

    # Example: (6 - 3)
    def visit_SubtractNode(o)
      "(#{accept(o.left)} - #{accept(o.value)})"
    end

    # Example: (8 << 2)
    def visit_LeftShiftNode(o)
      "(#{accept(o.left)} << #{accept(o.value)})"
    end

    # Example: (8 >> 2)
    def visit_RightShiftNode(o)
      "(#{accept(o.left)} >> #{accept(o.value)})"
    end

    # Example: (4 & 16)
    def visit_BitwiseAndNode(o)
      "(#{accept(o.left)} & #{accept(o.value)})"
    end

    # Example: (4 ^ 6)
    def visit_BitwiseXorNode(o)
      "(#{accept(o.left)} ^ #{accept(o.value)})"
    end

    # Example: (4 | 6)
    def visit_BitwiseOrNode(o)
      "(#{accept(o.left)} | #{accept(o.value)})"
    end

    # Example: x
    def visit_ResolveNode(o)
      o.value
    end
  end
end
