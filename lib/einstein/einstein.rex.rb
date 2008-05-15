#
# DO NOT MODIFY!!!!
# This file is automatically generated by rex 1.0.0
# from lexical definition file "lib/einstein/einstein.rex".
#

require 'racc/parser'
module Einstein
class Parser < Racc::Parser
  require 'strscan'

  class ScanError < StandardError ; end

  attr_reader :lineno
  attr_reader :filename

  def scan_setup ; end

  def action &block
    yield
  end

  def scan_str( str )
    scan_evaluate  str
    do_parse
  end

  def load_file( filename )
    @filename = filename
    open(filename, "r") do |f|
      scan_evaluate  f.read
    end
  end

  def scan_file( filename )
    load_file  filename
    do_parse
  end

  def next_token
    @rex_tokens.shift
  end

  def scan_evaluate( str )
    scan_setup
    @rex_tokens = []
    @lineno  =  1
    ss = StringScanner.new(str)
    state = nil
    until ss.eos?
      text = ss.peek(1)
      @lineno  +=  1  if text == "\n"
      case state
      when nil
        case
        when (text = ss.scan(/\s+/))
          ;

        when (text = ss.scan(/0[bB][01]+/))
           @rex_tokens.push action { [:NUMBER, text.to_i(2)] }

        when (text = ss.scan(/0[xX][0-9a-fA-F]+/))
           @rex_tokens.push action { [:NUMBER, text.hex] }

        when (text = ss.scan(/0[0-9]+/))
           @rex_tokens.push action { [:NUMBER, text.oct] }

        when (text = ss.scan(/[0-9]+\.[0-9]+([eE][\-\+][0-9]+)?/))
           @rex_tokens.push action { [:NUMBER, text.to_f] }

        when (text = ss.scan(/[1-9][0-9]*/))
           @rex_tokens.push action { [:NUMBER, text.to_i] }

        when (text = ss.scan(/[a-zA-Z_]+/))
           @rex_tokens.push action { [:IDENT, text] }

        when (text = ss.scan(/\*{2}/))
           @rex_tokens.push action { [:MULT2, text] }

        when (text = ss.scan(/<</))
           @rex_tokens.push action { [:LSHIFT, text] }

        when (text = ss.scan(/>>/))
           @rex_tokens.push action { [:RSHIFT, text] }

        when (text = ss.scan(/.|\n/))
           @rex_tokens.push action { [text, text] }

        else
          text = ss.string[ss.pos .. -1]
          raise  ScanError, "can not match: '" + text + "'"
        end  # if

      else
        raise  ScanError, "undefined state: '" + state.to_s + "'"
      end  # case state
    end  # until ss
  end  # def scan_evaluate

end # class
end # module
