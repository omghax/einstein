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
    UnaryExpr
  ;

  UnaryExpr:
    "+" UnaryExpr { result = UnaryPlusNode.new(val[1]) }
  | "-" UnaryExpr { result = UnaryMinusNode.new(val[1]) }
  | Literal
  ;

  Literal:
    NUMBER { result = NumberNode.new(val.first) }
  ;

---- header
  require "einstein/nodes"

---- inner
  include Einstein::Nodes
