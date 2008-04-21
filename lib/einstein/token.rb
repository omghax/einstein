module Einstein
  class Token
    def initialize(name, value, &transformer)
      @name        = name
      @value       = value
      @transformer = transformer
    end

    attr_accessor :name
    attr_accessor :value
    attr_accessor :transformer

    def to_racc_token
      return transformer.call(name, value) if transformer
      [name, value]
    end
  end
end
