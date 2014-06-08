# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elb/version'

Gem::Specification.new do |spec|
  spec.name          = "elb"
  spec.version       = Elb::VERSION
  spec.authors       = ["Tung Nguyen"]
  spec.email         = ["tongueroo@gmail.com"]
  spec.description   = %q{Tool to gracefully restart app servers without affecting users}
  spec.summary       = %q{Tool to gracefully restart app servers without affecting users.}
  spec.homepage      = "https://github.com/br/elb"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"
  spec.add_dependency "aws-sdk"
  spec.add_dependency "hashie"
  spec.add_dependency "colorize"
  spec.add_dependency "nokogiri", "1.5.11" # fix for 1.8.7

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  if RUBY_VERSION != "1.8.7"
    spec.add_development_dependency "guard"
    spec.add_development_dependency "guard-bundler"
    spec.add_development_dependency "guard-rspec"
  end
end
