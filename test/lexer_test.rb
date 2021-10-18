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
      !-/*5;
      5 < 10 > 5;

      if (5 < 10) {
        return true;
      } else {
        return false;
      }

      10 == 10;
      10 != 9;
    TEST_INPUT
  end

  def next_token_tests
    t = lambda do |expected_type, expected_literal|
      { expected_type: expected_type, expected_literal: expected_literal }
    end

    [
      t.call(:LET, "let"),
      t.call(:IDENT, "five"),
      t.call(:ASSIGN, "="),
      t.call(:INT, "5"),
      t.call(:SEMICOLON, ";"),
      t.call(:LET, "let"),
      t.call(:IDENT, "ten"),
      t.call(:ASSIGN, "="),
      t.call(:INT, "10"),
      t.call(:SEMICOLON, ";"),
      t.call(:LET, "let"),
      t.call(:IDENT, "add"),
      t.call(:ASSIGN, "="),
      t.call(:FUNCTION, "fn"),
      t.call(:LPAREN, "("),
      t.call(:IDENT, "x"),
      t.call(:COMMA, ","),
      t.call(:IDENT, "y"),
      t.call(:RPAREN, ")"),
      t.call(:LBRACE, "{"),
      t.call(:IDENT, "x"),
      t.call(:PLUS, "+"),
      t.call(:IDENT, "y"),
      t.call(:SEMICOLON, ";"),
      t.call(:RBRACE, "}"),
      t.call(:SEMICOLON, ";"),
      t.call(:LET, "let"),
      t.call(:IDENT, "result"),
      t.call(:ASSIGN, "="),
      t.call(:IDENT, "add"),
      t.call(:LPAREN, "("),
      t.call(:IDENT, "five"),
      t.call(:COMMA, ","),
      t.call(:IDENT, "ten"),
      t.call(:RPAREN, ")"),
      t.call(:SEMICOLON, ";"),
      t.call(:BANG, "!"),
      t.call(:MINUS, "-"),
      t.call(:SLASH, "/"),
      t.call(:ASTERISK, "*"),
      t.call(:INT, "5"),
      t.call(:SEMICOLON, ";"),
      t.call(:INT, "5"),
      t.call(:LT, "<"),
      t.call(:INT, "10"),
      t.call(:GT, ">"),
      t.call(:INT, "5"),
      t.call(:SEMICOLON, ";"),
      t.call(:IF, "if"),
      t.call(:LPAREN, "("),
      t.call(:INT, "5"),
      t.call(:LT, "<"),
      t.call(:INT, "10"),
      t.call(:RPAREN, ")"),
      t.call(:LBRACE, "{"),
      t.call(:RETURN, "return"),
      t.call(:TRUE, "true"),
      t.call(:SEMICOLON, ";"),
      t.call(:RBRACE, "}"),
      t.call(:ELSE, "else"),
      t.call(:LBRACE, "{"),
      t.call(:RETURN, "return"),
      t.call(:FALSE, "false"),
      t.call(:SEMICOLON, ";"),
      t.call(:RBRACE, "}"),
      t.call(:INT, "10"),
      t.call(:EQ, "=="),
      t.call(:INT, "10"),
      t.call(:SEMICOLON, ";"),
      t.call(:INT, "10"),
      t.call(:NOT_EQ, "!="),
      t.call(:INT, "9"),
      t.call(:SEMICOLON, ";"),
      t.call(:EOF, ""),
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
