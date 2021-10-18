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
    # The logical not operator.
    #
    # `!`
    BANG = :BANG
    # The subtraction operator.
    #
    # `-`
    MINUS = :MINUS
    # The division operator.
    #
    # `/`
    SLASH = :SLASH
    # The multiplication operator.
    #
    # `*`
    ASTERISK = :ASTERISK

    # Comparisons

    # The less-than operator.
    #
    # `<`
    LT = :LT
    # The greater-than operator.
    #
    # `>`
    GT = :GT

    # Delimiters

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
    # The "if" keyword. Begins an if expression.
    #
    # `if`
    IF = :IF
    # The "else" keyword. Begins an else clause in an if expression.
    #
    # `else`
    ELSE = :ELSE
    # The "return" keyword. Begins a return statement.
    #
    # `return`
    RETURN = :RETURN
    # The "true" keyword. Represents a truth value.
    #
    # `true`
    TRUE = :TRUE
    # The "false" keyword. Represents the opposite of {Monkey::Token::TRUE}.
    #
    # `false`
    FALSE = :FALSE

    # The hash used by {Monkey::Token.lookup_ident} to identify keywords.
    IDENTIFIERS = {
      "fn" => Token::FUNCTION,
      "let" => Token::LET,
      "if" => Token::IF,
      "else" => Token::ELSE,
      "return" => Token::RETURN,
      "true" => Token::TRUE,
      "false" => Token::FALSE,
    }.freeze
    private_constant :IDENTIFIERS

    class << self
      # Get the category of the given identifier/keyword.
      def lookup_ident(ident)
        IDENTIFIERS[ident] || Token::IDENT
      end
    end
  end
end
