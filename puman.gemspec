# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'puman/version'

Gem::Specification.new do |spec|
  spec.name          = "puman"
  spec.version       = Puman::VERSION
  spec.authors       = ["pi-chan"]
  spec.email         = ["xoyip@piyox.info"]

  spec.summary       = "CLI utility for puma-dev."
  spec.homepage      = "https://github.com/pi-chan/puman"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0.1"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "fakefs"
  spec.add_development_dependency "pry-byebug"
  spec.add_dependency "thor"
end
