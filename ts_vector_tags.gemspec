# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ts_vector_tags/version"

Gem::Specification.new do |s|
  s.name        = "ts_vector_tags"
  s.version     = TsVectorTags::VERSION
  s.authors     = ["Simen Svale Skogsrud"]
  s.email       = ["simen@bengler.no"]
  s.homepage    = ""
  s.summary     = %q{Super simple tag mixin for postgresql}
  s.description = %q{Extremely simple, if somewhat exotic, mixin that uses the tsvector feature in postgresql to add tags to an ActiveRecord model.}

  s.rubyforge_project = "ts_vector_tags"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_runtime_dependency "activerecord"
end
