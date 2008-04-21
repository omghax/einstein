require "einstein/lexeme"

module Einstein
  class Tokenizer
    def initialize(&block)
      @lexemes = []

      # A regexp to match floating point literals (but not integer literals).
      token(:NUMBER, /\A\d+\.\d*(?:[eE][-+]?\d+)?|\A\d+(?:\.\d*)?[eE][-+]?\d+|\A\.\d+(?:[eE][-+]?\d+)?/m) do |type, value|
        value.gsub!(/\.(\D)/, '.0\1') if value =~ /\.\w/
        value.gsub!(/\.$/, '.0') if value =~ /\.$/
        value.gsub!(/^\./, '0.') if value =~ /^\./
        [type, eval(value)]
      end
      token(:NUMBER, /\A0[bBxX][\da-fA-F]+|\A0[0-7]*|\A\d+/) do |type, value|
        [type, eval(value)]
      end

      token(:SINGLE_CHAR, /\A./) do |type, value|
        [value, value]
      end
    end

    def tokenize(string)
      tokens = []
      while string.length > 0
        longest_token = nil

        @lexemes.each { |lexeme|
          match = lexeme.match(string)
          next if match.nil?
          longest_token = match if longest_token.nil?
          next if longest_token.value.length >= match.value.length
          longest_token = match
        }

        string = string.slice(Range.new(longest_token.value.length, -1))
        tokens << longest_token
      end
      tokens.map { |x| x.to_racc_token }
    end

    private

    def token(name, pattern = nil, &block)
      @lexemes << Lexeme.new(name, pattern, &block)
    end
  end
end
