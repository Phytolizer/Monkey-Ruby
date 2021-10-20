# frozen_string_literal: true

require "test_helper"
require "monkey/token"
require "monkey/lexer"
require "monkey/ast"
require "monkey/parser"

class ParserTest < Minitest::Test
  def check_let_statement(stmt, name)
    assert_equal("let", stmt.token_literal)
    assert_respond_to stmt, :name
    assert_equal(name, stmt.name.value)
    assert_equal(name, stmt.name.token_literal)
  end

  def check_parser_errors(parser)
    assert_empty parser.errors
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
    check_parser_errors(p)

    assert_equal(3, program.statements.length)
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

  def test_return_statements
    input = <<~TEST_INPUT
      return 5;
      return 10;
      return 993322;
    TEST_INPUT

    l = Monkey::Lexer.new(input)
    p = Monkey::Parser.new(l)
    program = p.parse_program
    check_parser_errors(p)

    assert_equal(3, program.statements.length)

    program.statements.each do |stmt|
      assert_equal("return", stmt.token_literal)
    end
  end

  def test_identifier_expression
    input = "foobar;"
    l = Monkey::Lexer.new(input)
    p = Monkey::Parser.new(l)
    program = p.parse_program
    check_parser_errors(p)

    assert_equal(1, program.statements.length)
    stmt = program.statements[0]
    assert_respond_to(stmt, :expression)
    ident = stmt.expression
    assert_respond_to(ident, :value)
    assert_equal("foobar", ident.value)
    assert_equal("foobar", ident.token_literal)
  end
end
