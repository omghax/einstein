require "einstein/token"

module Einstein
  class Lexeme
    def initialize(name, pattern, &block)
      @name    = name
      @pattern = pattern
      @block   = block
    end

    attr_reader :name
    attr_reader :pattern

    def match(string)
      match = pattern.match(string)
      return Token.new(name, match.to_s, &@block) if match
      match
    end
  end
end
