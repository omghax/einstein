class Einstein::Parser

macro

# whitespace
  WS          \s+

# numerics
  BINARY      0[bB][01]+
  HEXADECIMAL 0[xX][0-9a-fA-F]+
  OCTAL       0[0-9]+
  INTEGER     [1-9][0-9]*
  FLOAT       [0-9]+\.[0-9]+([eE][\-\+][0-9]+)?

# tokens
  EXPONENT    \*{2}
  LSHIFT      <<
  RSHIFT      >>

# variables
  IDENT       [a-zA-Z_]+

rule

# whitespace (ignored)
  {WS}

# literals
  {BINARY}      { [:NUMBER, text.to_i(2)] }
  {HEXADECIMAL} { [:NUMBER, text.hex] }
  {OCTAL}       { [:NUMBER, text.oct] }
  {FLOAT}       { [:NUMBER, text.to_f] }
  {INTEGER}     { [:NUMBER, text.to_i] }
  {IDENT}       { [:IDENT, text] }

# tokens
  {EXPONENT}    { [:MULT2, text] }
  {LSHIFT}      { [:LSHIFT, text] }
  {RSHIFT}      { [:RSHIFT, text] }

# passthru
  .|\n          { [text, text] }
