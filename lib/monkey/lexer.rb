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
      @ch = peek_char
      @position = @read_position
      @read_position += 1
    end

    def peek_char
      if @read_position >= @input.length
        "\x0"
      else
        @input[@read_position]
      end
    end

    def read_identifier
      position = @position
      read_char while @ch =~ /[a-zA-Z_]/
      @input[position...@position]
    end

    def read_number
      position = @position
      read_char while @ch =~ /[0-9]/
      @input[position...@position]
    end

    def skip_whitespace
      read_char while @ch =~ /[ \t\r\n]/
    end

    public

    # Obtain the next token from the original input.
    #
    # This should be called repeatedly until it returns
    # a token with type equal to {Monkey::Token::EOF}, as ignoring
    # that special token will result in an infinite loop.
    def next_token
      skip_whitespace

      tok = case @ch
            when "="
              if peek_char == "="
                last_ch = @ch
                read_char
                Token.new(Token::EQ, last_ch + @ch)
              else
                Token.new(Token::ASSIGN, @ch)
              end
            when "!"
              if peek_char == "="
                last_ch = @ch
                read_char
                Token.new(Token::NOT_EQ, last_ch + @ch)
              else
                Token.new(Token::BANG, @ch)
              end
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
            when "-"
              Token.new(Token::MINUS, @ch)
            when "*"
              Token.new(Token::ASTERISK, @ch)
            when "/"
              Token.new(Token::SLASH, @ch)
            when "<"
              Token.new(Token::LT, @ch)
            when ">"
              Token.new(Token::GT, @ch)
            when "\x0"
              Token.new(Token::EOF, "")
            when proc(&->(ch) { ch =~ /[a-zA-Z_]/ })
              literal = read_identifier
              type = Token.lookup_ident(literal)
              return Token.new(type, literal)
            when proc(&->(ch) { ch =~ /[0-9]/ })
              literal = read_number
              return Token.new(Token::INT, literal)
            else
              Token.new(Token::ILLEGAL, @ch)
            end

      read_char
      tok
    end
  end
end
