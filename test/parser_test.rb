# frozen_string_literal: true

require "test_helper"
require "monkey/token"
require "monkey/lexer"
require "monkey/ast"
require "monkey/parser"

class ParserTest < Minitest::Test
  def test_let_statements
    input = <<~TEST_INPUT
      let x = 5;
      let y = 10;
      let foobar = 838383;
    TEST_INPUT

    l = Monkey::Lexer.new(input)
    p = Monkey::Parser.new(l)
    program = p.parse_program
    refute_nil program
  end
end
