require "einstein/generated_parser"
require "einstein/tokenizer"

module Einstein
  class Parser < GeneratedParser
    TOKENIZER = Tokenizer.new

    def initialize
      @tokens = []
      @logger = nil
      @terminator = false
    end

    attr_accessor :logger

    def parse(str)
      @tokens = TOKENIZER.tokenize(str)
      @position = 0
      SourceElementsNode.new([do_parse].flatten)
    end

    private

    def next_token
      return [false, false] if @position >= @tokens.length
      n_token = @tokens[@position]
      @position += 1
      n_token
    end
  end
end
