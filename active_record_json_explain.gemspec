# frozen_string_literal: true

require_relative 'lib/active_record_json_explain/version'

Gem::Specification.new do |spec|
  spec.name          = 'active_record_json_explain'
  spec.version       = ActiveRecordJsonExplain::VERSION
  spec.authors       = ['Madogiwa']
  spec.email         = ['madogiwa0124@gmail.com']

  spec.summary       = 'Possible to get EXPLAIN in JSON format.'
  spec.description   = 'This gem extends `ActiveRecord::Relation#explain` to make it possible to get EXPLAIN in JSON format.'
  spec.homepage      = 'https://github.com/Madogiwa0124/active_record_json_explain'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
