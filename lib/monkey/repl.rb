# frozen_string_literal: true

require_relative "lexer"
require_relative "token"

module Monkey
  # An interactive method for experimenting with Monkey.
  module REPL
    # The prompt to use for the REPL.
    PROMPT = ">> "

    # Start a REPL session with the given input and output streams.
    #
    # @param in_stream [IO] the input stream to use
    # @param out_stream [IO] the output stream to use
    def self.start(in_stream, out_stream)
      loop do
        out_stream.write(PROMPT)
        out_stream.flush
        line = in_stream.gets
        break if line.nil?

        l = Lexer.new(line)
        tok = l.next_token
        while tok.type != Token::EOF
          puts "{Type:#{tok.type} Literal:#{tok.literal}}"
          tok = l.next_token
        end
      end
    end
  end
end
