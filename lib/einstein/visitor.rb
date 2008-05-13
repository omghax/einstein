module Einstein
  class Visitor
    TERMINAL_NODES = %w{
      Number Resolve
    }
    SINGLE_VALUE_NODES = %w{
      BitwiseNot Statement UnaryMinus UnaryPlus
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

    SINGLE_VALUE_NODES.each do |type|
      define_method("visit_#{type}Node") do |o|
        o.value.accept(self)
      end
    end

    BINARY_NODES.each do |type|
      define_method("visit_#{type}Node") do |o|
        [o.left && o.left.accept(self), o.value && o.value.accept(self)]
      end
    end
  end
end
