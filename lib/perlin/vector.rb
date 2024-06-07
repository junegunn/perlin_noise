module Perlin
  class Vector
    def self.[](*elements)
      Vector.new(elements)
    end

    def initialize(elements)
      @elements = elements
    end

    def to_a
      @elements
    end

    def r
      Math.sqrt(@elements.sum { |e| e**2 })
    end

    def [](i)
      @elements[i]
    end

    def map(&block)
      Vector.new(@elements.map(&block))
    end

    def +(other)
      Vector.new(@elements.zip(other.to_a).map { |a, b| a + b })
    end

    def -(other)
      Vector.new(@elements.zip(other.to_a).map { |a, b| a - b })
    end

    def /(scalar)
      Vector.new(@elements.map { |e| e / scalar })
    end

    def inner_product(other)
      @elements.zip(other.to_a).sum { |a, b| a * b }
    end
  end
end
