# frozen_string_literal: true

module Monkey
  # The Monkey lexer.
  #
  # Construct this with some text, and repeatedly
  # call {Monkey::Lexer#next_token} to obtain tokens.
  class Lexer
    # Initialize the lexer with the given input.
    #
    # @param input [String] the text that will be lexed
    def initialize(input)
      @input = input
      @position = 0
      @read_position = 0
      @ch = "\x0"

      read_char
    end

    private

    def read_char
      @ch = if @read_position >= @input.length
              "\x0"
            else
              @input[@read_position]
            end
      @position = @read_position
      @read_position += 1
    end

    public

    # Obtain the next token from the original input.
    #
    # This should be called repeatedly until it returns
    # a token with type equal to {Monkey::Token::EOF}, as ignoring
    # that special token will result in an infinite loop.
    def next_token
      tok = case @ch
            when "="
              Token.new(Token::ASSIGN, @ch)
            when ";"
              Token.new(Token::SEMICOLON, @ch)
            when "("
              Token.new(Token::LPAREN, @ch)
            when ")"
              Token.new(Token::RPAREN, @ch)
            when "{"
              Token.new(Token::LBRACE, @ch)
            when "}"
              Token.new(Token::RBRACE, @ch)
            when ","
              Token.new(Token::COMMA, @ch)
            when "+"
              Token.new(Token::PLUS, @ch)
            when "\x0"
              Token.new(Token::EOF, "")
            end

      read_char
      tok
    end
  end
end
