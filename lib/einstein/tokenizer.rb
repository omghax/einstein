module Einstein
  class Token
    # The default transformer used by instances of Token when no block is
    # given to #initialize.
    DEFAULT_TRANSFORMER = lambda { |name, value| [name, value] }

    def initialize(name, value, &transformer)
      @name = name
      @value = value
      @transformer = transformer || DEFAULT_TRANSFORMER
    end

    # This token's name (eg. :NUMBER, :IDENT).
    attr_accessor :name

    # This token's value (eg. 1, "x").
    attr_accessor :value

    # The block given to this token's #initialize method.  This block is
    # called by #to_racc_token.
    attr_accessor :transformer

    # Converts this token to a format that Racc expects.  This is an array of
    # the format [name, value].
    # 
    # Examples:
    #   [:NUMBER, 2.20]
    #   [:IDENT, "x"]
    def to_racc_token
      @transformer.call(name, value)
    end
  end

  class Lexeme
    def initialize(name, pattern, &block)
      @name = name
      @pattern = pattern
      @block = block
    end

    def match(string)
      match = @pattern.match(string)
      return Token.new(@name, match.to_s, &@block) if match
      match
    end
  end

  class Tokenizer
    LITERALS = {
      # Punctuators
      "**" => :RAISE,
      "<<" => :LSHIFT,
      ">>" => :RSHIFT
    }

    def initialize(&block)
      @lexemes = []

      token(:COMMENT, /\A\/(?:\*(?:.)*?\*\/|\/[^\n]*)/m)

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

      token(:LITERALS,
        Regexp.new(LITERALS.keys.sort_by { |x| x.length }.reverse.map { |x| "\\A#{x.gsub(/([|+*^])/, '\\\\\1')}" }.join('|')
      )) do |type, value|
        [LITERALS[value], value]
      end

      token(:IDENT, /\A(\w|\$)+/)

      token(:WS, /\A[\s\r\n]*/m)

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
