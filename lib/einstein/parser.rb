require "einstein/generated_parser"
require "einstein/tokenizer"

module Einstein
  class Parser < GeneratedParser
    # Tokenizer instance that is shared between instances of Parser.
    TOKENIZER = Tokenizer.new

    def initialize
      @tokens = []
      @logger = nil
      @terminator = false
    end

    # Logger object to receive debugging information when a parsing error
    # occurs.  If this is nil, no information will be output.
    attr_accessor :logger

    # Parses the given +expression+ using TOKENIZER, and returns an instance
    # of StatementNode, which represents an AST.  You can take this AST and
    # perform evaluations on it using #evaluate, or transform it into an
    # s-expression using #to_sexp.
    # 
    # Example:
    #   # Parse the expression "x + 3".
    #   ast = Einstein::Parser.new.parse("x + 3")
    # 
    #   # Evaluate the expression with a given scope.
    #   ast.evaluate(:x => 5) # => 8
    # 
    #   # Return the expression as an s-expression.
    #   ast.to_sexp # => [:add, [:resolve, "x"], [:lit, 3]]
    def parse(expression)
      @tokens = TOKENIZER.tokenize(expression)
      @position = 0
      StatementNode.new(do_parse)
    end

    private

    def on_error(error_token_id, error_value, value_stack)
      if logger
        logger.error(token_to_str(error_token_id))
        logger.error("error value: #{error_value}")
        logger.error("error stack: #{value_stack.inspect}")
      end
      super
    end

    # Used by Racc::Parser to step through tokens.
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
