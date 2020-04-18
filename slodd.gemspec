# -*- encoding: utf-8 -*-
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "slodd/version"
require "English"

Gem::Specification.new do |gem|
  gem.name          = "slodd"
  gem.version       = Slodd::VERSION
  gem.authors       = ["Ed Robinson"]
  gem.email         = ["ed.robinson@reevoo.com"]
  gem.description   = "Schema Loading On Dependent Databases"
  gem.summary       = "Schema Loading On Dependent Databases"
  gem.homepage      = "https://github.com/errm/slodd"
  gem.licenses      = ["MIT"]

  gem.files         = `git ls-files`.split($RS)
  gem.executables   = gem.files.grep(/^bin\//).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(/^(test|spec|features)\//)
  gem.require_paths = ["lib"]
  gem.add_dependency("activerecord", "~> 3.2")
  gem.add_dependency("mysql2", "~> 0.3.21")
  gem.add_development_dependency("rspec")
  gem.add_development_dependency("rake")
  gem.add_development_dependency("reevoocop")
  gem.add_development_dependency("simplecov")
end
