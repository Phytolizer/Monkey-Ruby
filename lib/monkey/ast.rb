# frozen_string_literal: true

module Monkey
  # The Monkey AST (abstract syntax tree).
  module AST
    # A generic node of the tree.
    class Node
      # Get a "token-literal" from this AST node.
      #
      # Usually this is the defining token of the construct.
      # @abstract
      # @return [String] the "token-literal"
      def token_literal
        raise "Unimplemented abstract method"
      end

      # Get a string representation of this AST node (and all
      # of its children).
      #
      # @abstract
      # @return [String] the string representation
      def to_s
        raise "Unimplemented abstract method"
      end
    end

    # A more specific node of the tree.
    #
    # Statement nodes typically have side effects
    # and do not resolve to a value.
    class Statement < Node; end

    # A more specific node of the tree.
    #
    # Expression nodes typically do not have side effects
    # and resolve to a value.
    class Expression < Node; end

    # The root of the tree.
    #
    # Represents the entire input file (or REPL line).
    class Program < Node
      # Create a program from the given statements.
      #
      # @param [Array<Statement>] statements the contents of the program
      def initialize(statements)
        super()
        @statements = statements
      end

      # The statements which make up the program.
      # @return [Array<Statement>]
      attr_reader :statements

      # Gets the "token-literal" of the program.
      #
      # It is defined as the "token-literal" of the first statement.
      # @return [String] the "token-literal"
      def token_literal
        if @statements.empty?
          ""
        else
          @statements[0].token_literal
        end
      end

      # Get the string representation of the program.
      #
      # Sequential statements are concatenated.
      def string
        result = +""

        @statements.each do |s|
          result += s.string
        end

        result
      end
    end

    # A let statement.
    #
    # `let x = true`
    class LetStatement < Statement
      # Construct the let statement.
      #
      # @param [Token] token the "let" token
      # @param [Identifier] name the name being defined
      # @param [Expression] value the value being assigned
      def initialize(token, name, value)
        super()
        @token = token
        @name = name
        @value = value
      end

      # The "let" token.
      attr_reader :token
      # The name being defined.
      attr_reader :name
      # The value being assigned.
      attr_reader :value

      # Get the "let" token's literal.
      #
      # It should always return the string `"let"`.
      def token_literal
        @token.literal
      end

      # Get a string representation of the let statement.
      #
      # This will look very similar to the original text.
      def string
        result = +"#{token_literal} "
        result += @name.string
        result += " = "
        result += @value.string unless @value.nil?
        result += ";"
        result
      end
    end

    # A single identifier.
    #
    # `apple`
    class Identifier
      # Construct the identifier.
      #
      # @param [Token] token the identifier's token
      # @param [String] value the text of the identifier
      def initialize(token, value)
        super()
        @token = token
        @value = value
      end

      # The identifier token.
      attr_reader :token
      # The identifier's text.
      attr_reader :value

      # Get the identifier's "token-literal".
      def token_literal
        @token.literal
      end

      # Get the string of the identifier.
      def string
        @value
      end
    end

    # A return statement.
    #
    # `return true;`
    class ReturnStatement < Statement
      # Construct the return statement.
      #
      # @param [Token] token the "return" token
      # @param [Expression] return_value the return value
      def initialize(token, return_value)
        super()
        @token = token
        @return_value = return_value
      end

      # The "return" token.
      attr_reader :token
      # The return value.
      attr_reader :value

      # Get the return statement's "token-literal".
      def token_literal
        @token.literal
      end

      # Get a string representing the return statement.
      #
      # This will look very similar to the original program text.
      def string
        result = +"#{token_literal} "
        result += @return_value.string unless @return_value.nil?
        result += ";"
        result
      end
    end

    # An expression statement.
    #
    # Uses an expression entirely for its side effects and
    # discards the value.
    class ExpressionStatement < Statement
      # Construct the expression statement.
      #
      # @param [Token] token the first token of the expression
      # @param [Expression] expression the expression
      def initialize(token, expression)
        super()
        @token = token
        @expression = expression
      end

      attr_reader :token, :expression

      # Get the expression statement's "token-literal".
      def token_literal
        @token.literal
      end

      # Get the expression's string representation.
      def string
        if @expression.nil?
          ""
        else
          @expression.string
        end
      end
    end

    # An integer literal.
    #
    # `5`
    class IntegerLiteral < Expression
      # Construct the integer literal.
      #
      # @param [Token] token the token making up the literal
      # @param [Integer] value the integer value
      def initialize(token, value)
        super()
        @token = token
        @value = value
      end

      attr_reader :token, :value

      # Get the integer literal's "token-literal".
      def token_literal
        @token.literal
      end

      # Get the integer literal's string representation.
      def string
        @token.literal
      end
    end
  end
end
