# frozen_string_literal: true

module Perlin
  if RUBY_VERSION =~ /^1\.8\./
    class Random
      def initialize(*seed)
        # FIXME: Sets the global seed value; this is misleading
        srand *seed
      end

      def rand(*interval)
        Kernel.rand(*interval)
      end
    end
  else
    Random = ::Random
  end

  class GradientTable
    # Bit-wise AND operation is not any faster than MOD in Ruby
    # MOD operation returns positive number for negative input
    def initialize dim, interval = 256, seed = nil
      @dim = dim
      @interval = interval
      @random = Random.new(*[seed].compact)

      @table   = Array.new(interval) { @random.rand @interval }
      @vectors = Array.new(interval) { random_unit_vector }
    end

    def [](*coords)
      @vectors[index(*coords)]
    end

    private

    # A simple hashing
    def index(*coords)
      s = coords.last
      coords.reverse[1..-1].each do |c|
        s = perm(s) + c
      end
      perm(s)
    end

    def perm(s)
      @table[s % @interval]
    end

    def random_unit_vector
      while true
        v = Vector[*Array.new(@dim) { @random.rand * 2 - 1 }]
        # Discards vectors whose length greater than 1 to avoid bias in
        # distribution
        break if v.r > 0 && v.r <= 1
      end
      v.map { |e| e / v.r }
    end
  end
end
