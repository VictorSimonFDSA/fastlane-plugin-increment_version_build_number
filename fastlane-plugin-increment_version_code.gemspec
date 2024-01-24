# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/increment_version_build_number/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-increment_version_build_number'
  spec.version       = Fastlane::IncrementVersionBuildNumber::VERSION
  spec.author        = %q{Jems}
  spec.email         = %q{victor.simon@fdsa.es}

  spec.summary       = %q{Increment the version buld number of your android project with versionCode like versionCode versionMajor * 10000 + versionMinor * 1000 + versionPatch * 100 + versionBuild.}
  spec.homepage      = "https://github.com/VictorSimonFDSA/fastlane-plugin-increment_version_build_number"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  # spec.add_dependency 'your-dependency', '~> 1.0.0'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'fastlane', '>= 1.99.0'
end
