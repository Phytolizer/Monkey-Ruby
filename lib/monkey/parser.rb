# frozen_string_literal: true

module Monkey
  # The Monkey parser. Converts the {Lexer}'s tokens into a tree representation.
  class Parser
    # Initialize the parser. It will use the provided lexer.
    #
    # @param [Lexer] lexer the lexer providing tokens
    def initialize(lexer)
      @l = lexer
      @cur_token = nil
      @peek_token = nil

      next_token
      next_token
    end

    private

    def next_token
      @cur_token = @peek_token
      @peek_token = @l.next_token
    end

    public

    # Execute the parser.
    #
    # @return [AST::Program] the result of parsing
    def parse_program
      nil
    end
  end
end
