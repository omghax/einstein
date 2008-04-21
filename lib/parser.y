/* vim: set filetype=racc : */

class Einstein::GeneratedParser

/* Literals */
token TRUE FALSE

/* punctuators */
token LSHIFT  /* << */
token RSHIFT  /* >> */

/* Terminal types */
token NUMBER
token IDENT

rule
  SourceElements:
    SourceElement
  | SourceElements SourceElement { result = val.flatten }
  ;

  SourceElement:
    BitwiseOrExpr
  ;

  BitwiseOrExpr:
    BitwiseXorExpr
  | BitwiseOrExpr "|" BitwiseXorExpr { result = BitwiseOrNode.new(val[0], val[2]) }
  ;

  BitwiseXorExpr:
    BitwiseAndExpr
  | BitwiseXorExpr "^" BitwiseAndExpr { result = BitwiseXorNode.new(val[0], val[2]) }
  ;

  BitwiseAndExpr:
    ShiftExpr
  | BitwiseAndExpr "&" ShiftExpr { result = BitwiseAndNode.new(val[0], val[2]) }
  ;

  ShiftExpr:
    AdditiveExpr
  | ShiftExpr LSHIFT AdditiveExpr { result = LeftShiftNode.new(val[0], val[2]) }
  | ShiftExpr RSHIFT AdditiveExpr { result = RightShiftNode.new(val[0], val[2]) }
  ;

  AdditiveExpr:
    MultiplicativeExpr
  | AdditiveExpr "+" MultiplicativeExpr { result = AddNode.new(val[0], val[2]) }
  | AdditiveExpr "-" MultiplicativeExpr { result = SubtractNode.new(val[0], val[2]) }
  ;

  MultiplicativeExpr:
    UnaryExpr
  | MultiplicativeExpr "*" UnaryExpr { result = MultiplyNode.new(val[0], val[2]) }
  | MultiplicativeExpr "/" UnaryExpr { result = DivideNode.new(val[0], val[2]) }
  | MultiplicativeExpr "%" UnaryExpr { result = ModulusNode.new(val[0], val[2]) }
  ;

  UnaryExpr:
    PrimaryExpr
  | "+" UnaryExpr { result = UnaryPlusNode.new(val[1]) }
  | "-" UnaryExpr { result = UnaryMinusNode.new(val[1]) }
  | "~" UnaryExpr { result = BitwiseNotNode.new(val[1]) }
  ;

  PrimaryExpr:
    Literal
  | IDENT { result = ResolveNode.new(val.first) }
  ;

  Literal:
    NUMBER { result = NumberNode.new(val.first) }
  ;

---- header
  require "einstein/nodes"

---- inner
  include Einstein::Nodes
