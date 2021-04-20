$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require 'paperclip/version'

Gem::Specification.new do |s|
  s.name              = "paperclip"
  s.version           = Paperclip::VERSION
  s.platform          = Gem::Platform::RUBY
  s.author            = "Jon Yurek"
  s.email             = ["jyurek@thoughtbot.com"]
  s.homepage          = "https://github.com/thoughtbot/paperclip"
  s.summary           = "File attachments as attributes for ActiveRecord"
  s.description       = "Easy upload management for ActiveRecord"
  s.license           = "MIT"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.metadata['allowed_push_host'] = 'https://rubygems.pkg.github.com/appfolio'

  s.requirements << "ImageMagick"
  s.required_ruby_version = ">= 2.1.0"

  s.add_dependency('activemodel', ['>= 6', '< 7'])
  s.add_dependency('activesupport', ['>= 6', '< 7'])
  s.add_dependency('terrapin', ['>= 0.6', '< 0.7'])
  s.add_dependency('mime-types', ['>= 3.3', '< 4'])
  s.add_dependency('mimemagic', ['>= 0.3.0', '< 0.4'])
end
