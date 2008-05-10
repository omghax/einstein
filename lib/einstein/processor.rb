require "rubygems"
require "sexp_processor"

module Einstein
  class Processor < SexpProcessor
    def initialize
      super
      self.auto_shift_type = true
      self.strict = true
    end
  end
end
