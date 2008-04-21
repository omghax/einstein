/* vim: set filetype=racc : */

class Einstein::GeneratedParser

/* Literals */
token TRUE FALSE

/* Terminal types */
token NUMBER
token IDENT

rule
  SourceElements:
    SourceElement
  | SourceElements SourceElement { result = val.flatten }
  ;

  SourceElement:
    AdditiveExpr
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
    Literal
  | "+" UnaryExpr { result = UnaryPlusNode.new(val[1]) }
  | "-" UnaryExpr { result = UnaryMinusNode.new(val[1]) }
  ;

  Literal:
    NUMBER { result = NumberNode.new(val.first) }
  ;

---- header
  require "einstein/nodes"

---- inner
  include Einstein::Nodes
