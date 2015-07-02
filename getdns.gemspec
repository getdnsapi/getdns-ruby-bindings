require 'rubygems'
require 'rubygems/package_task'
require 'find'

Gem::Specification.new do |s|
  s.name = "getdns-ruby"
  s.version = "0.0.1"
  s.date = Time.now
  s.email = "nitsingh@verisign.com"
  s.authors = ["Verisign, Inc"]
  s.summary = "a Ruby binding to Getdns"
  s.files = Dir['lib/**/*.rb'] + Dir['ext/**/*.bundle'] + Dir['ext/**/*.dylib'] + Dir['ext/**/*.so']  + Dir['ext/**/*']
  s.extensions = %w(ext/getdns/extconf.rb)
  s.executables = []
  s.extra_rdoc_files = %w(ext/getdns/getdns.cpp)
  s.rdoc_options = %w(-c utf8 --main README --title Getnds)
  s.description = "Getnds-Ruby is a Ruby binding to Getnds."


  # specify any dependencies here; for example:
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'awesome_print'
end
