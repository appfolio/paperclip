# frozen_string_literal: true

require_relative 'lib/paperclip/version'

Gem::Specification.new do |spec|
  spec.name          = 'paperclip'
  spec.version       = Paperclip::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.author        = 'AppFolio'
  spec.email         = 'dev@appfolio.com'
  spec.description   = 'Easy upload management for ActiveRecord'
  spec.summary       = 'File attachments as attributes for ActiveRecord'
  spec.homepage      = 'https://github.com/appfolio/paperclip'
  spec.license       = 'MIT'
  spec.files         = Dir['**/*'].select { |f| f[/^(lib\/|.*gemspec)/] }
  spec.require_paths = ['lib']
  spec.requirements << 'ImageMagick'

  spec.metadata['allowed_push_host'] = 'https://rubygems.pkg.github.com/appfolio'

  spec.add_dependency('activemodel', ['>= 6', '< 7.1'])
  spec.add_dependency('activesupport', ['>= 6', '< 7.1'])
  spec.add_dependency('terrapin', ['>= 0.6', '< 0.7'])
  spec.add_dependency('marcel', ['>= 1.0.1', '< 2'])
  spec.add_dependency('mime-types', ['>= 3.3', '< 4'])
end
