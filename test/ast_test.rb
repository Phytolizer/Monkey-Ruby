# frozen_string_literal: true

require "test_helper"
require "monkey/ast"
require "monkey/token"

class AstTest < Minitest::Test
  def test_string
    program = Monkey::AST::Program.new(
      [
        Monkey::AST::LetStatement.new(
          Monkey::Token.new(:LET, "let"),
          Monkey::AST::Identifier.new(
            Monkey::Token.new(:IDENT, "myVar"),
            "myVar"
          ),
          Monkey::AST::Identifier.new(
            Monkey::Token.new(:IDENT, "anotherVar"),
            "anotherVar"
          )
        ),
      ]
    )

    assert_equal("let myVar = anotherVar;", program.string)
  end
end
