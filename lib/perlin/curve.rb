# frozen_string_literal: true

module Perlin
  module Curve
    LINEAR  = proc { |t| t }
    CUBIC   = proc { |t| 3 * (t**2) - 2 * (t**3) }
    QUINTIC = proc { |t| 6 * (t**5) - 15 * (t**4) + 10 * (t**3) }

    # Returns a Proc object which applies S-curve function to
    # a given number between 0 and 1.
    # @param[Proc] curve
    # @param[Integer] times
    # @return[Proc]
    def self.contrast(curve, times)
      lambda { |n|
        times.times do
          n = curve.call n
        end
        n
      }
    end
  end
end
