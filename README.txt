= Einstein

== Description

The Einstein library provides a simple arithmetic parser for Ruby apps. Sure,
you could just use eval, but then you're opening yourself up to a world of
hurt when you accept code from untrusted sources (ie. your users). With
Einstein, you get a safe, "locked-down" arithmetic parser and evaluator that
can't run system commands or otherwise hose your server in the event of a
malicious code snippet.

Einstein was built as an excercise in language parsing in Ruby. I'm releasing
it in the hopes that someone will find the code useful, or learn something
from it...or, better yet, teach me a thing or two about writing parsers :-P

== Examples

To parse an arithmetic expression:

  >> Einstein.evaluate("3 + 4")
  => 7

You can also use variables:

  >> Einstein.evaluate("x * 3", :x => 2)
  => 6

You can also have Einstein parse the expression and return the syntax tree:

  >> ast = Einstein.parse("x ** 2")
  => (x ** 2)

You can then evaluate this tree for different values of x:

  >> ast.evaluate(:x => 2)
  => 4
  >> ast.evaluate(:x => 3)
  => 9

Or you can return an s-expression representation of the tree:

  >> ast.to_sexp
  => [:exponent, [:resolve, "x"], [:lit, 2]]

== Authors

Copyright (c) 2008 by Dray Lacy

== License

Einstein is licensed under the MIT License.

:include:License.txt
