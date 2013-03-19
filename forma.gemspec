# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'forma/version'

Gem::Specification.new do |spec|
  spec.name          = 'forma'
  spec.version       = Forma::VERSION
  spec.authors       = ['Dimitri Kurashvili']
  spec.email         = ['dimitri@c12.ge']
  spec.description   = %q{killer forms for ruby}
  spec.summary       = %q{highly informative and flexible forms with ruby}
  spec.homepage      = 'http://github.com/dimakura/forma'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
