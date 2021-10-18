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
        super
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
    end
  end
end
