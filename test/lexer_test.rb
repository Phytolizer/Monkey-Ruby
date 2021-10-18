# frozen_string_literal: true

require "test_helper"
require "monkey/token"
require "monkey/lexer"

class LexerTest < MiniTest::Test
  def next_token_tests
    t = lambda do |expected_type, expected_literal|
      { expected_type: expected_type, expected_literal: expected_literal }
    end

    [
      t.call(Monkey::Token::ASSIGN, "="),
      t.call(Monkey::Token::PLUS, "+"),
      t.call(Monkey::Token::LPAREN, "("),
      t.call(Monkey::Token::RPAREN, ")"),
      t.call(Monkey::Token::LBRACE, "{"),
      t.call(Monkey::Token::RBRACE, "}"),
      t.call(Monkey::Token::COMMA, ","),
      t.call(Monkey::Token::SEMICOLON, ";"),
    ]
  end

  def test_next_token
    input = "=+(){},;"

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
