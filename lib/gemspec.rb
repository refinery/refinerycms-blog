#!/usr/bin/env ruby
require File.expand_path('../refinerycms-blog.rb', __FILE__)
version = ::Refinery::Blog.version
raise "Could not get version so gemspec can not be built" if version.nil?
files = Dir.glob("**/*").flatten.reject do |file|
  file =~ /\.gem(spec)?$/
end

gemspec = <<EOF
Gem::Specification.new do |s|
  s.name              = %q{refinerycms-blog}
  s.version           = %q{#{version}}
  s.description       = %q{A really straightforward open source Ruby on Rails blog engine designed for integration with RefineryCMS.}
  s.date              = %q{#{Time.now.strftime('%Y-%m-%d')}}
  s.summary           = %q{Ruby on Rails blogging engine for RefineryCMS.}
  s.email             = %q{info@refinerycms.com}
  s.homepage          = %q{http://refinerycms.com}
  s.authors           = %w(Resolve\\ Digital Neoteric\\ Design)
  s.require_paths     = %w(lib)

  s.files             = %w(
    #{files.join("\n    ")}
  )
  #{"s.test_files        = %w(
    #{Dir.glob("test/**/*.rb").join("\n    ")}
  )" if File.directory?("test")}
end
EOF

File.open(File.expand_path("../../refinerycms-blog.gemspec", __FILE__), 'w').puts(gemspec)