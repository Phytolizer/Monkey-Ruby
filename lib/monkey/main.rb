# frozen_string_literal: true

require_relative "repl"

user = ENV["USERNAME"] || `whoami`.chomp

puts <<~WELCOME
  Hello #{user}! This is the Monkey programming language!
  Feel free to type in commands
WELCOME

Monkey::REPL.start($stdin, $stdout)
