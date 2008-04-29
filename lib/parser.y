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
    NUMBER { result = NumberNode.new(val.first) }
  ;

  PrimaryExpr:
    "(" Statement ")" { result = val[1] }
  | IDENT             { result = ResolveNode.new(val.first) }
  | Literal
  ;

  UnaryExpr:
    PrimaryExpr
  | "+" UnaryExpr { result = UnaryPlusNode.new(val[1]) }
  | "-" UnaryExpr { result = UnaryMinusNode.new(val[1]) }
  | "~" UnaryExpr { result = BitwiseNotNode.new(val[1]) }
  ;

  ExponentExpr:
    UnaryExpr
  | ExponentExpr RAISE UnaryExpr { result = ExponentNode.new(val[0], val[2]) }
  ;

  MultiplicativeExpr:
    ExponentExpr
  | MultiplicativeExpr "*" ExponentExpr { result = MultiplyNode.new(val[0], val[2]) }
  | MultiplicativeExpr "/" ExponentExpr { result = DivideNode.new(val[0], val[2]) }
  | MultiplicativeExpr "%" ExponentExpr { result = ModulusNode.new(val[0], val[2]) }
  ;

  AdditiveExpr:
    MultiplicativeExpr
  | AdditiveExpr "+" MultiplicativeExpr { result = AddNode.new(val[0], val[2]) }
  | AdditiveExpr "-" MultiplicativeExpr { result = SubtractNode.new(val[0], val[2]) }
  ;

  ShiftExpr:
    AdditiveExpr
  | ShiftExpr LSHIFT AdditiveExpr { result = LeftShiftNode.new(val[0], val[2]) }
  | ShiftExpr RSHIFT AdditiveExpr { result = RightShiftNode.new(val[0], val[2]) }
  ;

  BitwiseAndExpr:
    ShiftExpr
  | BitwiseAndExpr "&" ShiftExpr { result = BitwiseAndNode.new(val[0], val[2]) }
  ;

  BitwiseXorExpr:
    BitwiseAndExpr
  | BitwiseXorExpr "^" BitwiseAndExpr { result = BitwiseXorNode.new(val[0], val[2]) }
  ;

  BitwiseOrExpr:
    BitwiseXorExpr
  | BitwiseOrExpr "|" BitwiseXorExpr { result = BitwiseOrNode.new(val[0], val[2]) }
  ;

---- header
  require "einstein/nodes"

---- inner
  include Einstein::Nodes
