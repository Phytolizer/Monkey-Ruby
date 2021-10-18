# frozen_string_literal: true

require_relative "ast"
require_relative "token"

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

    def cur_token_is(type)
      @cur_token.type == type
    end

    def peek_token_is(type)
      @peek_token.type == type
    end

    def expect_peek(type)
      if peek_token_is(type)
        next_token
        true
      else
        false
      end
    end

    def parse_statement
      case @cur_token.type
      when Token::LET
        parse_let_statement
      end
    end

    def parse_let_statement
      token = @cur_token
      return nil unless expect_peek(Token::IDENT)

      name = AST::Identifier.new(@cur_token, @cur_token.literal)
      return nil unless expect_peek(Token::ASSIGN)

      # TODO
      next_token until cur_token_is(Token::SEMICOLON)

      AST::LetStatement.new(token, name, nil)
    end

    public

    # Execute the parser.
    #
    # @return [AST::Program] the result of parsing
    def parse_program
      statements = []

      while @cur_token.type != Token::EOF
        stmt = parse_statement
        statements.push(stmt) unless stmt.nil?
        next_token
      end

      AST::Program.new(statements)
    end
  end
end
