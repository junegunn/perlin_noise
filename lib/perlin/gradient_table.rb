module Perlin
  class GradientTable
    # Bit-wise AND operation is not any faster than MOD in Ruby
    # MOD operation returns positive number for negative input
    def initialize dim, interval = 256
      @dim = dim
      @interval = interval

      @table   = Array.new(interval) { rand @interval }
      @vectors = Array.new(interval) { random_unit_vector }
    end

    def [] *coords
      @vectors[index *coords]
    end

  private
    # A simple hashing
    def index *coords
      s = coords.last
      coords.reverse[1..-1].each do |c|
        s = perm(s) + c
      end
      perm(s)
    end

    def perm s
      @table[s % @interval]
    end

    def random_unit_vector
      while true
        v = Vector[*Array.new(@dim) { rand * 2 - 1 }]
        # Discards vectors whose length greater than 1 to avoid bias in distribution
        break if v.r > 0 && v.r <= 1
      end
      r = v.r
      v.map { |e| e / v.r }
    end
  end
end
