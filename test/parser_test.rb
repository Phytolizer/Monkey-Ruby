# frozen_string_literal: true

require "test_helper"
require "monkey/token"
require "monkey/lexer"
require "monkey/ast"
require "monkey/parser"

class ParserTest < Minitest::Test
  def check_let_statement(stmt, name)
    assert_equal stmt.token_literal, "let"
    assert_respond_to stmt, :name
    assert_equal stmt.name.value, name
    assert_equal stmt.name.token_literal, name
  end

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

    assert_equal(program.statements.length, 3)
    t = lambda do |expected_identifier|
      { expected_identifier: expected_identifier }
    end
    tests = [
      t.call("x"),
      t.call("y"),
      t.call("foobar"),
    ]

    tests.each_with_index do |tt, i|
      stmt = program.statements[i]
      check_let_statement(stmt, tt[:expected_identifier])
    end
  end
end
