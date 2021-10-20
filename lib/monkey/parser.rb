# frozen_string_literal: true

require_relative "ast"
require_relative "token"

module Monkey
  PRECEDENCES = {
    LOWEST: 0,
    EQUALS: 1,
    LESSGREATER: 2,
    SUM: 3,
    PRODUCT: 4,
    PREFIX: 5,
    CALL: 6,
  }.freeze
  private_constant :PRECEDENCES

  # The Monkey parser. Converts the {Lexer}'s tokens into a tree representation.
  class Parser
    # Initialize the parser. It will use the provided lexer.
    #
    # @param [Lexer] lexer the lexer providing tokens
    def initialize(lexer)
      @l = lexer
      @cur_token = nil
      @peek_token = nil
      @errors = []
      @prefix_parse_fns = {
        IDENT: -> { parse_identifier },
        INT: -> { parse_integer_literal },
      }.freeze
      @infix_parse_fns = {}.freeze

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
        peek_error(type)
        false
      end
    end

    def peek_error(type)
      @errors.push("expected next token to be #{type}, got #{@cur_token.type} instead")
    end

    def parse_statement
      case @cur_token.type
      when Token::LET
        parse_let_statement
      when Token::RETURN
        parse_return_statement
      else
        parse_expression_statement
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

    def parse_return_statement
      token = @cur_token

      next_token

      # TODO
      next_token until cur_token_is(Token::SEMICOLON)

      AST::ReturnStatement.new(token, nil)
    end

    def parse_expression_statement
      token = @cur_token

      expression = parse_expression(:LOWEST)

      next_token if peek_token_is(:SEMICOLON)

      AST::ExpressionStatement.new(token, expression)
    end

    def parse_expression(_precedence)
      prefix = @prefix_parse_fns[@cur_token.type]
      return nil if prefix.nil?

      prefix.call
    end

    def parse_identifier
      AST::Identifier.new(@cur_token, @cur_token.literal)
    end

    def parse_integer_literal
      token = @cur_token

      value = @cur_token.literal.to_i

      AST::IntegerLiteral.new(token, value)
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

    attr_reader :errors
  end
end
