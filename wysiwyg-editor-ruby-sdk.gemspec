require File.expand_path('../lib/froala-editor-sdk/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = "Froala Labs"
  gem.description   = "Ruby SDK for Froala Editor"
  gem.summary       = "Ruby on Rails SDK for Froala WYSIWYG Editor."
  gem.homepage      = "https://github.com/froala/wysiwyg-editor-ruby-sdk"
  gem.licenses      = "MIT"

  gem.files         = Dir["{lib}/**/*"]
  gem.name          = "froala-editor-sdk"
  gem.require_paths = ['lib']
  gem.version       = FroalaEditorSDK::Version::String

  gem.add_dependency 'mime-types', '~> 3.1'
  gem.add_dependency 'wysiwyg-rails', '~> 2.6'
  gem.add_dependency 'mini_magick', '~> 4.5.0'
end