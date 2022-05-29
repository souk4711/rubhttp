# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubhttp/version'

Gem::Specification.new do |spec|
  spec.name          = 'rubhttp'
  spec.version       = Rubhttp::VERSION
  spec.authors       = ['John Doe']
  spec.email         = ['johndoe@example.com']

  spec.summary       = 'An HTTP client library.'
  spec.description   = 'An HTTP client library.'
  spec.homepage      = 'https://github.com/souk4711/rubhttp'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set
  # the 'allowed_push_host', to allow pushing to a single host or delete
  # this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'

    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/souk4711/rubhttp'
    spec.metadata['changelog_uri'] = 'https://github.com/souk4711/rubhttp'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been
  # added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'addressable', '~> 2.0'
  spec.add_runtime_dependency 'http', '~> 3.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.74'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.35'

  spec.add_development_dependency 'childprocess', '~> 1.0'
  spec.add_development_dependency 'sinatra', '~> 2.0'
end
