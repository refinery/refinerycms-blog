# Encoding: UTF-8

Gem::Specification.new do |s|
  s.name              = %q{refinerycms-blog}
  s.version           = %q{4.0.0}
  s.description       = %q{A really straightforward open source Ruby on Rails blog engine designed for integration with Refinery CMS.}
  s.summary           = %q{Ruby on Rails blogging engine for Refinery CMS.}
  s.email             = %q{info@refinerycms.com}
  s.homepage          = %q{http://refinerycms.com/blog}
  s.authors           = ['Philip Arndt', 'Uģis Ozols', 'Joe Sak']
  s.require_paths     = %w(lib)
  s.license           = %q{MIT}

  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- spec/*`.split("\n")

  # Runtime dependencies
  s.add_dependency    'refinerycms-core',      '~> 4.0'
  s.add_dependency    'refinerycms-settings',  '~> 4.0'
  s.add_dependency    'filters_spam',          '~> 0.2'
  s.add_dependency    'acts-as-taggable-on'
  s.add_dependency    'seo_meta',              ['>=3.0.0', '~>3.0']
  s.add_dependency    'rails_autolink',        '~> 1.1.3'
  s.add_dependency    'friendly_id',           ['< 5.3', '>= 5.1.0']
  s.add_dependency    'globalize',             ['>= 5.1.0.beta1', '< 5.2']
  s.add_dependency    'activemodel-serializers-xml', '~> 1.0', '>= 1.0.1'
  s.add_dependency    'jquery-ui-rails',       '~> 5.0.0'
end
