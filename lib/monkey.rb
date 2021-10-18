# frozen_string_literal: true

require_relative "monkey/version"
require_relative "monkey/token"

# The Monkey programming language is contained within this module.
#
# Typical workflow:
#
# * Construct a {Monkey::Lexer} to tokenize input.
# * Construct a {Monkey::Parser} with that lexer to parse.
# * Call {Monkey::Parser#parse} to obtain a {Monkey::Program}.
#
# To execute the program:
#
# * Call {Monkey::Evaluator::eval}.
module Monkey
end
