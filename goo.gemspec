# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'goo/version'

Gem::Specification.new do |spec|
  spec.name          = "goo"
  spec.version       = Goo::VERSION
  spec.authors       = ["Shem Ming"]
  spec.email         = ["shemusok@gmail.com"]

  spec.summary       = %q{tiny command line Google API client.}
  spec.description   = %q{Just 4 fun.}
  spec.homepage      = "https://github.com/shemusok/goo"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "google-api-client", '>= 0.8', '<0.9'
  spec.add_dependency "thor"
  spec.add_dependency "dotenv"
end
