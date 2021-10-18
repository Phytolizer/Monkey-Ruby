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

    # An illegal character in the input.
    #
    # The parser will always error when attempting to
    # parse this token.
    ILLEGAL = :ILLEGAL
    # The end of file.
    #
    # This is a token for convenience in the parser implementation.
    EOF = :EOF

    # Identifiers, literals

    # An identifier.
    #
    # `add`, `foobar`, `x`, `y`, ...
    IDENT = :IDENT
    # An integer literal.
    #
    # `12324325325`
    INT = :INT

    # The assignment operator.
    #
    # `=`
    ASSIGN = :ASSIGN
    # The addition operator.
    #
    # `+`
    PLUS = :PLUS

    # A delimiter for argument lists.
    #
    # `,`
    COMMA = :COMMA
    # A delimiter for lines.
    #
    # `;`
    SEMICOLON = :SEMICOLON

    # A left parenthesis, for grouping and parameter lists.
    #
    # `(`
    LPAREN = :LPAREN
    # A right parenthesis, for grouping and closing parameter lists.
    #
    # `)`
    RPAREN = :RPAREN
    # A left brace, for code blocks.
    #
    # `{`
    LBRACE = :LBRACE
    # A right brace, for closing code blocks.
    #
    # `}`
    RBRACE = :RBRACE

    # Keywords

    # The "function" keyword. Begins a function expression.
    #
    # `fn`
    FUNCTION = :FUNCTION
    # The "let" keyword. Begins a variable declaration.
    #
    # `let`
    LET = :LET

    class << self
      IDENTIFIERS = {
        "fn" => Token::FUNCTION,
        "let" => Token::LET,
      }.freeze

      # Get the category of the given identifier/keyword.
      def lookup_ident(ident)
        IDENTIFIERS[ident] || Token::IDENT
      end
    end
  end
end
