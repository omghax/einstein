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

    def on_error(error_token_id, error_value, value_stack)
      if logger
        logger.error(token_to_str(error_token_id))
        logger.error("error value: #{error_value}")
        logger.error("error stack: #{value_stack}")
      end
      super
    end

    def next_token
      begin
        return [false, false] if @position >= @tokens.length
        n_token = @tokens[@position]
        @position += 1
      end while [:COMMENT, :WS].include?(n_token[0])
      n_token
    end
  end
end
