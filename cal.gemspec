# -*- encoding: utf-8 -*-
require File.expand_path('../lib/cal/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Austin Schneider"]
  gem.email         = ["austinthecoder@gmail.com"]
  gem.description   = "A low level calendar engine."
  gem.summary       = "A low level calendar engine."
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "cal"
  gem.require_paths = ["lib"]
  gem.version       = Cal::VERSION

  gem.add_dependency "activesupport", ">= 2"

  gem.add_development_dependency "rspec", "~> 2.10.0"
end
