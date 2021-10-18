# frozen_string_literal: true

module Monkey
  # The atom of the Monkey programing language.
  #
  # A contiguous sequence of characters that collectively
  # have some semantic meaning.
  class Token
    # Construct a new Token object.
    #
    # This is only done by the lexer.
    #
    # @param type [Symbol] the category of this token
    # @param literal [String] the text representing this token
    def initialize(type, literal)
      @type = type
      @literal = literal
    end

    # the token's category
    attr_reader :type
    # the text representing this token
    attr_reader :literal

    class << self
      # Valid token types.
      VALUES = %i[
        ILLEGAL
        EOF

        IDENT
        INT

        ASSIGN
        PLUS
        MINUS
        BANG
        ASTERISK
        SLASH

        COMMA
        SEMICOLON

        LT
        GT
        EQ
        NOT_EQ

        LPAREN
        RPAREN
        LBRACE
        RBRACE

        FUNCTION
        LET
        IF
        ELSE
        RETURN
        TRUE
        FALSE
      ]

      # The hash used by {Monkey::Token.lookup_ident} to identify keywords.
      IDENTIFIERS = {
        "fn" => :FUNCTION,
        "let" => :LET,
        "if" => :IF,
        "else" => :ELSE,
        "return" => :RETURN,
        "true" => :TRUE,
        "false" => :FALSE,
      }.freeze
      private_constant :IDENTIFIERS

      # Get the category of the given identifier/keyword.
      def lookup_ident(ident)
        IDENTIFIERS[ident] || :IDENT
      end
    end
  end
end
