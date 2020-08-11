# Encoding: utf-8

Gem::Specification.new do |s|
  s.name              = %q{refinerycms-blog}
  s.version           = %q{5.0.0}
  s.description       = %q{A really straightforward open source Ruby on Rails blog engine designed for integration with Refinery CMS.}
  s.summary           = %q{Ruby on Rails blogging engine for Refinery CMS.}
  s.email             = %q{info@refinerycms.com}
  s.homepage          = %q{https://www.refinerycms.com/blog}
  s.authors           = ['Philip Arndt', 'Uģis Ozols', 'Joe Sak']
  s.require_paths     = %w(lib)
  s.license           = %q{MIT}

  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- spec/*`.split("\n")

  # Runtime dependencies
  s.add_dependency    'refinerycms-core',      '~> 4.0'
  s.add_dependency    'refinerycms-settings',  '~> 4.0'
  s.add_dependency    'filters_spam',          '~> 0.2'
  s.add_dependency    'acts-as-taggable-on',   '~> 6'
  s.add_dependency    'seo_meta',              ['>=3.0.0', '~>3.0']
  s.add_dependency    'rails_autolink',        '~> 1.1.3'
  s.add_dependency    'friendly_id',           ['>= 5.1.0', '< 5.3']
  s.add_dependency    'friendly_id-mobility',  '~> 0.5'
  s.add_dependency    'activemodel-serializers-xml', '~> 1.0', '>= 1.0.1'
  s.add_dependency    'responders',            '~> 2.0'


  s.cert_chain = [File.expand_path('certs/parndt.pem', __dir__)]
  if $PROGRAM_NAME =~ /gem\z/ && ARGV.include?('build') && ARGV.include?(__FILE__)
    s.signing_key = File.expand_path('~/.ssh/gem-private_key.pem')
  end
end
