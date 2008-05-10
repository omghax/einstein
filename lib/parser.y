/* vim: set filetype=racc : */

class Einstein::GeneratedParser

/* Punctuators */
token LSHIFT  /* << */
token RSHIFT  /* >> */
token RAISE   /* ** */

/* Terminal types */
token NUMBER
token IDENT

rule
  Statement:
    BitwiseOrExpr
  ;

  Literal:
    NUMBER { result = [:lit, val.first] }
  ;

  PrimaryExpr:
    "(" Statement ")" { result = val[1] }
  | IDENT             { result = [:resolve, val.first] }
  | Literal
  ;

  UnaryExpr:
    PrimaryExpr
  | "+" UnaryExpr { result = [:u_plus, val[1]] }
  | "-" UnaryExpr { result = [:u_minus, val[1]] }
  | "~" UnaryExpr { result = [:bitwise_not, val[1]] }
  ;

  ExponentExpr:
    UnaryExpr
  | ExponentExpr RAISE UnaryExpr { result = [:raise, val[0], val[2]] }
  ;

  MultiplicativeExpr:
    ExponentExpr
  | MultiplicativeExpr "*" ExponentExpr { result = [:multiply, val[0], val[2]] }
  | MultiplicativeExpr "/" ExponentExpr { result = [:divide, val[0], val[2]] }
  | MultiplicativeExpr "%" ExponentExpr { result = [:modulus, val[0], val[2]] }
  ;

  AdditiveExpr:
    MultiplicativeExpr
  | AdditiveExpr "+" MultiplicativeExpr { result = [:add, val[0], val[2]] }
  | AdditiveExpr "-" MultiplicativeExpr { result = [:subtract, val[0], val[2]] }
  ;

  ShiftExpr:
    AdditiveExpr
  | ShiftExpr LSHIFT AdditiveExpr { result = [:lshift, val[0], val[2]] }
  | ShiftExpr RSHIFT AdditiveExpr { result = [:rshift, val[0], val[2]] }
  ;

  BitwiseAndExpr:
    ShiftExpr
  | BitwiseAndExpr "&" ShiftExpr { result = [:bitwise_and, val[0], val[2]] }
  ;

  BitwiseXorExpr:
    BitwiseAndExpr
  | BitwiseXorExpr "^" BitwiseAndExpr { result = [:bitwise_xor, val[0], val[2]] }
  ;

  BitwiseOrExpr:
    BitwiseXorExpr
  | BitwiseOrExpr "|" BitwiseXorExpr { result = [:bitwise_or, val[0], val[2]] }
  ;
