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

  def check_integer_literal(value, literal)
    assert_respond_to(literal, :value)
    assert_equal(value, literal.value)
    assert_equal(value.to_s, literal.token_literal)
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

  def test_integer_literal_expression
    input = "5;"
    l = Monkey::Lexer.new(input)
    p = Monkey::Parser.new(l)
    program = p.parse_program
    check_parser_errors(p)

    assert_equal(1, program.statements.length)
    stmt = program.statements[0]
    assert_respond_to(stmt, :expression)
    literal = stmt.expression
    assert_respond_to(literal, :value)
    assert_equal(5, literal.value)
    assert_equal("5", literal.token_literal)
  end

  def test_parsing_prefix_expressions
    t = lambda { |input, operator, integer_value|
      {
        input: input,
        operator: operator,
        integer_value: integer_value,
      }
    }

    prefix_tests = [
      t.call("!5;", "!", 5),
      t.call("-15;", "-", 15),
    ]

    prefix_tests.each do |tt|
      l = Monkey::Lexer.new(tt[:input])
      p = Monkey::Parser.new(l)
      program = p.parse_program
      check_parser_errors(p)

      assert_equal(1, program.statements.length)
      stmt = program.statements[0]
      assert_respond_to(stmt, :expression)
      exp = stmt.expression
      assert_respond_to(exp, :operator)
      assert_equal(tt[:operator], exp.operator)
      assert_respond_to(exp, :right)
      check_integer_literal(tt[:integer_value], exp.right)
    end
  end
end
