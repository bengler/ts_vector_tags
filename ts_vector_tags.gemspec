# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "ts_vector_tags"
  s.version      = "0.0.2"
  s.authors     = ["Simen Svale Skogsrud", "Katrina Owen"]
  s.email       = ["simen@bengler.no", "katrina@bengler.no"]
  s.homepage    = ""
  s.summary     = %q{Super simple tag mixin for postgresql and activerecord}
  s.description = %q{Extremely simple, if somewhat exotic, mixin that uses the tsvector feature in postgresql to add tags to an ActiveRecord model.}

  s.rubyforge_project = "ts_vector_tags"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
end
