$:.unshift File.dirname(__FILE__)

require "einstein/parser"
require "einstein/errors"

# == Basic Usage
# 
# If you're only interested in evaluating expressions, you can simply call
# Einstein.evaluate:
# 
#   Einstein.evaluate("1 + 2 + 3") # => 6
# 
# You can use variables as well, but you must supply their values:
# 
#   Einstein.evaluate("x * 4", :x => 5) # => 20
#   Einstein.evaluate("x + y + z", :x => 3, :y => 4, :z => 5) # => 12
# 
# == Prepared Statements
# 
# If you're going to be performing the same operation over a large set of
# different values, and performance is a concern, you can have Einstein parse
# the expression once beforehand, and return a statement object (technically,
# an instance of Einstein::Nodes::StatementNode).  You can then pass your
# values directly to this statement for much faster processing, rather than
# making Einstein parse the same formula over and over again each time.
# 
#   # This will return a prepared statement.
#   stmt = Einstein.parse("x + y")
# 
#   # You can then evaluate this statement against different inputs.
#   stmt.evaluate(:x => 1, :y => 2) # => 3
#   stmt.evaluate(:x => 25, :y => 30) # => 55
module Einstein
  class << self
    # Parse the given +expression+ and return the AST as
    def parse(expression)
      Parser.new.parse(expression)
    end

    # Evaluate the given +expression+ with the given +scope+.  Any variables
    # used by the +expression+, but undeclared in the +scope+, will cause a
    # Einstein::ResolveError to be raised.
    def evaluate(expression, scope = {})
      parse(expression).evaluate(scope)
    end
  end
end
