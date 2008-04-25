$:.unshift File.dirname(__FILE__)

require "einstein/parser"
require "einstein/errors"

module Einstein
  class << self
    def parse(expression)
      Parser.new.parse(expression)
    end

    def evaluate(expression, scope = {})
      parse(expression).evaluate(scope)
    end

    def sexp(expression)
      parse(expression).to_sexp
    end
  end
end
