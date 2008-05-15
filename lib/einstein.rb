# Add ./lib to the load path.
$:.unshift File.dirname(__FILE__)
require 'einstein/einstein.racc.rb'
require 'einstein/einstein.rex.rb'
require 'einstein/expression'

module Einstein
  # Raised when an undefined variable is referenced.
  class ResolveError < StandardError # :nodoc:
  end

  # Parse the given +expression+ and return the AST as an instance of
  # Einstein::Expression.
  def self.parse(expression)
    Expression.new(Parser.new.scan_str(expression))
  end

  # Evaluate the given +expression+ with the given +scope+.  Any variables
  # used by the +expression+, but undeclared in the +scope+, will cause a
  # Einstein::ResolveError to be raised.
  def self.evaluate(expression, scope = {})
    parse(expression).evaluate(scope)
  end
end
