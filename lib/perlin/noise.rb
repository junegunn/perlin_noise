module Perlin
  class Noise
    DEFAULT_OPTIONS = {
      :interval => 256,
      :curve => Perlin::Curve::QUINTIC,
      :seed => nil
    }

    def initialize(dim, options = {})
      options = DEFAULT_OPTIONS.merge options

      @dim = dim
      @interval = options.fetch(:interval)
      @curve = options.fetch(:curve)
      @seed = options.fetch(:seed)

      raise ArgumentError.new('Invalid dimension: must be a positive integer')  unless @dim.is_a?(Integer) && @dim > 0
      raise ArgumentError.new('Invalid interval: must be a positive integer')   unless @interval.is_a?(Integer) && @interval > 0
      raise ArgumentError.new('Invalid curve specified: must be a Proc object') unless @curve.is_a?(Proc)
      raise ArgumentError.new('Invalid seed: must be a number')                 unless @seed.nil? || @seed.is_a?(Numeric)

      # Generate pseudo-random gradient vector for each grid point
      @gradient_table = Perlin::GradientTable.new @dim, @interval, @seed
    end

    # @param [*coords] Coordinates
    # @return [Float] Noise value between (-1..1)
    def [](*coords)
      raise ArgumentError.new("Invalid coordinates") unless coords.length == @dim

      coords = Vector[*coords]
      cell = Vector[*coords.map(&:to_i)]
      diff = coords - cell

      # Calculate noise factor at each surrouning vertex
      nf = {}
      iterate @dim, 2 do |idx|
        idx = Vector[*idx]

        # "The value of each gradient ramp is computed by means of a scalar
        # product (dot product) between the gradient vectors of each grid point
        # and the vectors from the grid points."
        gv = @gradient_table[*(cell + idx).to_a]
        nf[idx.to_a] = gv.inner_product(diff - idx)
      end

      dim = @dim
      diff.to_a.each do |u|
        bu = @curve.call u

        # Pair-wise interpolation, trimming down dimensions
        iterate dim, 2 do |idx1|
          next if idx1.first == 1

          idx2 = idx1.dup
          idx2[0] = 1
          idx3 = idx1[1..-1]

          nf[idx3] = nf[idx1] + bu * (nf[idx2] - nf[idx1])
        end
        dim -= 1
      end
      (nf[[]] + 1) * 0.5
    end

    private

    def iterate(dim, length, &block)
      iterate_recursive dim, length, Array.new(dim, 0), &block
    end

    def iterate_recursive(dim, length, idx, &block)
      length.times do |i|
        idx[dim - 1] = i
        if dim == 1
          yield idx
        else
          iterate_recursive dim - 1, length, idx, &block
        end
      end
    end
  end
end
