# frozen_string_literal: true

require "test_helper"
require "monkey/token"
require "monkey/lexer"

class LexerTest < MiniTest::Test
  def next_token_input
    <<~TEST_INPUT
      let five = 5;
      let ten = 10;

      let add = fn(x, y) {
        x + y;
      };

      let result = add(five, ten);
    TEST_INPUT
  end

  def next_token_tests
    t = lambda do |expected_type, expected_literal|
      { expected_type: expected_type, expected_literal: expected_literal }
    end

    [
      t.call(Monkey::Token::LET, "let"),
      t.call(Monkey::Token::IDENT, "five"),
      t.call(Monkey::Token::ASSIGN, "="),
      t.call(Monkey::Token::INT, "5"),
      t.call(Monkey::Token::SEMICOLON, ";"),
      t.call(Monkey::Token::LET, "let"),
      t.call(Monkey::Token::IDENT, "ten"),
      t.call(Monkey::Token::ASSIGN, "="),
      t.call(Monkey::Token::INT, "10"),
      t.call(Monkey::Token::SEMICOLON, ";"),
      t.call(Monkey::Token::LET, "let"),
      t.call(Monkey::Token::IDENT, "add"),
      t.call(Monkey::Token::ASSIGN, "="),
      t.call(Monkey::Token::FUNCTION, "fn"),
      t.call(Monkey::Token::LPAREN, "("),
      t.call(Monkey::Token::IDENT, "x"),
      t.call(Monkey::Token::COMMA, ","),
      t.call(Monkey::Token::IDENT, "y"),
      t.call(Monkey::Token::RPAREN, ")"),
      t.call(Monkey::Token::LBRACE, "{"),
      t.call(Monkey::Token::IDENT, "x"),
      t.call(Monkey::Token::PLUS, "+"),
      t.call(Monkey::Token::IDENT, "y"),
      t.call(Monkey::Token::SEMICOLON, ";"),
      t.call(Monkey::Token::RBRACE, "}"),
      t.call(Monkey::Token::SEMICOLON, ";"),
      t.call(Monkey::Token::LET, "let"),
      t.call(Monkey::Token::IDENT, "result"),
      t.call(Monkey::Token::ASSIGN, "="),
      t.call(Monkey::Token::IDENT, "add"),
      t.call(Monkey::Token::LPAREN, "("),
      t.call(Monkey::Token::IDENT, "five"),
      t.call(Monkey::Token::COMMA, ","),
      t.call(Monkey::Token::IDENT, "ten"),
      t.call(Monkey::Token::RPAREN, ")"),
      t.call(Monkey::Token::SEMICOLON, ";"),
      t.call(Monkey::Token::EOF, ""),
    ]
  end

  def test_next_token
    input = next_token_input
    tests = next_token_tests

    l = Monkey::Lexer.new(input)

    tests.each_with_index do |tt, i|
      tok = l.next_token

      if tok.type != tt[:expected_type]
        flunk(%(tests[#{i}] - tokentype wrong. want="#{tt[:expected_type]}", got="#{tok.type}"))
      end

      if tok.literal != tt[:expected_literal]
        flunk(%(tests[#{i}] - literal wrong. want="#{tt[:expected_literal]}", got="#{tok.literal}"))
      end
    end
  end
end
