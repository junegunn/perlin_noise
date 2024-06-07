# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "perlin/version"

Gem::Specification.new do |s|
  s.name        = "perlin_noise"
  s.version     = Perlin::VERSION
  s.authors     = ["Junegunn Choi"]
  s.email       = ["junegunn.c@gmail.com"]
  s.homepage    = "https://github.com/junegunn/perlin_noise"
  s.license     = 'MIT'
  s.summary     = %q{Perlin noise generator}
  s.description = %q{Perlin noise implemented in Ruby}

  s.rubyforge_project = "perlin"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rake"
  s.add_development_dependency "test-unit"
  s.add_development_dependency "rubocop"
end
